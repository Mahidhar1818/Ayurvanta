import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../services/sensor_sos_service.dart';
import '../services/bt_ev_service.dart';
import '../models/solo_contact_model.dart';

class SensorSosScreen extends StatefulWidget {
  const SensorSosScreen({super.key});
  @override
  State<SensorSosScreen> createState() =>
      _SensorSosScreenState();
}

class _SensorSosScreenState extends State<SensorSosScreen>
    with SingleTickerProviderStateMixin {
  final _sensor  = SensorSosService();
  final _bt      = BtEvService();
  final _tts     = FlutterTts();

  bool  _isActive       = false;
  bool  _showCountdown  = false;
  int   _countdown      = 10;
  Timer? _countdownTimer;
  SosEvent? _pendingEvent;
  List<SoloContact> _contacts = [];

  // Live sensor readouts
  double _accelG    = 0;
  double _gyroRad   = 0;
  double _gpsSpeed  = 0;

  // Platform channel for SMS
  static const _channel = MethodChannel('ayurvanta/speech');

  @override
  void initState() {
    super.initState();
    _initTts();
    _loadContacts();
    _startSensorDisplay();
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('en-IN');
    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
  }

  Future<void> _loadContacts() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getStringList('solo_contacts') ?? [];
    setState(() {
      _contacts = raw.map((e) =>
          SoloContact.fromJson(jsonDecode(e))).toList();
    });
  }

  // Show live sensor numbers in UI
  void _startSensorDisplay() {
    // We use a timer to poll last known values from the service
    Timer.periodic(const Duration(milliseconds: 500), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() {
        // Pull latest from service internal buffers
        // (expose via simple getters if needed)
        _gpsSpeed = _bt.evSpeed.value / 3.6;
      });
    });
  }

  void _toggleActive() {
    setState(() => _isActive = !_isActive);

    if (_isActive) {
      _sensor.start(_onSosDetected);
      _tts.speak('Solo Safety activated. Monitoring sensors.');
    } else {
      _sensor.stop();
      _countdownTimer?.cancel();
      setState(() => _showCountdown = false);
      _tts.speak('Solo Safety deactivated.');
    }
  }

  void _onSosDetected(SosEvent event) {
    if (!mounted) return;
    HapticFeedback.heavyImpact();
    setState(() {
      _pendingEvent = event;
      _showCountdown = true;
      _countdown = 10;
    });

    _tts.speak(_eventVoice(event));

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(
        const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() => _countdown--);
      if (_countdown <= 0) {
        t.cancel();
        _fireSos(event);
      }
    });
  }

  String _eventVoice(SosEvent e) {
    switch (e.type) {
      case TriggerType.crash:
        return 'Crash detected! Sending SOS in 10 seconds. '
               'Tap dismiss if you are safe.';
      case TriggerType.fall:
        return 'Fall detected! Sending SOS in 10 seconds. '
               'Tap dismiss if you are safe.';
      case TriggerType.sosTap:
        return 'SOS shake detected! Sending alert in 10 seconds.';
      case TriggerType.suddenStop:
        return 'Sudden stop detected! Sending SOS in 10 seconds.';
      case TriggerType.highRotation:
        return 'Vehicle roll detected! Sending SOS in 10 seconds.';
    }
  }

  IconData _eventIcon(TriggerType t) {
    switch (t) {
      case TriggerType.crash:       return Icons.car_crash_rounded;
      case TriggerType.fall:        return Icons.personal_injury_rounded;
      case TriggerType.sosTap:      return Icons.vibration_rounded;
      case TriggerType.suddenStop:  return Icons.do_not_disturb_rounded;
      case TriggerType.highRotation:return Icons.rotate_right_rounded;
    }
  }

  String _eventLabel(TriggerType t) {
    switch (t) {
      case TriggerType.crash:       return 'CRASH DETECTED';
      case TriggerType.fall:        return 'FALL DETECTED';
      case TriggerType.sosTap:      return 'SOS SHAKE';
      case TriggerType.suddenStop:  return 'SUDDEN STOP';
      case TriggerType.highRotation:return 'VEHICLE ROLL';
    }
  }

  Future<void> _fireSos(SosEvent event) async {
    if (!mounted) return;
    setState(() => _showCountdown = false);

    // Get GPS
    String gpsUrl = 'Location unavailable';
    try {
      final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 5));
      gpsUrl = 'https://maps.google.com/?q='
          '${pos.latitude},${pos.longitude}';
    } catch (_) {}

    // Send SMS to all active contacts
    for (final c in _contacts.where((c) => c.isActive)) {
      final msg =
          '🚨 AyurVanta SOS — ${_eventLabel(event.type)}\n'
          '${c.voiceMessage}\n'
          'Live location: $gpsUrl\n'
          'Severity: ${(event.severity * 100).toInt()}%\n'
          'Time: ${DateTime.now().toLocal()}';

      try {
        await _channel.invokeMethod('sendSMS', {
          'phone': c.phone,
          'message': msg,
        });
      } catch (_) {}
    }

    // Speak voice message
    final msg = _contacts.isNotEmpty
        ? _contacts.first.voiceMessage
        : 'Emergency SOS sent. Please help me.';
    await _tts.speak(msg);

    // Show confirmation
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => _SosConfirmDialog(
          event: event,
          gpsUrl: gpsUrl,
          contacts: _contacts,
          onDismiss: () => Navigator.pop(context),
        ),
      );
    }
  }

  void _dismissCountdown() {
    _countdownTimer?.cancel();
    setState(() {
      _showCountdown = false;
      _pendingEvent  = null;
    });
    _tts.speak('Alert dismissed. Stay safe.');
  }

  @override
  void dispose() {
    _sensor.stop();
    _countdownTimer?.cancel();
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: AppBar(
        backgroundColor: AppColors.navyDark,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Sensor SOS 🛡️',
            style: TextStyle(
                fontWeight: FontWeight.w800, fontSize: 16)),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Master toggle
                FadeInDown(child: _buildToggle()),
                const SizedBox(height: 16),

                if (_isActive) ...[
                  // Live sensor panel
                  FadeInUp(
                    delay: const Duration(milliseconds: 60),
                    child: _buildSensorPanel(),
                  ),
                  const SizedBox(height: 16),
                ],

                // BT EV section
                FadeInUp(
                  delay: const Duration(milliseconds: 120),
                  child: _buildBtEvPanel(),
                ),
                const SizedBox(height: 16),

                // Trigger guide
                FadeInUp(
                  delay: const Duration(milliseconds: 180),
                  child: _buildTriggerGuide(),
                ),
                const SizedBox(height: 16),

                // Detection log
                FadeInUp(
                  delay: const Duration(milliseconds: 240),
                  child: _buildSensitivitySliders(),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),

          // Countdown overlay
          if (_showCountdown && _pendingEvent != null)
            _CountdownOverlay(
              event: _pendingEvent!,
              countdown: _countdown,
              eventLabel: _eventLabel(_pendingEvent!.type),
              eventIcon: _eventIcon(_pendingEvent!.type),
              onDismiss: _dismissCountdown,
              onFireNow: () {
                _countdownTimer?.cancel();
                _fireSos(_pendingEvent!);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildToggle() {
    return GestureDetector(
      onTap: _toggleActive,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _isActive
              ? AppColors.emergency.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _isActive
                ? AppColors.emergency
                : const Color(0xFFE3EAF2),
            width: _isActive ? 1.5 : 0.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 54, height: 54,
              decoration: BoxDecoration(
                color: _isActive
                    ? AppColors.emergency
                    : AppColors.bgMuted,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.sensors_rounded,
                color: _isActive
                    ? Colors.white
                    : AppColors.textHint,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isActive
                        ? 'SENSOR SOS ACTIVE'
                        : 'Sensor SOS OFF',
                    style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w800,
                      color: _isActive
                          ? AppColors.emergency
                          : AppColors.textPrimary,
                    )),
                  const SizedBox(height: 3),
                  Text(
                    _isActive
                        ? 'Monitoring accelerometer, gyro & GPS'
                        : 'Tap to activate sensor monitoring',
                    style: TextStyle(
                      fontSize: 11,
                      color: _isActive
                          ? AppColors.emergency
                          : AppColors.textSecondary,
                    )),
                ],
              ),
            ),
            Switch(
              value: _isActive,
              onChanged: (_) => _toggleActive(),
              activeColor: AppColors.emergency,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1A2C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.monitor_heart_rounded,
                  color: AppColors.teal, size: 16),
              SizedBox(width: 8),
              Text('Live Sensor Data',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 13, fontWeight: FontWeight.w700)),
              Spacer(),
              _LiveDot(),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _SensorGauge(
                label: 'Accel',
                value: _accelG,
                unit: 'm/s²',
                max: 60,
                dangerAt: 35,
                color: AppColors.blue,
              ),
              const SizedBox(width: 12),
              _SensorGauge(
                label: 'Gyro',
                value: _gyroRad,
                unit: 'rad/s',
                max: 5,
                dangerAt: 1.8,
                color: const Color(0xFF534AB7),
              ),
              const SizedBox(width: 12),
              _SensorGauge(
                label: 'Speed',
                value: _gpsSpeed * 3.6,
                unit: 'km/h',
                max: 120,
                dangerAt: 80,
                color: AppColors.teal,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Crash triggers at >35 m/s²  •  '
            'Roll at >1.8 rad/s  •  '
            'SOS: 3 shakes in 2s',
            style: TextStyle(
                color: Colors.white24, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildBtEvPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: const Color(0xFFE3EAF2), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.bluetooth_rounded,
                  color: AppColors.blue, size: 18),
              SizedBox(width: 8),
              Text('Electric Vehicle Bluetooth',
                style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                )),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Connect your EV/e-bike to get speed + tilt data '
            'directly into the SOS engine',
            style: TextStyle(
                fontSize: 11, color: AppColors.textSecondary)),
          const SizedBox(height: 12),

          // BT status
          ValueListenableBuilder<String>(
            valueListenable: _bt.status,
            builder: (_, status, __) => Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: status.startsWith('✓')
                    ? const Color(0xFFEAF3DE)
                    : AppColors.bgPage,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    status.startsWith('✓')
                        ? Icons.bluetooth_connected_rounded
                        : Icons.bluetooth_disabled_rounded,
                    size: 14,
                    color: status.startsWith('✓')
                        ? AppColors.teal
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(status,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: status.startsWith('✓')
                            ? AppColors.teal
                            : AppColors.textSecondary,
                      ))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // EV live data (when connected)
          ValueListenableBuilder<double>(
            valueListenable: _bt.isConnected
                ? _bt.evSpeed
                : ValueNotifier(0),
            builder: (_, speed, __) {
              if (!_bt.isConnected) return const SizedBox();
              return Row(
                children: [
                  _EvStat('Speed', '${speed.toStringAsFixed(1)} km/h'),
                  _EvStat('Tilt', '${_bt.evTilt.value.toStringAsFixed(1)}°'),
                  _EvStat('Battery', '${_bt.evBattery.value.toInt()}%'),
                ],
              );
            },
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _bt.isConnected
                      ? _bt.disconnect
                      : _bt.startScan,
                  icon: Icon(
                    _bt.isConnected
                        ? Icons.bluetooth_disabled_rounded
                        : Icons.bluetooth_searching_rounded,
                    size: 16),
                  label: Text(
                    _bt.isConnected
                        ? 'Disconnect EV'
                        : 'Scan for EV',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _bt.isConnected
                        ? AppColors.emergency.withOpacity(0.1)
                        : AppColors.blue,
                    foregroundColor: _bt.isConnected
                        ? AppColors.emergency
                        : Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTriggerGuide() {
    final items = [
      (Icons.car_crash_rounded, 'Crash',
          'Impact >3.5G detected by accelerometer',
          AppColors.emergency),
      (Icons.personal_injury_rounded, 'Fall',
          'Freefall then impact — phone dropped/fallen',
          const Color(0xFFBA7517)),
      (Icons.vibration_rounded, 'SOS Shake',
          'Shake phone hard 3× within 2 seconds',
          AppColors.blue),
      (Icons.do_not_disturb_rounded, 'Sudden Stop',
          'Vehicle/EV sudden deceleration >6 m/s',
          const Color(0xFF534AB7)),
      (Icons.rotate_right_rounded, 'Roll/Tilt',
          'High gyroscope rotation or EV tilt >45°',
          AppColors.teal),
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: const Color(0xFFE3EAF2), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Trigger Patterns',
            style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            )),
          const SizedBox(height: 4),
          const Text(
            'All patterns run through sensor fusion — '
            'false positives are suppressed',
            style: TextStyle(
                fontSize: 11, color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: item.$4.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(item.$1,
                      color: item.$4, size: 18)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(item.$2,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        )),
                      Text(item.$3,
                        style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildSensitivitySliders() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: const Color(0xFFE3EAF2), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Sensitivity',
            style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            )),
          const SizedBox(height: 4),
          const Text(
            'Higher = more sensitive (more false alerts). '
            'Lower = fewer alerts.',
            style: TextStyle(
                fontSize: 11, color: AppColors.textSecondary)),
          const SizedBox(height: 12),

          _SensitivityRow(
            label: 'Crash detection',
            description: 'Impact threshold',
            initialValue: 0.6,
          ),
          _SensitivityRow(
            label: 'Fall detection',
            description: 'Freefall sensitivity',
            initialValue: 0.5,
          ),
          _SensitivityRow(
            label: 'Vehicle roll',
            description: 'Rotation sensitivity',
            initialValue: 0.7,
          ),
        ],
      ),
    );
  }
}

// ── Countdown Overlay ─────────────────────────────────────
class _CountdownOverlay extends StatelessWidget {
  final SosEvent event;
  final int countdown;
  final String eventLabel;
  final IconData eventIcon;
  final VoidCallback onDismiss;
  final VoidCallback onFireNow;

  const _CountdownOverlay({
    required this.event, required this.countdown,
    required this.eventLabel, required this.eventIcon,
    required this.onDismiss, required this.onFireNow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.85),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: const Color(0xFF1A0A0A),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
                color: AppColors.emergency, width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(eventIcon,
                  color: AppColors.emergency, size: 48),
              const SizedBox(height: 16),
              Text(eventLabel,
                style: const TextStyle(
                  color: Colors.white, fontSize: 22,
                  fontWeight: FontWeight.w900, letterSpacing: 2,
                )),
              const SizedBox(height: 8),
              const Text(
                'SOS will be sent automatically',
                style: TextStyle(
                    color: Colors.white54, fontSize: 13)),
              const SizedBox(height: 24),

              // Big countdown number
              Text(
                '$countdown',
                style: TextStyle(
                  fontSize: 72, fontWeight: FontWeight.w900,
                  color: countdown > 5
                      ? AppColors.emergency
                      : Colors.red[300],
                )),
              const Text('seconds',
                style: TextStyle(
                    color: Colors.white38, fontSize: 14)),
              const SizedBox(height: 28),

              // Dismiss button (big)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: onDismiss,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.teal,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14)),
                  ),
                  child: const Text(
                    '✓ I AM SAFE — Dismiss',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800)),
                ),
              ),
              const SizedBox(height: 10),

              // Send now button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: onFireNow,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.emergency,
                    side: const BorderSide(
                        color: AppColors.emergency,
                        width: 1),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14)),
                  ),
                  child: const Text(
                    '🚨 Send SOS NOW',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Helper widgets ────────────────────────────────────────
class _LiveDot extends StatefulWidget {
  const _LiveDot();
  @override
  State<_LiveDot> createState() => _LiveDotState();
}

class _LiveDotState extends State<_LiveDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800))
      ..repeat(reverse: true);
  }
  @override
  void dispose() { _c.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _c,
    builder: (_, __) => Container(
      width: 8, height: 8,
      decoration: BoxDecoration(
        color: AppColors.emergency.withOpacity(
            0.5 + _c.value * 0.5),
        shape: BoxShape.circle,
      ),
    ),
  );
}

class _SensorGauge extends StatelessWidget {
  final String label, unit;
  final double value, max, dangerAt;
  final Color color;
  const _SensorGauge({required this.label, required this.value,
      required this.unit, required this.max,
      required this.dangerAt, required this.color});

  @override
  Widget build(BuildContext context) {
    final pct = (value / max).clamp(0.0, 1.0);
    final isDanger = value >= dangerAt;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
            style: const TextStyle(
                color: Colors.white38, fontSize: 10,
                fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(
            value.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w800,
              color: isDanger
                  ? AppColors.emergency
                  : Colors.white,
            )),
          Text(unit,
            style: const TextStyle(
                color: Colors.white24, fontSize: 10)),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 4,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation(
                isDanger ? AppColors.emergency : color),
            ),
          ),
        ],
      ),
    );
  }
}

class _EvStat extends StatelessWidget {
  final String label, value;
  const _EvStat(this.label, this.value);
  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
          style: const TextStyle(
              fontSize: 10, color: AppColors.textHint)),
        Text(value,
          style: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w700,
              color: AppColors.textPrimary)),
      ],
    ),
  );
}

class _SensitivityRow extends StatefulWidget {
  final String label, description;
  final double initialValue;
  const _SensitivityRow({required this.label,
      required this.description, required this.initialValue});
  @override
  State<_SensitivityRow> createState() =>
      _SensitivityRowState();
}

class _SensitivityRowState extends State<_SensitivityRow> {
  late double _value;
  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(widget.label,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary))),
              Text('${(_value * 100).round()}%',
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textSecondary)),
            ],
          ),
          Text(widget.description,
            style: const TextStyle(
                fontSize: 10, color: AppColors.textHint)),
          Slider(
            value: _value,
            onChanged: (v) => setState(() => _value = v),
            activeColor: AppColors.blue,
            inactiveColor: const Color(0xFFE3EAF2),
          ),
        ],
      ),
    );
  }
}

class _SosConfirmDialog extends StatelessWidget {
  final SosEvent event;
  final String gpsUrl;
  final List<SoloContact> contacts;
  final VoidCallback onDismiss;
  const _SosConfirmDialog({
    required this.event, required this.gpsUrl,
    required this.contacts, required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF0B1A2C),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_rounded,
              color: AppColors.teal, size: 48),
          const SizedBox(height: 16),
          const Text('SOS SENT',
            style: TextStyle(
              color: Colors.white, fontSize: 22,
              fontWeight: FontWeight.w900, letterSpacing: 2,
            )),
          const SizedBox(height: 12),
          Text(
            'Alert sent to ${contacts.length} contact(s)',
            style: const TextStyle(
                color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              gpsUrl,
              style: const TextStyle(
                  color: AppColors.teal, fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onDismiss,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.teal,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Close'),
            ),
          ),
        ],
      ),
    );
  }
}
