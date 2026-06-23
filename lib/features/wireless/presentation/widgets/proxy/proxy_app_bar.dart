import 'package:flutter/material.dart';
import 'package:mechanix_settings/core/widgets/breadcrumbs.dart';
import 'package:mechanix_settings/core/widgets/custom_divider.dart';
import 'package:mechanix_settings/features/wireless/data/models/wifi_network.dart';
import 'package:mechanix_settings/l10n/app_localizations.dart';

class ProxyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final WifiNetwork network;
  final ScrollController scrollController;

  const ProxyAppBar({
    super.key,
    required this.network,
    required this.scrollController,
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
        scrollController: scrollController,
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
            label: network.name,
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          BreadcrumbItem(label: l10n.httpProxy),
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
