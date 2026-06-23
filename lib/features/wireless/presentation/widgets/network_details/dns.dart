import 'package:flutter/material.dart';
import 'package:mechanix_settings/core/utils/enums.dart';
import 'package:mechanix_settings/core/widgets/bottom_bar/bottom_bar.dart';
import 'package:mechanix_settings/core/widgets/custom_icon_button.dart';
import 'package:mechanix_settings/core/constants/icons.dart';
import 'package:mechanix_settings/features/wireless/data/models/wifi_network.dart';
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
  final ScrollController _breadcrumbScrollController = ScrollController();

  final List<TextEditingController> _serverControllers = [];
  final List<TextEditingController> _domainControllers = [];

  @override
  void initState() {
    super.initState();
    _configType = widget.currentConfig;

    // Load initial servers
    final initialServers = List<String>.from(widget.servers);
    final displayServers = initialServers.isEmpty
        ? [
            '192.168.29.187',
            '2405:201:2029:f84b:c3d:dbdf:fe9f',
          ] //TODO : update later, test data
        : initialServers;

    for (final server in displayServers) {
      _addServerController(server);
    }
    _addServerController(); // Add final empty input

    // Load initial search domains
    final initialDomains = List<String>.from(widget.network.dnsSearchDomains);
    //TODO : update later, test data
    final displayDomains =
        initialDomains.isEmpty &&
            (widget.network.name.toLowerCase() == 'office wifi 2' ||
                widget.network.name.toLowerCase() == 'office wifi 2')
        ? ['somedomain.com']
        : initialDomains;

    for (final domain in displayDomains) {
      _addDomainController(domain);
    }
    _addDomainController(); // Add final empty input
  }

  @override
  void dispose() {
    _breadcrumbScrollController.dispose();
    for (final c in _serverControllers) {
      c.dispose();
    }
    for (final c in _domainControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _addController(
    List<TextEditingController> controllers,
    void Function(TextEditingController controller) onChanged, [
    String text = '',
  ]) {
    final controller = TextEditingController(text: text);
    controller.addListener(() {
      onChanged(controller);
    });
    controllers.add(controller);
  }

  void _handleFieldChanged(
    TextEditingController controller,
    List<TextEditingController> controllers,
    VoidCallback addController,
  ) {
    final index = controllers.indexOf(controller);
    if (index == -1) return;

    if (index == controllers.length - 1 && controller.text.trim().isNotEmpty) {
      setState(addController);
    }
    _removeExtraEmptyControllers(controllers);
  }

  void _removeControllerField(
    int index,
    List<TextEditingController> controllers,
    VoidCallback addController,
  ) {
    if (controllers.length <= 1) return;
    setState(() {
      controllers[index].dispose();
      controllers.removeAt(index);
      if (controllers.isEmpty || controllers.last.text.trim().isNotEmpty) {
        addController();
      }
    });
  }

  void _removeExtraEmptyControllers(List<TextEditingController> controllers) {
    final emptyIndexes = <int>[];
    for (int i = 0; i < controllers.length; i++) {
      if (controllers[i].text.trim().isEmpty) {
        emptyIndexes.add(i);
      }
    }
    if (emptyIndexes.length <= 1) return;

    setState(() {
      for (int i = emptyIndexes.length - 2; i >= 0; i--) {
        final removeIndex = emptyIndexes[i];
        controllers[removeIndex].dispose();
        controllers.removeAt(removeIndex);
      }
    });
  }

  // Server management
  void _addServerController([String text = '']) {
    _addController(_serverControllers, _handleServerFieldChanged, text);
  }

  void _handleServerFieldChanged(TextEditingController controller) {
    _handleFieldChanged(controller, _serverControllers, _addServerController);
  }

  void _removeServerField(int index) {
    _removeControllerField(index, _serverControllers, _addServerController);
  }

  // Domain management
  void _addDomainController([String text = '']) {
    _addController(_domainControllers, _handleDomainFieldChanged, text);
  }

  void _handleDomainFieldChanged(TextEditingController controller) {
    _handleFieldChanged(controller, _domainControllers, _addDomainController);
  }

  void _removeDomainField(int index) {
    _removeControllerField(index, _domainControllers, _addDomainController);
  }

  void _saveAndPop() {
    final servers = _serverControllers
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();
    final searchDomains = _domainControllers
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    widget.onSaved({
      'config': _configType,
      'servers': servers,
      'searchDomains': searchDomains,
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DNSAppBar(
        networkName: widget.network.name,
        breadcrumbController: _breadcrumbScrollController,
        onSettingsTap: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        onWirelessTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
        onNetworkTap: () {
          Navigator.of(context).pop();
        },
      ),
      body: DNSBody(
        configType: _configType,
        onConfigChanged: (value) {
          setState(() {
            _configType = value;
          });
        },
        autoServers: widget.servers.isEmpty
            ? [
                '192.168.29.187',
                '2405:201:2026:18db:c0a8:1d01',
              ] //TODO : update later, test data
            : widget.servers,
        serverControllers: _serverControllers,
        domainControllers: _domainControllers,
        onAddServer: () {
          setState(() {
            _addServerController();
          });
        },
        onRemoveServer: _removeServerField,
        onAddDomain: () {
          setState(() {
            _addDomainController();
          });
        },
        onRemoveDomain: _removeDomainField,
      ),
      bottomNavigationBar: BottomBar(
        leading: CustomIconButton.asset(
          assetPath: SettingIcons.back,
          enabled: true,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        trailing: _configType == DNSConfigType.automatic
            ? []
            : [
                CustomIconButton.asset(
                  assetPath: SettingIcons.check,
                  enabled: true,
                  onPressed: _saveAndPop,
                ),
              ],
      ),
    );
  }
}
