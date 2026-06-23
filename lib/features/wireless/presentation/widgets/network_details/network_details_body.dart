import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mechanix_settings/core/utils/enums.dart';
import 'package:mechanix_settings/core/widgets/custom_divider.dart';
import 'package:mechanix_settings/features/wireless/blocs/wireless_bloc.dart';
import 'package:mechanix_settings/features/wireless/data/models/wifi_network.dart';
import 'package:mechanix_settings/features/wireless/presentation/widgets/network_details/dns.dart';
import 'package:mechanix_settings/features/wireless/presentation/widgets/network_details/ipv4_address.dart';
import 'package:mechanix_settings/features/wireless/presentation/widgets/network_details/private_address.dart';
import 'package:mechanix_settings/features/wireless/presentation/widgets/network_details/proxy.dart';
import 'package:mechanix_settings/features/wireless/presentation/widgets/wireless_settings/settings_info_row.dart';
import 'package:mechanix_settings/features/wireless/presentation/widgets/wireless_settings/settings_config_row.dart';
import 'package:mechanix_settings/features/wireless/presentation/widgets/wireless_settings/settings_section_header.dart';
import 'package:mechanix_settings/features/wireless/presentation/widgets/wireless_settings/settings_toggle_row.dart';
import 'package:mechanix_settings/l10n/app_localizations.dart';

class NetworkDetailsBody extends StatelessWidget {
  final WifiNetwork network;
  final String networkName;

  const NetworkDetailsBody({
    super.key,
    required this.network,
    required this.networkName,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bloc = context.read<WirelessBloc>();
    final privateAddressType = network.privateAddressType;
    final proxyType = network.proxyConfigType;
    final ipv4ConfigType = network.ipConfigType;
    final dnsConfigType = network.dnsConfigType;

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (network.isConnected) ...[
              SettingsToggleRow(
                title: l10n.autoJoin,
                value: network.autoJoin,
                onChanged: (val) {
                  bloc.add(
                    UpdateNetworkSettingsEvent(network.copyWith(autoJoin: val)),
                  );
                },
              ),

              SettingsInfoRow(
                title: l10n.password,
                value: network.password,
                obscureValue: true,
              ),
              const CustomDivider(verticalPadding: 0),

              SettingsToggleRow(
                title: l10n.lowDataMode,
                value: network.lowDataMode,
                onChanged: (val) {
                  bloc.add(
                    UpdateNetworkSettingsEvent(
                      network.copyWith(lowDataMode: val),
                    ),
                  );
                },
              ),
              const CustomDivider(verticalPadding: 0),
            ],

            // Private wireless address
            SettingsConfigRow(
              title: l10n.privateWirelessAddress,
              value: privateAddressType.label(l10n),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PrivateWirelessAddressScreen(
                      networkName: network.name,
                      currentValue: privateAddressType,
                      onSaved: (value) {
                        bloc.add(
                          UpdateNetworkSettingsEvent(
                            network.copyWith(privateAddressType: value),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),

            // Wireless Address
            SettingsInfoRow(
              title: l10n.wirelessAddress,
              value: network.wirelessAddress,
            ),
            const CustomDivider(verticalPadding: 0),

            if (network.isConnected) ...[
              // Limit IP Address Tracking Switch
              SettingsToggleRow(
                title: l10n.limitIpAddressTracking,
                value: network.limitIpAddressTracking,
                onChanged: (val) {
                  bloc.add(
                    UpdateNetworkSettingsEvent(
                      network.copyWith(limitIpAddressTracking: val),
                    ),
                  );
                },
              ),
              const CustomDivider(verticalPadding: 0),
            ],

            SettingsSectionHeader(title: l10n.ipv4Address),

            // Configure IP Navigation Row
            SettingsConfigRow(
              title: l10n.configureIp,
              value: ipv4ConfigType.label(l10n),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => IPv4AddressScreen(
                      network: network,
                      currentConfig: ipv4ConfigType,
                      ipAddress: network.ipAddress,
                      gateway: network.router,
                      onSaved: (data) {
                        bloc.add(
                          UpdateNetworkSettingsEvent(
                            network.copyWith(
                              ipConfigType: data['config'] as IPv4ConfigType,
                              ipAddress: data['ipAddress'] as String,
                              subnetMask: data['subnetMask'] as String,
                              router: data['gateway'] as String,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),

            if (network.isConnected &&
                (network.ipConfigType == IPv4ConfigType.automatic ||
                    network.ipConfigType == IPv4ConfigType.manual)) ...[
              SettingsInfoRow(
                title: l10n.ipAddressLabel,
                value: network.ipAddress,
              ),
              SettingsInfoRow(
                title: l10n.subnetMaskLabel,
                value: network.subnetMask,
              ),
              SettingsInfoRow(title: l10n.routerLabel, value: network.router),
              const CustomDivider(verticalPadding: 0),
            ],

            SettingsSectionHeader(title: l10n.dns),

            // Configure DNS Navigation Row
            SettingsConfigRow(
              title: l10n.configureDns,
              value: dnsConfigType.label(l10n),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => DNSScreen(
                      network: network,
                      currentConfig: dnsConfigType,
                      servers: network.dnsServers,
                      onSaved: (data) {
                        bloc.add(
                          UpdateNetworkSettingsEvent(
                            network.copyWith(
                              dnsConfigType: data['config'] as DNSConfigType,
                              dnsServers: List<String>.from(
                                data['servers'] as List,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            const CustomDivider(verticalPadding: 0),

            SettingsSectionHeader(title: l10n.httpProxy),

            // Configure Proxy Navigation Row
            SettingsConfigRow(
              title: l10n.configureProxy,
              value: proxyType.label(l10n),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ProxyScreen(
                      network: network,
                      currentConfig: proxyType,
                      onSaved: (value) {
                        bloc.add(
                          UpdateNetworkSettingsEvent(
                            network.copyWith(proxyConfigType: value),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            const CustomDivider(verticalPadding: 0),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
