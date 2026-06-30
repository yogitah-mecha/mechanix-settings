import 'dart:async';
import 'package:mechanix_settings/features/bluetooth/data/models/bluetooth_device.dart';

class BluetoothRepository {
  final List<BluetoothDevice> _devices = [
    const BluetoothDevice(
      name: 'Connect1',
      deviceName: 'My Phone',
      type: BluetoothDeviceType.mobile,
      isSaved: true,
      isConnected: false,
    ),
    const BluetoothDevice(
      name: 'Connect2',
      deviceName: "Test iPhone",
      type: BluetoothDeviceType.mobile,
      isSaved: false,
      isConnected: false,
    ),
    const BluetoothDevice(
      name: 'JBL speaker cinema',
      deviceName: 'JBL cinema',
      type: BluetoothDeviceType.speaker,
      isSaved: false,
      isConnected: false,
    ),
  ];

  Future<List<BluetoothDevice>> getPairedDevices() async {
    return _devices.where((d) => d.isSaved).toList();
  }

  Future<List<BluetoothDevice>> getDiscoveredDevices() async {
    return _devices.where((d) => !d.isSaved).toList();
  }

  Future<void> connectToDevice(String name) async {
    await Future.delayed(const Duration(seconds: 1));
    for (int i = 0; i < _devices.length; i++) {
      if (_devices[i].name == name) {
        _devices[i] = _devices[i].copyWith(
          isConnected: true,
          isConnecting: false,
          isSaved: true,
        );
      }
    }
  }

  Future<void> disconnectFromDevice(String name) async {
    for (int i = 0; i < _devices.length; i++) {
      if (_devices[i].name == name) {
        _devices[i] = _devices[i].copyWith(
          isConnected: false,
          isConnecting: false,
        );
      }
    }
  }

  Future<void> forgetDevice(String name) async {
    for (int i = 0; i < _devices.length; i++) {
      if (_devices[i].name == name) {
        _devices[i] = _devices[i].copyWith(
          isConnected: false,
          isConnecting: false,
          isSaved: false,
        );
      }
    }
  }

  String _localDeviceName = 'comet';

  Future<String> getLocalDeviceName() async {
    return _localDeviceName;
  }

  Future<void> updateLocalDeviceName(String name) async {
    _localDeviceName = name;
  }
}
