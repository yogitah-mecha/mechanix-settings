import 'package:equatable/equatable.dart';
import 'package:mechanix_settings/core/utils/enums.dart';

class WifiNetwork extends Equatable {
  final String name;
  final String password;

  final int signalLevel;
  final bool isSecured;
  final bool isConnected;
  final bool isConnecting;
  final bool autoJoin;
  final bool lowDataMode;
  final bool limitIpAddressTracking;

  final PrivateAddressType privateAddressType;

  final IPv4ConfigType ipConfigType;
  final String ipAddress;
  final String subnetMask;
  final String router;

  final DNSConfigType dnsConfigType;
  final List<String> dnsServers;
  final List<String> dnsSearchDomains;

  final ProxyType proxyConfigType;
  final String proxyUrl;
  final String proxyServer;
  final String proxyPort;
  final bool proxyUseAuth;
  final String proxyUsername;
  final String proxyPassword;
  final String wirelessAddress;

  const WifiNetwork({
    required this.name,
    this.password = 'test123',
    this.signalLevel = 3,
    this.isSecured = true,
    this.isConnected = false,
    this.isConnecting = false,
    this.autoJoin = true,
    this.lowDataMode = false,
    this.limitIpAddressTracking = true,
    this.privateAddressType = PrivateAddressType.staticAddress,
    this.ipConfigType = IPv4ConfigType.automatic,
    this.ipAddress = "192.168.29.187",
    this.subnetMask = "255.255.255.0",
    this.router = "192.168.29.1",
    this.dnsConfigType = DNSConfigType.automatic,
    this.dnsServers = const [
      "192.168.29.187",
      "2405:201:2029:f84b:c3d:dbdf:fe9f",
    ],
    this.dnsSearchDomains = const [],
    this.proxyConfigType = ProxyType.off,
    this.proxyUrl = '',
    this.proxyServer = '',
    this.proxyPort = '',
    this.proxyUseAuth = false,
    this.proxyUsername = '',
    this.proxyPassword = '',
    this.wirelessAddress = "62:C5:7D:EB:85:66",
  });

  // Computed signal type
  WifiSignalType get signalType =>
      WifiSignalType.from(level: signalLevel, secured: isSecured);

  WifiNetwork copyWith({
    String? name,
    String? password,
    int? signalLevel,
    bool? isSecured,
    bool? isConnected,
    bool? isConnecting,
    bool? autoJoin,
    bool? lowDataMode,
    bool? limitIpAddressTracking,
    PrivateAddressType? privateAddressType,
    String? wirelessAddressType,
    IPv4ConfigType? ipConfigType,
    String? ipAddress,
    String? subnetMask,
    String? router,
    DNSConfigType? dnsConfigType,
    List<String>? dnsServers,
    List<String>? dnsSearchDomains,
    ProxyType? proxyConfigType,
    String? proxyUrl,
    String? proxyServer,
    String? proxyPort,
    bool? proxyUseAuth,
    String? proxyUsername,
    String? proxyPassword,
    String? wirelessAddress,
  }) {
    return WifiNetwork(
      name: name ?? this.name,
      password: password ?? this.password,

      signalLevel: signalLevel ?? this.signalLevel,
      isSecured: isSecured ?? this.isSecured,
      isConnected: isConnected ?? this.isConnected,
      isConnecting: isConnecting ?? this.isConnecting,
      autoJoin: autoJoin ?? this.autoJoin,
      lowDataMode: lowDataMode ?? this.lowDataMode,
      limitIpAddressTracking:
          limitIpAddressTracking ?? this.limitIpAddressTracking,
      privateAddressType: privateAddressType ?? this.privateAddressType,
      ipConfigType: ipConfigType ?? this.ipConfigType,
      ipAddress: ipAddress ?? this.ipAddress,
      subnetMask: subnetMask ?? this.subnetMask,
      router: router ?? this.router,
      dnsConfigType: dnsConfigType ?? this.dnsConfigType,
      dnsServers: dnsServers ?? this.dnsServers,
      dnsSearchDomains: dnsSearchDomains ?? this.dnsSearchDomains,
      proxyConfigType: proxyConfigType ?? this.proxyConfigType,
      proxyUrl: proxyUrl ?? this.proxyUrl,
      proxyServer: proxyServer ?? this.proxyServer,
      proxyPort: proxyPort ?? this.proxyPort,
      proxyUseAuth: proxyUseAuth ?? this.proxyUseAuth,
      proxyUsername: proxyUsername ?? this.proxyUsername,
      proxyPassword: proxyPassword ?? this.proxyPassword,
      wirelessAddress: wirelessAddress ?? this.wirelessAddress,
    );
  }

  @override
  List<Object?> get props => [
    name,
    password,
    signalLevel,
    isSecured,
    isConnected,
    isConnecting,
    autoJoin,
    lowDataMode,
    limitIpAddressTracking,
    privateAddressType,
    ipConfigType,
    ipAddress,
    subnetMask,
    router,
    dnsConfigType,
    dnsServers,
    dnsSearchDomains,
    proxyConfigType,
    proxyUrl,
    proxyServer,
    proxyPort,
    proxyUseAuth,
    proxyUsername,
    proxyPassword,
    wirelessAddress,
  ];
}
