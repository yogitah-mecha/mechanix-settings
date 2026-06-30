# ⚙️ Mechanix Settings

Mechanix Settings is the system settings application for Mechanix OS, built with Flutter Elinux. It provides a centralized interface for configuring system preferences such as Wireless, Bluetooth, Display, Sound, System, Language, Battery, and more.

## 📦 Install Guide

### 📝 Pre-requisites

- [Flutter-Elinux SDK](https://github.com/flutter-elinux/flutter-elinux)
- [Dart SDK](https://dart.dev/get-dart)

### 🚀 Steps to run Mechanix Settings

1. Clone the repository:

```bash
git clone https://github.com/mecha-org/mechanix-settings
cd mechanix_settings
```

2. Install Flutter dependencies:

For flutter-elinux:

```bash
$ flutter-elinux pub get
```

3. Build and Run:

For flutter-elinux:

```bash
$ flutter-elinux build
$ flutter-elinux run
```

## 🔑 Key Features

- **Wireless**: View, connect, and manage wireless networks.
- **Bluetooth**: Bluetooth settings.
- **Cellular Data (LTE)**: Cellular settings interface.
- **Display**: Display settings interface.
- **Sound**: Sound settings interface.
- **System**: System settings interface.
- **Time & Date**: Configure date and time settings.
- **Language**: Language selection interface.
- **Battery**: Battery information and settings.
- **About**: Device and system information.

---

## 📋 Features Overview

### Wireless

- Display saved networks
- Display available networks
- Connect to wireless networks
- View connected network details
- View saved network details
- Add a network
- Manage saved networks
- Forget saved networks

### Bluetooth

- Enable/disable Bluetooth
- Display available devices
- Display paired devices
- Simulated device discovery
- Device pairing flow
- PIN entry and confirmation dialogs
- Connect and disconnect simulated devices
- Forget paired devices

### Cellular Data (LTE)

- Cellular settings interface

### Display

- Display settings interface

### Sound

- Sound settings interface

### System

- System settings interface

### Time & Date

- Date and time settings interface

### Language

- Language selection interface

### Battery

- Battery information interface

### About

- Device and system information

---

## 🚧 TODOs

### Wireless

- Integrate with the Wireless SDK for:
  - Scanning nearby Wi-Fi networks
  - Connecting to Wi-Fi networks
  - Managing saved networks
  - Retrieving network details

### Bluetooth

- Integrate with the Bluetooth SDK for:
  - Device discovery
  - Pairing and unpairing
  - Connection management
  - Device information
  - Real-time Bluetooth state updates

### Other Settings

- Integrate Display settings with the system SDK.
- Integrate Sound settings with the system SDK.
- Integrate Cellular settings with the modem/network SDK.
- Integrate Time & Date settings with system services.
- Integrate Language settings with localization services.
- Integrate Battery information with power management services.
- Integrate About page with system information APIs.