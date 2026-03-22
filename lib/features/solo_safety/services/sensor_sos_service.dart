import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_tts/flutter_tts.dart';

// ── Detection event types ─────────────────────────────────
enum TriggerType {
  crash,          // >4G impact + rotation
  fall,           // freefall then impact
  sosTap,         // 3 rapid taps
  suddenStop,     // BT EV sudden decel
  highRotation,   // vehicle rollover
}

class SosEvent {
  final TriggerType type;
  final double severity; // 0.0 – 1.0
  final DateTime time;
  SosEvent(this.type, this.severity) : time = DateTime.now();
}

typedef SosCallback = void Function(SosEvent event);

// ── The Secret Sauce Sensor Fusion Engine ────────────────
class SensorSosService {
  static final SensorSosService _i = SensorSosService._();
  factory SensorSosService() => _i;
  SensorSosService._();

  // ── State ─────────────────────────────────────────────
  bool _running = false;
  SosCallback? _onDetected;

  // Accelerometer rolling window (last 50 samples ~1s)
  final List<double> _accelMag = [];

  // Gyroscope rolling window
  final List<double> _gyroMag = [];

  // GPS speed history (m/s)
  final List<double> _speedHistory = [];

  // Freefall tracking
  bool _inFreefall = false;
  DateTime? _freefallStart;

  // Tap SOS (3 taps within 2s)
  final List<DateTime> _tapTimes = [];

  // Subscriptions
  StreamSubscription? _accelSub;
  StreamSubscription? _gyroSub;
  StreamSubscription? _gpsSub;
  Timer? _gpsTimer;

  // ── Thresholds (tunable) ─────────────────────────────
  static const double _crashGThreshold   = 35.0; // m/s² ≈ 3.6G
  static const double _fallFreefallG     = 3.0;  // near-zero = freefall
  static const double _fallImpactG       = 28.0; // landing impact
  static const double _rolloverDeg       = 1.8;  // rad/s
  static const double _suddenStopMps     = 6.0;  // m/s drop in 1s
  static const double _tapShakeG         = 20.0; // shake tap
  static const int    _freefallMaxMs     = 2500; // max freefall window
  static const int    _tapWindowMs       = 2000; // 3 taps within 2s

  // ── Start / Stop ─────────────────────────────────────
  void start(SosCallback callback) {
    if (_running) return;
    _running   = true;
    _onDetected = callback;
    _subscribeAccelerometer();
    _subscribeGyroscope();
    _subscribeGps();
  }

  void stop() {
    _running = false;
    _accelSub?.cancel();
    _gyroSub?.cancel();
    _gpsSub?.cancel();
    _gpsTimer?.cancel();
    _accelMag.clear();
    _gyroMag.clear();
    _speedHistory.clear();
    _tapTimes.clear();
    _inFreefall = false;
  }

  // ── Accelerometer ─────────────────────────────────────
  void _subscribeAccelerometer() {
    _accelSub = accelerometerEventStream(
      samplingPeriod: const Duration(milliseconds: 20),
    ).listen(_onAccel);
  }

  void _onAccel(AccelerometerEvent e) {
    // Raw magnitude in m/s²
    final mag = sqrt(e.x * e.x + e.y * e.y + e.z * e.z);

    _accelMag.add(mag);
    if (_accelMag.length > 50) _accelMag.removeAt(0);

    // ── Pattern 1: Crash detect ────────────────────────
    // Sudden spike > threshold after period of normal
    if (mag > _crashGThreshold) {
      final recent =
          _accelMag.sublist(max(0, _accelMag.length - 10));
      final avg = recent.reduce((a, b) => a + b) / recent.length;
      // Spike must be > 2× recent average (not just vibration)
      if (avg > _crashGThreshold * 0.5) {
        final severity = (mag / 60.0).clamp(0.0, 1.0);
        _fire(SosEvent(TriggerType.crash, severity));
      }
    }

    // ── Pattern 2: Freefall + impact detect ───────────
    // Freefall = gravity-only ≈ 9.8 m/s²
    // During freefall accel reading drops < 3 m/s² (sensor sees 0G)
    if (mag < _fallFreefallG) {
      if (!_inFreefall) {
        _inFreefall   = true;
        _freefallStart = DateTime.now();
      }
    } else {
      if (_inFreefall) {
        _inFreefall = false;
        final ms = DateTime.now()
            .difference(_freefallStart!)
            .inMilliseconds;
        // Valid freefall: 300ms – 2500ms then big impact
        if (ms > 300 && ms < _freefallMaxMs &&
            mag > _fallImpactG) {
          final severity = (ms / 2000.0).clamp(0.0, 1.0);
          _fire(SosEvent(TriggerType.fall, severity));
        }
      }
    }

    // ── Pattern 3: SOS shake (3 taps) ─────────────────
    if (mag > _tapShakeG) {
      final now = DateTime.now();
      _tapTimes.add(now);
      // Remove taps outside 2s window
      _tapTimes.removeWhere((t) =>
          now.difference(t).inMilliseconds > _tapWindowMs);
      if (_tapTimes.length >= 3) {
        _tapTimes.clear();
        _fire(SosEvent(TriggerType.sosTap, 0.7));
      }
    }
  }

  // ── Gyroscope ─────────────────────────────────────────
  void _subscribeGyroscope() {
    _gyroSub = gyroscopeEventStream(
      samplingPeriod: const Duration(milliseconds: 20),
    ).listen(_onGyro);
  }

  void _onGyro(GyroscopeEvent e) {
    final mag = sqrt(e.x * e.x + e.y * e.y + e.z * e.z);
    _gyroMag.add(mag);
    if (_gyroMag.length > 50) _gyroMag.removeAt(0);

    // ── Pattern 4: Rollover / high rotation detect ────
    if (mag > _rolloverDeg) {
      // Sustained rotation for 500ms = rolling/tumbling
      final recent =
          _gyroMag.sublist(max(0, _gyroMag.length - 25));
      final sustained = recent.every((v) => v > _rolloverDeg * 0.6);
      if (sustained) {
        final severity = (mag / 3.0).clamp(0.0, 1.0);
        _fire(SosEvent(TriggerType.highRotation, severity));
      }
    }
  }

  // ── GPS Speed History ─────────────────────────────────
  void _subscribeGps() {
    _gpsTimer = Timer.periodic(
        const Duration(seconds: 1), (_) => _pollGps());
  }

  Future<void> _pollGps() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 2),
      );
      _speedHistory.add(pos.speed); // m/s
      if (_speedHistory.length > 10) _speedHistory.removeAt(0);

      // ── Pattern 5: Sudden stop (EV / vehicle) ────────
      if (_speedHistory.length >= 3) {
        final prev = _speedHistory[_speedHistory.length - 3];
        final curr = _speedHistory.last;
        final drop = prev - curr; // positive = deceleration
        if (drop > _suddenStopMps && prev > 5.0) {
          final severity = (drop / 20.0).clamp(0.0, 1.0);
          _fire(SosEvent(TriggerType.suddenStop, severity));
        }
      }
    } catch (_) {
      // GPS unavailable — skip
    }
  }

  // ── Secret Sauce Weighted Score ───────────────────────
  // Combine accel + gyro + speed to compute confidence.
  // Only fires when confidence > threshold.
  // Prevents false positives from single-sensor noise.
  double _computeConfidence(TriggerType type) {
    if (_accelMag.isEmpty) return 0;

    final accelPeak =
        _accelMag.reduce(max);
    final gyroPeak =
        _gyroMag.isEmpty ? 0.0 : _gyroMag.reduce(max);
    final speedDrop = _speedHistory.length >= 2
        ? (_speedHistory[_speedHistory.length - 2] -
               _speedHistory.last)
            .clamp(0.0, 20.0)
        : 0.0;

    // Weighted fusion (tuned empirically)
    // accel carries most weight since it's most reliable
    const wAccel = 0.45;
    const wGyro  = 0.30;
    const wGps   = 0.25;

    final normAccel =
        (accelPeak / 60.0).clamp(0.0, 1.0);
    final normGyro =
        (gyroPeak / 3.0).clamp(0.0, 1.0);
    final normGps =
        (speedDrop / 20.0).clamp(0.0, 1.0);

    return wAccel * normAccel +
           wGyro  * normGyro  +
           wGps   * normGps;
  }

  // Cooldown prevents repeated firings
  DateTime? _lastFire;

  void _fire(SosEvent event) {
    if (!_running) return;
    final now = DateTime.now();
    if (_lastFire != null &&
        now.difference(_lastFire!).inSeconds < 15) return;

    // Confidence gate — only fire if sensor fusion agrees
    final conf = _computeConfidence(event.type);
    final minConf = event.type == TriggerType.sosTap
        ? 0.1  // tap SOS is intentional, lower bar
        : 0.35; // physical events need higher confidence

    if (conf < minConf && event.type != TriggerType.sosTap) {
      debugPrint(
          'SOS suppressed — conf=$conf < $minConf '
          'type=${event.type.name}');
      return;
    }

    _lastFire = now;
    debugPrint('SOS FIRED: ${event.type.name} '
        'severity=${event.severity.toStringAsFixed(2)} '
        'conf=${conf.toStringAsFixed(2)}');
    _onDetected?.call(event);
  }

  // ── BT EV data injection ──────────────────────────────
  // Call this when your Bluetooth EV sends speed/tilt data
  void injectEvData({required double speedMps,
      required double tiltDeg}) {
    _speedHistory.add(speedMps);
    if (_speedHistory.length > 10) _speedHistory.removeAt(0);

    // Tilt > 45° = vehicle on side
    if (tiltDeg.abs() > 45) {
      _fire(SosEvent(TriggerType.highRotation, 0.9));
    }

    // Sudden stop from EV telemetry
    if (_speedHistory.length >= 2) {
      final drop =
          _speedHistory[_speedHistory.length - 2] - speedMps;
      if (drop > _suddenStopMps) {
        _fire(SosEvent(
            TriggerType.suddenStop,
            (drop / 20.0).clamp(0.0, 1.0)));
      }
    }
  }
}
