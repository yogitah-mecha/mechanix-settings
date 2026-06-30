import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mechanix_settings/core/theme/app_theme.dart';
import 'package:mechanix_settings/features/wireless/data/models/enums.dart';
import 'package:mechanix_settings/core/widgets/custom_divider.dart';
import 'package:mechanix_settings/core/widgets/custom_text_field.dart';
import 'package:mechanix_settings/features/wireless/presentation/widgets/wireless_settings/settings_section_header.dart';
import 'package:mechanix_settings/l10n/app_localizations.dart';

class DNSBody extends StatelessWidget {
  final DNSConfigType configType;
  final ValueChanged<DNSConfigType> onConfigChanged;

  final List<String> autoServers;
  final List<TextEditingController> serverControllers;
  final List<TextEditingController> domainControllers;

  final VoidCallback onAddServer;
  final ValueChanged<int> onRemoveServer;
  final VoidCallback onAddDomain;
  final ValueChanged<int> onRemoveDomain;

  const DNSBody({
    super.key,
    required this.configType,
    required this.onConfigChanged,
    required this.autoServers,
    required this.serverControllers,
    required this.domainControllers,
    required this.onAddServer,
    required this.onRemoveServer,
    required this.onAddDomain,
    required this.onRemoveDomain,
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
                itemCount: autoServers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    title: Text(
                      autoServers[index],
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  );
                },
              ),
            ] else if (configType == DNSConfigType.manual) ...[
              SettingsSectionHeader(title: l10n.dnsServers),

              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: List.generate(serverControllers.length, (index) {
                    final controller = serverControllers[index];
                    final isLast = index == serverControllers.length - 1;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(
                              isLast
                                  ? Icons.add_circle_outline
                                  : Icons.remove_circle_outline,
                              color: isLast ? Colors.blue : Colors.redAccent,
                            ),
                            onPressed: isLast
                                ? onAddServer
                                : () => onRemoveServer(index),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextField(
                              controller: controller,
                              hintText: l10n.addServer,
                              keyboardType: TextInputType.text,
                              textInputAction: isLast
                                  ? TextInputAction.done
                                  : TextInputAction.next,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),

              const CustomDivider(verticalPadding: 16),

              SettingsSectionHeader(title: l10n.searchDomains),

              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: List.generate(domainControllers.length, (index) {
                    final controller = domainControllers[index];
                    final isLast = index == domainControllers.length - 1;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(
                              isLast
                                  ? Icons.add_circle_outline
                                  : Icons.remove_circle_outline,
                              color: isLast ? Colors.blue : Colors.redAccent,
                            ),
                            onPressed: isLast
                                ? onAddDomain
                                : () => onRemoveDomain(index),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextField(
                              controller: controller,
                              hintText: l10n.addDomainsHintText,
                              keyboardType: TextInputType.text,
                              textInputAction: isLast
                                  ? TextInputAction.done
                                  : TextInputAction.next,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
