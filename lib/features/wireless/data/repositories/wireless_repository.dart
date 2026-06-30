import 'dart:async';
import 'package:mechanix_settings/features/wireless/data/models/wifi_network.dart';

class WirelessRepository {
  // TODO : Remove later
  // Test data
  final List<WifiNetwork> _savedNetworks = [
    const WifiNetwork(
      name: 'office wifi 1',
      signalLevel: 3,
      isSecured: true,
      isConnected: false,
    ),
    const WifiNetwork(
      name: 'office wifi 2',
      signalLevel: 2,
      isSecured: true,
      isConnected: false,
    ),
  ];

  final List<WifiNetwork> _availableNetworks = [
    const WifiNetwork(
      name: 'New Office wifi 1',
      signalLevel: 3,
      isSecured: true,
      isConnected: false,
    ),
  ];

  Future<List<WifiNetwork>> getSavedNetworks() async {
    // Return a copy of the list
    return List.from(_savedNetworks);
  }

  Future<List<WifiNetwork>> getAvailableNetworks() async {
    return List.from(_availableNetworks);
  }

  Future<void> connectToNetwork(String name, String? password) async {
    // Simulate connection delay
    await Future.delayed(const Duration(seconds: 2));

    // Reset all networks to disconnected
    for (int i = 0; i < _savedNetworks.length; i++) {
      _savedNetworks[i] = _savedNetworks[i].copyWith(
        isConnected: false,
        isConnecting: false,
      );
    }
    for (int i = 0; i < _availableNetworks.length; i++) {
      _availableNetworks[i] = _availableNetworks[i].copyWith(
        isConnected: false,
        isConnecting: false,
      );
    }

    // Check if network is in my networks
    int myIndex = _savedNetworks.indexWhere((n) => n.name == name);
    if (myIndex != -1) {
      _savedNetworks[myIndex] = _savedNetworks[myIndex].copyWith(
        isConnected: true,
        isConnecting: false,
      );
      return;
    }

    // Check if network is in available networks. If so, move to my networks.
    int availIndex = _availableNetworks.indexWhere((n) => n.name == name);
    if (availIndex != -1) {
      final network = _availableNetworks[availIndex];
      _availableNetworks.removeAt(availIndex);
      _savedNetworks.add(
        network.copyWith(isConnected: true, isConnecting: false),
      );
    }
  }

  Future<void> addNetwork(String name) async {
    _savedNetworks.add(
      WifiNetwork(
        name: name,
        signalLevel: 3,
        isSecured: true,
        isConnected: false,
      ),
    );
  }

  Future<void> updateNetwork(WifiNetwork updatedNetwork) async {
    int myIndex = _savedNetworks.indexWhere(
      (n) => n.name == updatedNetwork.name,
    );
    if (myIndex != -1) {
      _savedNetworks[myIndex] = updatedNetwork;
      return;
    }

    int availIndex = _availableNetworks.indexWhere(
      (n) => n.name == updatedNetwork.name,
    );
    if (availIndex != -1) {
      _availableNetworks[availIndex] = updatedNetwork;
    }
  }

  Future<void> forgetNetwork(WifiNetwork network) async {
    final index = _savedNetworks.indexWhere((n) => n.name == network.name);

    if (index == -1) return;

    final removed = _savedNetworks.removeAt(index);

    _availableNetworks.add(
      removed.copyWith(isConnected: false, isConnecting: false),
    );
  }
}
