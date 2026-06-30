import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mechanix_settings/core/constants/icons.dart';
import 'package:mechanix_settings/core/theme/app_theme.dart';
import 'package:mechanix_settings/core/widgets/custom_divider.dart';
import 'package:mechanix_settings/core/widgets/custom_image_asset.dart';
import 'package:mechanix_settings/core/widgets/custom_toggle.dart';
import 'package:mechanix_settings/features/wireless/blocs/wireless_bloc.dart';
import 'package:mechanix_settings/features/wireless/data/models/wifi_network.dart';
import 'package:mechanix_settings/features/wireless/presentation/screens/manage_network.dart';
import 'package:mechanix_settings/features/wireless/presentation/screens/network_detail.dart';
import 'package:mechanix_settings/features/wireless/presentation/widgets/wireless_password.dart';
import 'package:mechanix_settings/features/wireless/presentation/widgets/add_network.dart';
import 'package:mechanix_settings/features/wireless/presentation/widgets/network_list_item.dart';
import 'package:mechanix_settings/features/wireless/presentation/widgets/wireless_settings/settings_section_header.dart';
import 'package:mechanix_settings/l10n/app_localizations.dart';

class WirelessBody extends StatelessWidget {
  const WirelessBody({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<WirelessBloc, WirelessState>(
      builder: (context, state) {
        final isWirelessOn = state.isWirelessOn;
        final isScanning = state.isScanning;
        final myNetworks = state.savedNetworks;
        final availableNetworks = state.availableNetworks;
        final connectingNetwork = state.connectingNetworkName;
        final connectedNetwork = state.connectedNetworkName;

        final savedNetworks = myNetworks
            .where((network) => network.name != connectedNetwork)
            .toList();
        final connected = myNetworks
            .where((n) => n.name == connectedNetwork)
            .firstOrNull;

        return ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Wireless Toggle Row
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.wireless,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      CustomToggle(
                        value: isWirelessOn,
                        onChanged: (val) {
                          context.read<WirelessBloc>().add(
                            ToggleWirelessPower(val),
                          );
                        },
                        l10n: AppLocalizations.of(context)!,
                      ),
                    ],
                  ),
                ),
                const CustomDivider(verticalPadding: 0),
                if (isWirelessOn) ...[
                  // Toggled ON Section

                  // Scanning indicator
                  if (isScanning) ...[
                    SettingsSectionHeader(title: l10n.myNetworks),
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const CustomDivider(verticalPadding: 0),
                    SettingsSectionHeader(title: l10n.avaialableNetworks),
                  ] else ...[
                    // Connected Network Section
                    if (connected != null) ...[
                      NetworkListItem(
                        name: connected.name,
                        signalType: connected.signalType,
                        isConnected: true,
                        isConnecting: false,
                        isSelected: false,
                        onTap: () {},
                        onSettingsTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => NetworkDetailScreen(
                                networkName: connected.name,
                              ),
                            ),
                          );
                        },
                      ),
                      const CustomDivider(verticalPadding: 0),
                    ],
                    // Scanned Networks List
                    SettingsSectionHeader(title: l10n.myNetworks),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: savedNetworks.length,
                      itemBuilder: (context, index) {
                        final network = savedNetworks[index];
                        final isNetConnected = connectedNetwork == network.name;
                        final isNetConnecting =
                            connectingNetwork == network.name;

                        return Column(
                          children: [
                            NetworkListItem(
                              name: network.name,
                              isConnected: isNetConnected,
                              isConnecting: isNetConnecting,
                              isSelected: isNetConnecting,
                              signalType: network.signalType,
                              onTap: () => _connectToNetwork(context, network),
                              onSettingsTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => NetworkDetailScreen(
                                      networkName: network.name,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    const CustomDivider(verticalPadding: 16),

                    SettingsSectionHeader(title: l10n.avaialableNetworks),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: availableNetworks.length,
                      itemBuilder: (context, index) {
                        final network = availableNetworks[index];
                        final isNetConnecting =
                            connectingNetwork == network.name;

                        return Column(
                          children: [
                            NetworkListItem(
                              name: network.name,
                              isConnected: false,
                              isConnecting: isNetConnecting,
                              isSelected: isNetConnecting,
                              signalType: network.signalType,
                              onTap: () => _connectToNetwork(context, network),
                            ),
                            const SizedBox(height: 12),
                          ],
                        );
                      },
                    ),

                    const CustomDivider(verticalPadding: 16),
                  ],
                  ListTile(
                    minTileHeight: 56,
                    leading: const CustomImage(assetPath: SettingIcons.add),
                    title: Text(
                      l10n.addWireless,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    onTap: () => showAddNetworkBottomSheet(context),
                  ),

                  const CustomDivider(verticalPadding: 16),
                ],

                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  title: Text(
                    l10n.manageWireless,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.onSurfaceVariant,
                    size: 30,
                  ),
                  onTap: () {
                    Navigator.of(context).push<String>(
                      MaterialPageRoute(
                        builder: (context) => const ManageNetworksScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _connectToNetwork(BuildContext context, WifiNetwork network) async {
    final bloc = context.read<WirelessBloc>();

    // Already connected
    if (bloc.state.connectedNetworkName == network.name) {
      return;
    }

    final isSaved = bloc.state.savedNetworks.any((n) => n.name == network.name);

    String? password;

    if (network.isSecured) {
      if (isSaved && network.password.isNotEmpty) {
        // Saved network
        password = network.password;
      } else {
        // Not saved OR no password
        password = await showPasswordBottomSheet(context, network.name);

        // user cancelled or empty input
        if (password == null || password.trim().isEmpty) {
          return;
        }
      }
    }

    // Dispatch connect event
    bloc.add(ConnectToNetworkEvent(network.name, password));
  }
}
