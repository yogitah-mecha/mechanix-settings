import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mechanix_settings/core/constants/app_routes.dart';
import 'package:mechanix_settings/core/theme/app_theme.dart';
import 'package:mechanix_settings/features/settings_menu/presentation/screens/settings_menu_screen.dart';
import 'package:mechanix_settings/features/wireless/data/repositories/wireless_repository.dart';
import 'package:mechanix_settings/features/wireless/blocs/wireless_bloc.dart';
import 'package:mechanix_settings/features/wireless/presentation/screens/wireless.dart';
import 'package:mechanix_settings/l10n/app_localizations.dart';

void main() {
  final wirelessRepository = WirelessRepository();
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<WirelessRepository>.value(value: wirelessRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<WirelessBloc>(
            create: (context) =>
                WirelessBloc(wirelessRepository)..add(const LoadWireless()),
          ),
        ],
        child: const MechanixMessageApp(),
      ),
    ),
  );
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
      routes: {AppRoutes.wireless: (context) => const WirelessScreen()},
    );
  }
}
