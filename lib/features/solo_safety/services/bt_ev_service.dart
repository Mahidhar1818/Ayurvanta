import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'sensor_sos_service.dart';

class BtEvService {
  static final BtEvService _i = BtEvService._();
  factory BtEvService() => _i;
  BtEvService._();

  BluetoothDevice? _connected;
  StreamSubscription? _scanSub;
  StreamSubscription? _charSub;
  bool _isScanning = false;

  // Common EV/cycling BLE service UUIDs
  // Cycling Speed & Cadence: 0x1816
  // Heart Rate (for wearables): 0x180D
  // Custom EV UUIDs should be added here
  static const List<Guid> _evServiceUuids = [];

  ValueNotifier<String> status =
      ValueNotifier('Disconnected');
  ValueNotifier<double> evSpeed   = ValueNotifier(0);
  ValueNotifier<double> evTilt    = ValueNotifier(0);
  ValueNotifier<double> evBattery = ValueNotifier(0);

  // ── Scan & Connect ───────────────────────────────────
  Future<void> startScan() async {
    if (_isScanning) return;
    _isScanning = true;
    status.value = 'Requesting permissions...';

    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    if (statuses[Permission.bluetoothScan] != PermissionStatus.granted &&
        statuses[Permission.bluetoothConnect] != PermissionStatus.granted) {
      // It might be already granted or the OS handles it differently (like iOS)
      // We will still proceed, but usually you'd show a dialog.
      // Let's just aggressively check for Android 12+ where it's tightly enforced.
    }

    status.value = 'Scanning...';

    final btState = await FlutterBluePlus.adapterState.first;
    if (btState != BluetoothAdapterState.on) {
      status.value = 'Bluetooth off';
      _isScanning = false;
      return;
    }

    await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 10));

    _scanSub = FlutterBluePlus.scanResults.listen((results) {
      for (final r in results) {
        // Look for EV/bike devices by name pattern
        final name = r.device.platformName.toLowerCase();
        if (name.contains('ev') ||
            name.contains('bike') ||
            name.contains('scooter') ||
            name.contains('electric') ||
            name.contains('vehicle')) {
          FlutterBluePlus.stopScan();
          _connect(r.device);
          break;
        }
      }
    });

    // Stop scan after timeout
    Future.delayed(const Duration(seconds: 10), () {
      FlutterBluePlus.stopScan();
      _isScanning = false;
      if (_connected == null) {
        status.value = 'No EV device found';
      }
    });
  }

  Future<void> _connect(BluetoothDevice device) async {
    try {
      status.value = 'Connecting...';
      await device.connect(timeout: const Duration(seconds: 8));
      _connected = device;
      status.value = '✓ Connected: ${device.platformName}';

      device.connectionState.listen((state) {
        if (state == BluetoothConnectionState.disconnected) {
          status.value = 'Disconnected';
          _connected = null;
        }
      });

      _discoverServices(device);
    } catch (e) {
      status.value = 'Connection failed';
    }
  }

  Future<void> _discoverServices(BluetoothDevice device) async {
    final services = await device.discoverServices();
    for (final service in services) {
      for (final char in service.characteristics) {
        if (char.properties.notify || char.properties.read) {
          await char.setNotifyValue(true);
          _charSub = char.onValueReceived.listen((data) {
            _parseEvData(data);
          });
        }
      }
    }
  }

  // ── Parse raw BLE bytes from EV ──────────────────────
  // This handles the most common EV/e-bike BLE data formats
  void _parseEvData(List<int> data) {
    if (data.isEmpty) return;

    double speed = 0;
    double tilt  = 0;
    double batt  = 0;

    try {
      // Format A: [speed_high, speed_low, tilt_signed, battery%]
      if (data.length >= 4) {
        speed = ((data[0] << 8 | data[1]) / 100.0); // km/h
        tilt  = (data[2].toSigned(8)).toDouble();    // degrees
        batt  = data[3].toDouble();                  // 0-100%
      }
      // Format B: single byte speed
      else if (data.length == 1) {
        speed = data[0].toDouble();
      }

      evSpeed.value   = speed;
      evTilt.value    = tilt;
      evBattery.value = batt;

      // Inject into sensor fusion engine
      SensorSosService().injectEvData(
        speedMps: speed / 3.6, // convert km/h → m/s
        tiltDeg: tilt,
      );
    } catch (e) {
      debugPrint('BT data parse error: $e');
    }
  }

  Future<void> disconnect() async {
    _scanSub?.cancel();
    _charSub?.cancel();
    await _connected?.disconnect();
    _connected = null;
    status.value = 'Disconnected';
  }

  bool get isConnected => _connected != null;
}
