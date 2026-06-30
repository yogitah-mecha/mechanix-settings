import 'package:flutter/material.dart';

class SettingsInfoRow extends StatelessWidget {
  final String title;
  final String value;
  final bool obscureValue;

  const SettingsInfoRow({
    super.key,
    required this.title,
    required this.value,
    this.obscureValue = false,
  });

  @override
  Widget build(BuildContext context) {
    final displayValue = obscureValue ? '•' * value.length.clamp(0, 16) : value;

    return ListTile(
      minTileHeight: 56,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text(title, style: Theme.of(context).textTheme.labelLarge),
      trailing: Text(
        displayValue,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
