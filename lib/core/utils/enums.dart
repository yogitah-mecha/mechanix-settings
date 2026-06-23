import 'package:mechanix_settings/l10n/app_localizations.dart';
import 'package:mechanix_settings/core/constants/icons.dart';

enum WirelessSecurity { none, wpa2Wpa3, wpa3, wpa, wpa2Enterprise, wep }

extension WirelessSecurityX on WirelessSecurity {
  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case WirelessSecurity.none:
        return l10n.securityNone;

      case WirelessSecurity.wpa2Wpa3:
        return l10n.securityWpa2Wpa3;

      case WirelessSecurity.wpa3:
        return l10n.securityWpa3;

      case WirelessSecurity.wpa:
        return l10n.securityWpa;

      case WirelessSecurity.wpa2Enterprise:
        return l10n.securityWpa2Enterprise;

      case WirelessSecurity.wep:
        return l10n.securityWep;
    }
  }
}

enum PrivateAddressType { off, staticAddress, rotating }

extension PrivateAddressTypeX on PrivateAddressType {
  String label(AppLocalizations l10n) {
    switch (this) {
      case PrivateAddressType.off:
        return l10n.off;
      case PrivateAddressType.staticAddress:
        return l10n.staticOption;
      case PrivateAddressType.rotating:
        return l10n.rotating;
    }
  }
}

extension PrivateAddressTypeParsing on String {
  PrivateAddressType toPrivateAddressType() {
    return PrivateAddressType.values.firstWhere(
      (e) => e.name == this,
      orElse: () => PrivateAddressType.off,
    );
  }
}

enum ProxyType { off, automatic, manual }

extension ProxyTypeX on ProxyType {
  String label(AppLocalizations l10n) {
    switch (this) {
      case ProxyType.off:
        return l10n.off;
      case ProxyType.automatic:
        return l10n.automatic;
      case ProxyType.manual:
        return l10n.manual;
    }
  }
}

extension ProxyTypeParsing on String {
  ProxyType toProxyType() {
    return ProxyType.values.firstWhere(
      (e) => e.name == this,
      orElse: () => ProxyType.off,
    );
  }
}

enum IPv4ConfigType { automatic, manual }

extension IPv4ConfigTypeX on IPv4ConfigType {
  String label(AppLocalizations l10n) {
    switch (this) {
      case IPv4ConfigType.automatic:
        return l10n.automatic;
      case IPv4ConfigType.manual:
        return l10n.manual;
    }
  }
}

extension IPv4ConfigTypeParsing on String {
  IPv4ConfigType toIPv4ConfigType() {
    return IPv4ConfigType.values.firstWhere(
      (e) => e.name == this,
      orElse: () => IPv4ConfigType.automatic,
    );
  }
}

enum DNSConfigType { automatic, manual }

extension DNSConfigTypeX on DNSConfigType {
  String label(AppLocalizations l10n) {
    switch (this) {
      case DNSConfigType.automatic:
        return l10n.automatic;
      case DNSConfigType.manual:
        return l10n.manual;
    }
  }
}

extension DNSConfigTypeParsing on String {
  DNSConfigType toDNSConfigType() {
    return DNSConfigType.values.firstWhere(
      (e) => e.name == this,
      orElse: () => DNSConfigType.automatic,
    );
  }
}

enum WifiSignalType {
  none,
  lowOpen,
  lowLocked,
  mediumOpen,
  mediumLocked,
  highOpen,
  highLocked,
  notFound;

  static WifiSignalType from({required int level, required bool secured}) {
    // Clamp to the supported range (0-3)
    switch (level.clamp(0, 3)) {
      case 0:
        return WifiSignalType.none;

      case 1:
        return secured ? WifiSignalType.lowLocked : WifiSignalType.lowOpen;

      case 2:
        return secured
            ? WifiSignalType.mediumLocked
            : WifiSignalType.mediumOpen;

      case 3:
      default:
        return secured ? WifiSignalType.highLocked : WifiSignalType.highOpen;
    }
  }
}

extension WifiSignalTypeIcon on WifiSignalType {
  String get asset {
    switch (this) {
      case WifiSignalType.none:
        return SettingIcons.wifiNone;

      case WifiSignalType.lowOpen:
        return SettingIcons.wifiLowOpen;

      case WifiSignalType.lowLocked:
        return SettingIcons.wifiLowLocked;

      case WifiSignalType.mediumOpen:
        return SettingIcons.wifiMediumOpen;

      case WifiSignalType.mediumLocked:
        return SettingIcons.wifiMediumLocked;

      case WifiSignalType.highOpen:
        return SettingIcons.wifiHighOpen;

      case WifiSignalType.highLocked:
        return SettingIcons.wifiHighLocked;

      case WifiSignalType.notFound:
        return SettingIcons.wifiNotFound;
    }
  }
}
