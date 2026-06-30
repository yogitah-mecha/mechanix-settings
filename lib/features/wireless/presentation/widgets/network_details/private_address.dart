import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mechanix_settings/core/constants/icons.dart';
import 'package:mechanix_settings/core/theme/app_theme.dart';
import 'package:mechanix_settings/features/wireless/data/models/enums.dart';
import 'package:mechanix_settings/core/widgets/breadcrumbs.dart';
import 'package:mechanix_settings/core/widgets/bottom_bar/bottom_bar.dart';
import 'package:mechanix_settings/core/widgets/custom_divider.dart';
import 'package:mechanix_settings/core/widgets/custom_icon_button.dart';
import 'package:mechanix_settings/l10n/app_localizations.dart';

class PrivateWirelessAddressScreen extends StatefulWidget {
  final String networkName;
  final PrivateAddressType currentValue;
  final ValueChanged<PrivateAddressType> onSaved;

  const PrivateWirelessAddressScreen({
    super.key,
    required this.networkName,
    required this.currentValue,
    required this.onSaved,
  });

  @override
  State<PrivateWirelessAddressScreen> createState() =>
      _PrivateWirelessAddressScreenState();
}

class _PrivateWirelessAddressScreenState
    extends State<PrivateWirelessAddressScreen> {
  late PrivateAddressType _selectedValue;

  final ScrollController _breadcrumbController = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.currentValue;
  }

  @override
  void dispose() {
    _breadcrumbController.dispose();
    super.dispose();
  }

  void _saveAndPop() {
    widget.onSaved(_selectedValue);
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
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
            BreadcrumbItem(
              label: l10n.wireless,
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            BreadcrumbItem(
              label: widget.networkName,
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            BreadcrumbItem(label: l10n.privateWirelessAddress),
          ],
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: CustomDivider(verticalPadding: 0),
        ),
      ),
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
        ),
        child: SingleChildScrollView(
          child: RadioGroup<PrivateAddressType>(
            groupValue: _selectedValue,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedValue = value;
                });
              }
            },
            child: Column(
              children: PrivateAddressType.values.map((type) {
                return RadioListTile<PrivateAddressType>(
                  value: type,
                  activeColor: AppColors.onSurface,
                  title: Text(
                    type.label(l10n),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(
        leading: CustomIconButton.asset(
          assetPath: SettingIcons.back,
          enabled: true,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        trailing: [
          CustomIconButton.asset(
            assetPath: SettingIcons.check,
            enabled: true,
            onPressed: () {
              _saveAndPop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
