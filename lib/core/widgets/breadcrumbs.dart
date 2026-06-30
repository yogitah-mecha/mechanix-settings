import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mechanix_settings/core/theme/app_theme.dart';

class AppBreadcrumbs extends StatelessWidget {
  final List<BreadcrumbItem> items;
  final ScrollController scrollController;

  const AppBreadcrumbs({
    super.key,
    required this.items,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    _scrollToEnd();

    return SizedBox(
      width: double.infinity,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          scrollbars: false,
          dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
        ),
        child: SingleChildScrollView(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isLast = index == items.length - 1;

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(4),
                      onTap: isLast
                          ? null
                          : () {
                              item.onTap?.call();

                              if (scrollController.hasClients) {
                                scrollController.jumpTo(0);
                              }
                            },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 2,
                        ),
                        child: Text(
                          item.label,
                          style: Theme.of(context).textTheme.displaySmall
                              ?.copyWith(
                                color: isLast
                                    ? AppColors.onSurface
                                    : AppColors.onSurfaceVariantDark,
                              ),
                        ),
                      ),
                    ),
                  ),
                  if (!isLast)
                    Text(
                      " / ",
                      style: Theme.of(context).textTheme.headlineMedium!
                          .copyWith(color: AppColors.onSurfaceVariantDark),
                    ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;

      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }
}

class BreadcrumbItem {
  final String label;
  final VoidCallback? onTap;

  const BreadcrumbItem({required this.label, this.onTap});
}
