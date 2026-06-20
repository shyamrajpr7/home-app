import 'dart:async';
import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../config/constants.dart';

class BleDevice {
  final String name;
  final String id;
  final int rssi;

  BleDevice({required this.name, required this.id, required this.rssi});
}

class BleService {
  StreamSubscription? _scanSubscription;
  final List<BleDevice> _discoveredDevices = [];

  Future<bool> get isBluetoothEnabled async {
    final state = await FlutterBluePlus.adapterState.first;
    return state == BluetoothAdapterState.on;
  }

  Stream<bool> get bluetoothStateStream {
    return FlutterBluePlus.adapterState.map(
      (state) => state == BluetoothAdapterState.on,
    );
  }

  Future<void> startScan({
    required void Function(BleDevice device) onDeviceFound,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    _discoveredDevices.clear();

    if (!await isBluetoothEnabled) {
      await FlutterBluePlus.turnOn();
    }

    await FlutterBluePlus.startScan(
      withServices: [Guid(AppConstants.bleServiceUUID)],
      timeout: timeout,
    );

    _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      for (final result in results) {
        if (result.device.platformName.isNotEmpty) {
          final device = BleDevice(
            name: result.device.platformName,
            id: result.device.remoteId.str,
            rssi: result.rssi,
          );
          if (!_discoveredDevices.any((d) => d.id == device.id)) {
            _discoveredDevices.add(device);
            onDeviceFound(device);
          }
        }
      }
    });
  }

  Future<void> stopScan() async {
    await _scanSubscription?.cancel();
    await FlutterBluePlus.stopScan();
  }

  Future<void> sendWifiCredentials({
    required String deviceId,
    required String ssid,
    required String password,
  }) async {
    final device = FlutterBluePlus.connectedDevices
        .firstWhere((d) => d.remoteId.str == deviceId, orElse: () => throw Exception('Device not connected'));

    final services = await device.discoverServices();
    for (final service in services) {
      if (service.uuid.str == AppConstants.bleServiceUUID) {
        for (final characteristic in service.characteristics) {
          if (characteristic.uuid.str ==
              AppConstants.bleCharacteristicUUID) {
            final payload = jsonEncode({
              'ssid': ssid,
              'password': password,
            });
            await characteristic.write(
              utf8.encode(payload),
              withoutResponse: false,
            );
            return;
          }
        }
      }
    }
    throw Exception('Wi-Fi characteristic not found on device');
  }

  Future<String?> readDeviceStatus(String deviceId) async {
    final device = FlutterBluePlus.connectedDevices
        .firstWhere((d) => d.remoteId.str == deviceId, orElse: () => throw Exception('Device not connected'));

    final services = await device.discoverServices();
    for (final service in services) {
      if (service.uuid.str == AppConstants.bleServiceUUID) {
        for (final characteristic in service.characteristics) {
          if (characteristic.uuid.str ==
              AppConstants.bleCharacteristicUUID) {
            final value = await characteristic.read();
            return utf8.decode(value);
          }
        }
      }
    }
    return null;
  }

  void dispose() {
    _scanSubscription?.cancel();
  }
}
