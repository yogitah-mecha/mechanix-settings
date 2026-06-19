import 'package:equatable/equatable.dart';
import 'package:mechanix_settings/features/wireless/data/models/wifi_network.dart';

abstract class WirelessEvent extends Equatable {
  const WirelessEvent();

  @override
  List<Object?> get props => [];
}

class LoadWireless extends WirelessEvent {
  const LoadWireless();
}

class ToggleWirelessPower extends WirelessEvent {
  final bool isEnabled;
  const ToggleWirelessPower(this.isEnabled);

  @override
  List<Object?> get props => [isEnabled];
}

class ScanNetworks extends WirelessEvent {
  const ScanNetworks();
}

class ConnectToNetworkEvent extends WirelessEvent {
  final String name;
  final String? password;
  const ConnectToNetworkEvent(this.name, this.password);

  @override
  List<Object?> get props => [name, password];
}

class AddNetworkEvent extends WirelessEvent {
  final String name;
  final String password;

  const AddNetworkEvent(this.name, this.password);

  @override
  List<Object?> get props => [name];
}

class UpdateNetworkSettingsEvent extends WirelessEvent {
  final WifiNetwork network;
  const UpdateNetworkSettingsEvent(this.network);

  @override
  List<Object?> get props => [network];
}

class ForgetNetworkEvent extends WirelessEvent {
  final WifiNetwork network;

  const ForgetNetworkEvent(this.network);
}
