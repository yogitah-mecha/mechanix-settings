import 'package:flutter/material.dart';
import 'package:mechanix_settings/core/theme/app_theme.dart';
import 'package:mechanix_settings/core/utils/enums.dart';
import 'package:mechanix_settings/core/widgets/breadcrumbs.dart';
import 'package:mechanix_settings/core/widgets/custom_divider.dart';
import 'package:mechanix_settings/core/widgets/bottom_bar/bottom_bar.dart';
import 'package:mechanix_settings/core/widgets/custom_icon_button.dart';
import 'package:mechanix_settings/core/constants/icons.dart';
import 'package:mechanix_settings/features/wireless/data/models/wifi_network.dart';
import 'package:mechanix_settings/features/wireless/presentation/screens/network_detail.dart';
import 'package:mechanix_settings/l10n/app_localizations.dart';

class ProxyScreen extends StatefulWidget {
  final WifiNetwork network;
  final ProxyType currentConfig;
  final ValueChanged<ProxyType> onSaved;

  const ProxyScreen({
    super.key,
    required this.network,
    required this.currentConfig,
    required this.onSaved,
  });

  @override
  State<ProxyScreen> createState() => _ProxyScreenState();
}

class _ProxyScreenState extends State<ProxyScreen> {
  late ProxyType _configType;

  final ScrollController _breadcrumbController = ScrollController();

  @override
  void initState() {
    super.initState();
    _configType = widget.currentConfig;
  }

  @override
  void dispose() {
    _breadcrumbController.dispose();
    super.dispose();
  }

  void _saveAndPop() {
    widget.onSaved(_configType);
    Navigator.of(context).pop();
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
          scrollController: _breadcrumbController,
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
            BreadcrumbItem(label: l10n.httpProxy),
          ],
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: CustomDivider(verticalPadding: 0),
        ),
      ),
      body: SingleChildScrollView(
        child: RadioGroup<ProxyType>(
          groupValue: _configType,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _configType = value;
              });
            }
          },
          child: Column(
            children: [
              ...ProxyType.values.map(
                (proxyType) => RadioListTile<ProxyType>(
                  value: proxyType,
                  activeColor: AppColors.onSurface,
                  minTileHeight: 58,
                  title: Text(
                    proxyType.label(l10n),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ],
          ),
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
