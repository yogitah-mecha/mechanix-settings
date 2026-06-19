import 'package:flutter/material.dart';
import 'package:mechanix_settings/core/constants/icons.dart';
import 'package:mechanix_settings/core/theme/app_theme.dart';
import 'package:mechanix_settings/core/utils/enums.dart';
import 'package:mechanix_settings/core/widgets/bottom_bar/bottom_bar.dart';
import 'package:mechanix_settings/core/widgets/breadcrumbs.dart';
import 'package:mechanix_settings/core/widgets/custom_divider.dart';
import 'package:mechanix_settings/core/widgets/custom_icon_button.dart';
import 'package:mechanix_settings/features/wireless/data/models/wifi_network.dart';
import 'package:mechanix_settings/features/wireless/presentation/screens/network_detail.dart';
import 'package:mechanix_settings/features/wireless/presentation/widgets/wireless_settings/settings_info_row.dart';
import 'package:mechanix_settings/features/wireless/presentation/widgets/wireless_settings/settings_config_row.dart';
import 'package:mechanix_settings/features/wireless/presentation/widgets/wireless_settings/settings_section_header.dart';
import 'package:mechanix_settings/l10n/app_localizations.dart';

class IPv4AddressScreen extends StatefulWidget {
  final WifiNetwork network;
  final IPv4ConfigType currentConfig;
  final String ipAddress;
  final String gateway;
  final ValueChanged<Map<String, dynamic>> onSaved;

  const IPv4AddressScreen({
    super.key,
    required this.network,
    required this.currentConfig,
    required this.ipAddress,
    required this.gateway,
    required this.onSaved,
  });

  @override
  State<IPv4AddressScreen> createState() => _IPv4AddressScreenState();
}

class _IPv4AddressScreenState extends State<IPv4AddressScreen> {
  late IPv4ConfigType _configType;
  late String _ipAddress;
  late String _gateway;

  final ScrollController _breadcrumbScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _configType = widget.currentConfig;
    _ipAddress = widget.ipAddress;
    _gateway = widget.gateway;
  }

  @override
  void dispose() {
    _breadcrumbScrollController.dispose();
    super.dispose();
  }

  void _saveAndPop() {
    widget.onSaved({
      'config': _configType,
      'ipAddress': _ipAddress,
      'gateway': _gateway,
    });

    Navigator.of(context).pop();
  }

  // TODO: update design
  void _showEditFieldDialog({
    required String title,
    required String currentValue,
    required ValueChanged<String> onSaved,
  }) {
    final controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.backgroundVariant,
          title: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(color: AppColors.onSurface),
          ),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: AppColors.onSurface),
            decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.onSurfaceVariantDark),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.onSurface),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.onSurfaceVariant),
              ),
            ),
            TextButton(
              onPressed: () {
                onSaved(controller.text.trim());
                Navigator.pop(context);
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: AppBreadcrumbs(
          scrollController: _breadcrumbScrollController,
          items: [
            BreadcrumbItem(
              label: l10n.settings,
              onTap: () {
                _saveAndPop();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
            BreadcrumbItem(
              label: l10n.wireless,
              onTap: () {
                _saveAndPop();
                Navigator.of(context).pop();
              },
            ),
            BreadcrumbItem(label: widget.network.name, onTap: _saveAndPop),
            BreadcrumbItem(label: l10n.ipv4Address),
          ],
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: CustomDivider(verticalPadding: 0),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RadioGroup<IPv4ConfigType>(
              groupValue: _configType,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _configType = value);
                }
              },
              child: Column(
                children: IPv4ConfigType.values
                    .map(
                      (type) => RadioListTile<IPv4ConfigType>(
                        value: type,
                        minTileHeight: 58,
                        activeColor: AppColors.onSurface,
                        title: Text(
                          type.label(l10n),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),

            const CustomDivider(verticalPadding: 16),

            if (_configType == IPv4ConfigType.static) ...[
              SettingsSectionHeader(title: l10n.staticTitle),

              const SizedBox(height: 12),

              SettingsInfoRow(
                title: l10n.ipAddressSettingsLabel,
                value: _ipAddress.isEmpty ? '255.255.255.25' : _ipAddress,
              ),

              SettingsConfigRow(
                title: l10n.gatewayLabel,
                value: _gateway.isEmpty ? l10n.none : _gateway,
                onTap: () => _showEditFieldDialog(
                  title: l10n.gatewayLabel,
                  currentValue: _gateway,
                  onSaved: (value) {
                    setState(() {
                      _gateway = value;
                    });
                  },
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(
        leading: CustomIconButton.asset(
          assetPath: SettingIcons.back,
          enabled: true,
          onPressed: _saveAndPop,
        ),

        trailing: [
          CustomIconButton.asset(
            assetPath: SettingIcons.connect,
            enabled: true,
            onPressed: () {
              connectToNetwork(context, widget.network);
              _saveAndPop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
