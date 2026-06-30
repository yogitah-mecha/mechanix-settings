import 'package:flutter/material.dart';
import 'package:mechanix_settings/core/theme/app_theme.dart';
import 'package:mechanix_settings/l10n/app_localizations.dart';

class CustomToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  final String? activeLabel;
  final String? inactiveLabel;
  final AppLocalizations l10n;

  const CustomToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeLabel,
    this.inactiveLabel,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final onLabel = activeLabel ?? l10n.onToggle;
    final offLabel = inactiveLabel ?? l10n.offToggle;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onChanged(!value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 92,
          height: 40,
          decoration: const BoxDecoration(color: AppColors.backgroundVariant),
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: value ? 0 : 32,
                    right: value ? 38 : 0,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      value ? onLabel : offLabel,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontSize: 18, color: AppColors.onSurface),
                    ),
                  ),
                ),
              ),

              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                top: 2,
                bottom: 2,
                left: value ? 52 : 2,
                child: Container(
                  width: 36,
                  decoration: BoxDecoration(
                    color: value
                        ? AppColors.onSurface
                        : AppColors.onSurfaceVariantDark,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
