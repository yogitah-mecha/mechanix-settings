import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mechanix_settings/features/wireless/data/repositories/wireless_repository.dart';
import 'package:mechanix_settings/features/wireless/blocs/wireless_event.dart';
import 'package:mechanix_settings/features/wireless/blocs/wireless_state.dart';

export 'wireless_event.dart';
export 'wireless_state.dart';

class WirelessBloc extends Bloc<WirelessEvent, WirelessState> {
  final WirelessRepository _repository;
  Timer? _scanTimer;
  Timer? _connectTimer;

  WirelessBloc(this._repository) : super(const WirelessState()) {
    on<LoadWireless>(_onLoadWireless);
    on<ToggleWirelessPower>(_onToggleWirelessPower);
    on<ScanNetworks>(_onScanNetworks);
    on<ConnectToNetworkEvent>(_onConnectToNetwork);
    on<AddNetworkEvent>(_onAddNetwork);
    on<UpdateNetworkSettingsEvent>(_onUpdateNetworkSettings);
    on<ForgetNetworkEvent>(_onForgetNetwork);
  }

  Future<void> _onLoadWireless(
    LoadWireless event,
    Emitter<WirelessState> emit,
  ) async {
    final myNets = await _repository.getSavedNetworks();
    final availNets = await _repository.getAvailableNetworks();

    // Find connected network name if any
    String? connectedName;
    for (var n in myNets) {
      if (n.isConnected) connectedName = n.name;
    }
    for (var n in availNets) {
      if (n.isConnected) connectedName = n.name;
    }

    emit(
      state.copyWith(
        savedNetworks: myNets,
        availableNetworks: availNets,
        connectedNetworkName: connectedName,
      ),
    );
  }

  Future<void> _onToggleWirelessPower(
    ToggleWirelessPower event,
    Emitter<WirelessState> emit,
  ) async {
    _scanTimer?.cancel();
    _connectTimer?.cancel();

    if (event.isEnabled) {
      emit(
        state.copyWith(
          isWirelessOn: true,
          isScanning: true,
          connectingNetworkName: null,
        ),
      );

      // Fetch lists
      final myNets = await _repository.getSavedNetworks();
      final availNets = await _repository.getAvailableNetworks();

      // Trigger automatic scan complete in 1.5 seconds
      add(const ScanNetworks());

      emit(state.copyWith(savedNetworks: myNets, availableNetworks: availNets));
    } else {
      emit(
        state.copyWith(
          isWirelessOn: false,
          isScanning: false,
          connectingNetworkName: null,
          connectedNetworkName: null,
        ),
      );
    }
  }

  Future<void> _onScanNetworks(
    ScanNetworks event,
    Emitter<WirelessState> emit,
  ) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (state.isWirelessOn) {
      emit(state.copyWith(isScanning: false));
    }
  }

  Future<void> _onConnectToNetwork(
    ConnectToNetworkEvent event,
    Emitter<WirelessState> emit,
  ) async {
    emit(state.copyWith(connectingNetworkName: event.name));

    // Update connection status in local repository
    await _repository.connectToNetwork(event.name, event.password);

    if (state.isWirelessOn) {
      final myNets = await _repository.getSavedNetworks();
      final availNets = await _repository.getAvailableNetworks();

      emit(
        state.copyWith(
          savedNetworks: myNets,
          availableNetworks: availNets,
          connectingNetworkName: null,
          connectedNetworkName: event.name,
        ),
      );
    }
  }

  Future<void> _onAddNetwork(
    AddNetworkEvent event,
    Emitter<WirelessState> emit,
  ) async {
    await _repository.addNetwork(event.name);
    final savedNetworks = await _repository.getSavedNetworks();
    emit(state.copyWith(savedNetworks: savedNetworks));
  }

  Future<void> _onUpdateNetworkSettings(
    UpdateNetworkSettingsEvent event,
    Emitter<WirelessState> emit,
  ) async {
    await _repository.updateNetwork(event.network);
    final myNets = await _repository.getSavedNetworks();
    final availNets = await _repository.getAvailableNetworks();

    emit(state.copyWith(savedNetworks: myNets, availableNetworks: availNets));
  }

  Future<void> _onForgetNetwork(
    ForgetNetworkEvent event,
    Emitter<WirelessState> emit,
  ) async {
    await _repository.forgetNetwork(event.network);

    final savedNetworks = await _repository.getSavedNetworks();
    final availableNetworks = await _repository.getAvailableNetworks();

    emit(
      state.copyWith(
        savedNetworks: savedNetworks,
        availableNetworks: availableNetworks,
        connectedNetworkName: state.connectedNetworkName == event.network.name
            ? null
            : state.connectedNetworkName,
        connectingNetworkName: state.connectingNetworkName == event.network.name
            ? null
            : state.connectingNetworkName,
      ),
    );
  }

  @override
  Future<void> close() {
    _scanTimer?.cancel();
    _connectTimer?.cancel();
    return super.close();
  }
}
