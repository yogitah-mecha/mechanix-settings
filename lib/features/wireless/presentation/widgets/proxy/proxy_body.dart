import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mechanix_settings/core/theme/app_theme.dart';
import 'package:mechanix_settings/core/utils/enums.dart';
import 'package:mechanix_settings/core/widgets/custom_divider.dart';
import 'package:mechanix_settings/core/widgets/custom_switch.dart';
import 'package:mechanix_settings/core/widgets/custom_text_field.dart';
import 'package:mechanix_settings/features/wireless/presentation/widgets/wireless_settings/settings_section_header.dart';
import 'package:mechanix_settings/l10n/app_localizations.dart';

class ProxyBody extends StatelessWidget {
  final ProxyType configType;
  final ValueChanged<ProxyType> onConfigChanged;

  final TextEditingController urlController;
  final TextEditingController serverController;
  final TextEditingController portController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  final FocusNode urlFocus;
  final FocusNode serverFocus;
  final FocusNode portFocus;
  final FocusNode usernameFocus;
  final FocusNode passwordFocus;

  final bool useAuth;
  final ValueChanged<bool> onAuthChanged;

  const ProxyBody({
    super.key,
    required this.configType,
    required this.onConfigChanged,
    required this.urlController,
    required this.serverController,
    required this.portController,
    required this.usernameController,
    required this.passwordController,
    required this.urlFocus,
    required this.serverFocus,
    required this.portFocus,
    required this.usernameFocus,
    required this.passwordFocus,
    required this.useAuth,
    required this.onAuthChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RadioGroup<ProxyType>(
              groupValue: configType,
              onChanged: (value) {
                if (value != null) {
                  onConfigChanged(value);
                }
              },
              child: Column(
                children: ProxyType.values
                    .map(
                      (proxyType) => RadioListTile<ProxyType>(
                        value: proxyType,
                        activeColor: AppColors.onSurface,
                        minTileHeight: 58,
                        title: Text(
                          proxyType.label(l10n),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),

            if (configType != ProxyType.off)
              const CustomDivider(verticalPadding: 16),

            if (configType == ProxyType.automatic) ...[
              SettingsSectionHeader(title: l10n.proxyUrl),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomTextField(
                  controller: urlController,
                  focusNode: urlFocus,
                  hintText: l10n.proxyEnterUrl,
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                ),
              ),
            ],

            if (configType == ProxyType.manual) ...[
              SettingsSectionHeader(title: l10n.proxyServer),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomTextField(
                  controller: serverController,
                  focusNode: serverFocus,
                  nextFocusNode: portFocus,
                  hintText: l10n.proxyEnterServer,
                  textInputAction: TextInputAction.next,
                ),
              ),

              const SizedBox(height: 16),

              SettingsSectionHeader(title: l10n.proxyPort),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomTextField(
                  controller: portController,
                  focusNode: portFocus,
                  nextFocusNode: useAuth ? usernameFocus : null,
                  hintText: l10n.proxyEnterPort,
                  keyboardType: TextInputType.number,
                  textInputAction: useAuth
                      ? TextInputAction.next
                      : TextInputAction.done,
                ),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.proxyAuthentication,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    CustomSwitch(value: useAuth, onChanged: onAuthChanged),
                  ],
                ),
              ),

              if (useAuth) ...[
                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: CustomTextField(
                    controller: usernameController,
                    focusNode: usernameFocus,
                    nextFocusNode: passwordFocus,
                    hintText: l10n.proxyUsername,
                    textInputAction: TextInputAction.next,
                  ),
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomTextField(
                    controller: passwordController,
                    focusNode: passwordFocus,
                    hintText: l10n.proxyPassword,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                  ),
                ),
              ],
            ],

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
