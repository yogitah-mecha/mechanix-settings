import 'package:equatable/equatable.dart';
import 'package:mechanix_settings/features/wireless/data/models/wifi_network.dart';

class WirelessState extends Equatable {
  static const _unset = Object();

  final bool isWirelessOn;
  final bool isScanning;
  final List<WifiNetwork> savedNetworks;
  final List<WifiNetwork> availableNetworks;
  final String? connectingNetworkName;
  final String? connectedNetworkName;

  const WirelessState({
    this.isWirelessOn = false,
    this.isScanning = false,
    this.savedNetworks = const [],
    this.availableNetworks = const [],
    this.connectingNetworkName,
    this.connectedNetworkName,
  });

  WirelessState copyWith({
    bool? isWirelessOn,
    bool? isScanning,
    List<WifiNetwork>? savedNetworks,
    List<WifiNetwork>? availableNetworks,
    Object? connectingNetworkName = _unset,
    Object? connectedNetworkName = _unset,
  }) {
    return WirelessState(
      isWirelessOn: isWirelessOn ?? this.isWirelessOn,
      isScanning: isScanning ?? this.isScanning,
      savedNetworks: savedNetworks ?? this.savedNetworks,
      availableNetworks: availableNetworks ?? this.availableNetworks,
      connectingNetworkName: connectingNetworkName == _unset
          ? this.connectingNetworkName
          : connectingNetworkName as String?,
      connectedNetworkName: connectedNetworkName == _unset
          ? this.connectedNetworkName
          : connectedNetworkName as String?,
    );
  }

  @override
  List<Object?> get props => [
    isWirelessOn,
    isScanning,
    savedNetworks,
    availableNetworks,
    connectingNetworkName,
    connectedNetworkName,
  ];
}
