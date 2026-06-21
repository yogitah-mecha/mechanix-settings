import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mechanix_settings/core/theme/app_theme.dart';
import 'package:mechanix_settings/core/utils/enums.dart';
import 'package:mechanix_settings/core/widgets/custom_divider.dart';
import 'package:mechanix_settings/features/wireless/presentation/widgets/wireless_settings/settings_section_header.dart';
import 'package:mechanix_settings/l10n/app_localizations.dart';

class DNSBody extends StatelessWidget {
  final DNSConfigType configType;
  final List<String> servers;
  final ValueChanged<DNSConfigType> onConfigChanged;

  const DNSBody({
    super.key,
    required this.configType,
    required this.servers,
    required this.onConfigChanged,
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
            RadioGroup<DNSConfigType>(
              groupValue: configType,
              onChanged: (value) {
                if (value != null) {
                  onConfigChanged(value);
                }
              },
              child: Column(
                children: [
                  ...DNSConfigType.values.map(
                    (type) => RadioListTile<DNSConfigType>(
                      value: type,
                      minTileHeight: 58,
                      activeColor: AppColors.onSurface,
                      title: Text(
                        type.label(l10n),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                  const CustomDivider(verticalPadding: 16),
                ],
              ),
            ),
            if (configType == DNSConfigType.automatic) ...[
              SettingsSectionHeader(title: l10n.serversLabel),

              const SizedBox(height: 12),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: servers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    title: Text(
                      servers[index],
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
