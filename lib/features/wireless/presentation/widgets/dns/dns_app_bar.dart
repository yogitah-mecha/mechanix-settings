import 'package:flutter/material.dart';
import 'package:mechanix_settings/core/widgets/breadcrumbs.dart';
import 'package:mechanix_settings/core/widgets/custom_divider.dart';
import 'package:mechanix_settings/l10n/app_localizations.dart';

class DNSAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String networkName;
  final ScrollController breadcrumbController;
  final VoidCallback onSettingsTap;
  final VoidCallback onWirelessTap;
  final VoidCallback onNetworkTap;

  const DNSAppBar({
    super.key,
    required this.networkName,
    required this.breadcrumbController,
    required this.onSettingsTap,
    required this.onWirelessTap,
    required this.onNetworkTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppBar(
      scrolledUnderElevation: 0,
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      title: AppBreadcrumbs(
        scrollController: breadcrumbController,
        items: [
          BreadcrumbItem(label: l10n.settings, onTap: onSettingsTap),
          BreadcrumbItem(label: l10n.wireless, onTap: onWirelessTap),
          BreadcrumbItem(label: networkName, onTap: onNetworkTap),
          BreadcrumbItem(label: l10n.dns),
        ],
      ),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: CustomDivider(verticalPadding: 0),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}
