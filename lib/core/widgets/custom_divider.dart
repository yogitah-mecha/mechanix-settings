import 'package:flutter/material.dart';
import 'package:mechanix_settings/core/theme/app_theme.dart';

class CustomDivider extends StatelessWidget {
  final double verticalPadding;
  final double thickness;
  final Color? color;

  const CustomDivider({
    super.key,
    this.verticalPadding = 12,
    this.thickness = 1,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Divider(
        height: thickness,
        thickness: thickness,
        color: color ?? AppColors.backgroundVariant,
      ),
    );
  }
}
