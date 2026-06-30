import 'package:mechanix_settings/core/constants/icons.dart';
import 'package:mechanix_settings/core/widgets/bottom_bar/bottom_bar.dart';
import 'package:mechanix_settings/core/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';

class SettingsMenuBottombar extends StatelessWidget {
  const SettingsMenuBottombar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomBar(
      key: const ValueKey('normal_bottom_bar'),

      leading: CustomIconButton.asset(
        assetPath: SettingIcons.back,
        enabled: false,
        onPressed: () {
          // TODO: Handle close app
        },
      ),
    );
  }
}
