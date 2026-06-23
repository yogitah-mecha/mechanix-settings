import 'package:flutter/material.dart';
import 'package:mechanix_settings/core/utils/enums.dart';
import 'package:mechanix_settings/core/widgets/bottom_bar/bottom_bar.dart';
import 'package:mechanix_settings/core/widgets/custom_icon_button.dart';
import 'package:mechanix_settings/core/constants/icons.dart';
import 'package:mechanix_settings/features/wireless/data/models/wifi_network.dart';
import 'package:mechanix_settings/features/wireless/presentation/widgets/proxy/proxy_app_bar.dart';
import 'package:mechanix_settings/features/wireless/presentation/widgets/proxy/proxy_body.dart';

class ProxyScreen extends StatefulWidget {
  final WifiNetwork network;
  final ProxyType currentConfig;
  final ValueChanged<Map<String, dynamic>> onSaved;

  const ProxyScreen({
    super.key,
    required this.network,
    required this.currentConfig,
    required this.onSaved,
  });

  @override
  State<ProxyScreen> createState() => _ProxyScreenState();
}

class _ProxyScreenState extends State<ProxyScreen> {
  late ProxyType _configType;

  late final TextEditingController _urlController;
  late final TextEditingController _serverController;
  late final TextEditingController _portController;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;

  final FocusNode _urlFocus = FocusNode();
  final FocusNode _serverFocus = FocusNode();
  final FocusNode _portFocus = FocusNode();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  late bool _useAuth;

  final ScrollController _breadcrumbController = ScrollController();

  @override
  void initState() {
    super.initState();
    _configType = widget.currentConfig;

    _urlController = TextEditingController(text: widget.network.proxyUrl);
    _serverController = TextEditingController(text: widget.network.proxyServer);
    _portController = TextEditingController(text: widget.network.proxyPort);
    _usernameController = TextEditingController(
      text: widget.network.proxyUsername,
    );
    _passwordController = TextEditingController(
      text: widget.network.proxyPassword,
    );

    _useAuth = widget.network.proxyUseAuth;
  }

  @override
  void dispose() {
    _urlController.dispose();
    _serverController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();

    _urlFocus.dispose();
    _serverFocus.dispose();
    _portFocus.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();

    _breadcrumbController.dispose();
    super.dispose();
  }

  void _saveAndPop() {
    widget.onSaved({
      'config': _configType,
      'url': _urlController.text.trim(),
      'server': _serverController.text.trim(),
      'port': _portController.text.trim(),
      'useAuth': _useAuth,
      'username': _usernameController.text.trim(),
      'password': _passwordController.text.trim(),
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProxyAppBar(
        network: widget.network,
        scrollController: _breadcrumbController,
      ),
      body: ProxyBody(
        configType: _configType,
        onConfigChanged: (value) {
          setState(() => _configType = value);
        },
        urlController: _urlController,
        serverController: _serverController,
        portController: _portController,
        usernameController: _usernameController,
        passwordController: _passwordController,
        urlFocus: _urlFocus,
        serverFocus: _serverFocus,
        portFocus: _portFocus,
        usernameFocus: _usernameFocus,
        passwordFocus: _passwordFocus,
        useAuth: _useAuth,
        onAuthChanged: (value) {
          setState(() => _useAuth = value);
        },
      ),
      bottomNavigationBar: BottomBar(
        leading: CustomIconButton.asset(
          assetPath: SettingIcons.back,
          enabled: true,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        trailing: _configType == ProxyType.off
            ? []
            : [
                CustomIconButton.asset(
                  assetPath: SettingIcons.check,
                  enabled: true,
                  onPressed: () {
                    _saveAndPop();
                  },
                ),
              ],
      ),
    );
  }
}
