import 'package:flutter/material.dart';
import 'package:mechanix_settings/core/utils/enums.dart';
import 'package:mechanix_settings/core/widgets/custom_image_asset.dart';

class WifiSignalIcon extends StatelessWidget {
  final WifiSignalType type;
  final double size;
  final Color? color;

  const WifiSignalIcon({
    super.key,
    required this.type,
    this.size = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomImage(assetPath: type.asset, size: size, color: color);
  }
}
