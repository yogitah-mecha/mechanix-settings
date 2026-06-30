import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mechanix_settings/core/utils/app_logger.dart';
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
    try {
      final myNets = await _repository.getSavedNetworks();
      final availNets = await _repository.getAvailableNetworks();

      // Find connected network name if any
      String? connectedName;

      for (final network in myNets) {
        if (network.isConnected) {
          connectedName = network.name;
        }
      }

      for (final network in availNets) {
        if (network.isConnected) {
          connectedName = network.name;
        }
      }

      emit(
        state.copyWith(
          savedNetworks: myNets,
          availableNetworks: availNets,
          connectedNetworkName: connectedName,
        ),
      );
    } catch (e, stackTrace) {
      AppLogger.e('Failed to load wireless networks: $e', stack: stackTrace);
    }
  }

  Future<void> _onToggleWirelessPower(
    ToggleWirelessPower event,
    Emitter<WirelessState> emit,
  ) async {
    try {
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

        emit(
          state.copyWith(savedNetworks: myNets, availableNetworks: availNets),
        );
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
    } catch (e, stackTrace) {
      AppLogger.e('Failed to toggle wireless: $e', stack: stackTrace);
    }
  }

  Future<void> _onScanNetworks(
    ScanNetworks event,
    Emitter<WirelessState> emit,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 1500));

      if (state.isWirelessOn) {
        emit(state.copyWith(isScanning: false));
      }
    } catch (e, stackTrace) {
      AppLogger.e('Failed to scan wireless networks: $e', stack: stackTrace);
    }
  }

  Future<void> _onConnectToNetwork(
    ConnectToNetworkEvent event,
    Emitter<WirelessState> emit,
  ) async {
    try {
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
    } catch (e, stackTrace) {
      AppLogger.e('Failed to connect to network: $e', stack: stackTrace);

      emit(state.copyWith(connectingNetworkName: null));
    }
  }

  Future<void> _onAddNetwork(
    AddNetworkEvent event,
    Emitter<WirelessState> emit,
  ) async {
    try {
      await _repository.addNetwork(event.name);

      final savedNetworks = await _repository.getSavedNetworks();

      emit(state.copyWith(savedNetworks: savedNetworks));
    } catch (e, stackTrace) {
      AppLogger.e('Failed to add network: $e', stack: stackTrace);
    }
  }

  Future<void> _onUpdateNetworkSettings(
    UpdateNetworkSettingsEvent event,
    Emitter<WirelessState> emit,
  ) async {
    try {
      await _repository.updateNetwork(event.network);

      final myNets = await _repository.getSavedNetworks();
      final availNets = await _repository.getAvailableNetworks();

      emit(state.copyWith(savedNetworks: myNets, availableNetworks: availNets));
    } catch (e, stackTrace) {
      AppLogger.e('Failed to update network settings: $e', stack: stackTrace);
    }
  }

  Future<void> _onForgetNetwork(
    ForgetNetworkEvent event,
    Emitter<WirelessState> emit,
  ) async {
    try {
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
          connectingNetworkName:
              state.connectingNetworkName == event.network.name
              ? null
              : state.connectingNetworkName,
        ),
      );
    } catch (e, stackTrace) {
      AppLogger.e('Failed to forget network: $e', stack: stackTrace);
    }
  }

  @override
  Future<void> close() {
    _scanTimer?.cancel();
    _connectTimer?.cancel();
    return super.close();
  }
}
