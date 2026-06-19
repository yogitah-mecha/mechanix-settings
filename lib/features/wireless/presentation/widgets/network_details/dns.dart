import 'package:flutter/material.dart';
import 'package:mechanix_settings/core/utils/enums.dart';
import 'package:mechanix_settings/core/widgets/bottom_bar/bottom_bar.dart';
import 'package:mechanix_settings/core/widgets/custom_icon_button.dart';
import 'package:mechanix_settings/core/constants/icons.dart';
import 'package:mechanix_settings/features/wireless/data/models/wifi_network.dart';
import 'package:mechanix_settings/features/wireless/presentation/screens/network_detail.dart';
import 'package:mechanix_settings/features/wireless/presentation/widgets/dns/dns_app_bar.dart';
import 'package:mechanix_settings/features/wireless/presentation/widgets/dns/dns_body.dart';

class DNSScreen extends StatefulWidget {
  final WifiNetwork network;
  final DNSConfigType currentConfig;
  final List<String> servers;
  final ValueChanged<Map<String, dynamic>> onSaved;

  const DNSScreen({
    super.key,
    required this.network,
    required this.currentConfig,
    required this.servers,
    required this.onSaved,
  });

  @override
  State<DNSScreen> createState() => _DNSScreenState();
}

class _DNSScreenState extends State<DNSScreen> {
  late DNSConfigType _configType;
  late List<String> _servers;
  final ScrollController _breadcrumbScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _configType = widget.currentConfig;
    _servers = List.from(widget.servers);
    if (_servers.isEmpty) {
      _servers = [
        '192.168.29.187',
        '2405:201:2029:f84b:c3d:dbdf:fe9f',
      ]; // TODO : Remove later
    }
  }

  @override
  void dispose() {
    _breadcrumbScrollController.dispose();

    super.dispose();
  }

  void _saveAndPop() {
    widget.onSaved({'config': _configType, 'servers': _servers});
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DNSAppBar(
        networkName: widget.network.name,
        breadcrumbController: _breadcrumbScrollController,
        onSettingsTap: () {
          _saveAndPop();
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        onWirelessTap: () {
          _saveAndPop();
          Navigator.of(context).pop();
        },
        onNetworkTap: _saveAndPop,
      ),

      body: DNSBody(
        configType: _configType,
        servers: _servers,
        onConfigChanged: (value) {
          setState(() {
            _configType = value;
          });
        },
      ),

      bottomNavigationBar: BottomBar(
        leading: CustomIconButton.asset(
          assetPath: SettingIcons.back,
          enabled: true,
          onPressed: _saveAndPop,
        ),

        trailing: [
          CustomIconButton.asset(
            assetPath: SettingIcons.connect,
            enabled: true,
            onPressed: () {
              connectToNetwork(context, widget.network);
              _saveAndPop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
