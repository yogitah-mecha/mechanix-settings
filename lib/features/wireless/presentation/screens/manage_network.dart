import 'package:flutter/material.dart';
import 'package:mechanix_settings/core/constants/icons.dart';
import 'package:mechanix_settings/core/widgets/bottom_bar/bottom_bar.dart';
import 'package:mechanix_settings/core/widgets/custom_icon_button.dart';
import 'package:mechanix_settings/features/wireless/presentation/widgets/manage_network/manage_network_app_bar.dart';
import 'package:mechanix_settings/features/wireless/presentation/widgets/manage_network/manage_network_body.dart';

class ManageNetworksScreen extends StatefulWidget {
  const ManageNetworksScreen({super.key});

  @override
  State<ManageNetworksScreen> createState() => _ManageNetworksScreenState();
}

class _ManageNetworksScreenState extends State<ManageNetworksScreen> {
  final ScrollController _breadcrumbScrollController = ScrollController();

  @override
  void dispose() {
    _breadcrumbScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ManageNetworkAppBar(
        breadcrumbController: _breadcrumbScrollController,
      ),
      body: const ManageNetworksBody(),
      bottomNavigationBar: BottomBar(
        leading: CustomIconButton.asset(
          assetPath: SettingIcons.back,
          enabled: true,
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
