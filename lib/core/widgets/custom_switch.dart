import 'package:flutter/material.dart';
import 'package:mechanix_settings/core/theme/app_theme.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const double width = 78;
    const double height = 38;
    const double thumbSize = 30;
    const double margin = 4;

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: value
              ? AppColors.onSurfaceVariantDark
              : AppColors.backgroundVariant,
          borderRadius: BorderRadius.circular(height / 2),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: value ? width - thumbSize - margin : margin,
              top: (height - thumbSize) / 2,
              child: Container(
                width: thumbSize,
                height: thumbSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: value
                      ? AppColors.onSurface
                      : AppColors.onSurfaceVariantDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
