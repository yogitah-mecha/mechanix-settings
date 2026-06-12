import 'package:flutter/material.dart';
import 'package:mechanix_settings/core/theme/app_theme.dart';
import 'package:mechanix_settings/features/settings_menu/presentation/screens/settings_menu_screen.dart';
import 'package:mechanix_settings/l10n/app_localizations.dart';

void main() {
  runApp(const MechanixMessageApp());
}

class MechanixMessageApp extends StatelessWidget {
  const MechanixMessageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SettingsMenuScreen(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
