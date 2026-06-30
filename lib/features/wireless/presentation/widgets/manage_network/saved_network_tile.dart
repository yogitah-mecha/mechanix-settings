import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mechanix_settings/features/wireless/blocs/wireless_bloc.dart';
import 'package:mechanix_settings/features/wireless/data/models/wifi_network.dart';
import 'package:mechanix_settings/features/wireless/presentation/screens/network_detail.dart';
import 'package:mechanix_settings/features/wireless/presentation/widgets/manage_network/saved_network_popup_menu.dart';
import 'package:mechanix_settings/features/wireless/presentation/widgets/wifi_signal_icon.dart';

class SavedNetworkTile extends StatelessWidget {
  final WifiNetwork network;

  const SavedNetworkTile({super.key, required this.network});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minTileHeight: 72,
      dense: true,
      leading: WifiSignalIcon(type: network.signalType),
      title: Text(network.name, style: Theme.of(context).textTheme.labelLarge),

      trailing: SavedNetworkPopupMenu(
        onAbout: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NetworkDetailScreen(networkName: network.name),
            ),
          );
        },
        onForget: () {
          context.read<WirelessBloc>().add(ForgetNetworkEvent(network));
        },
      ),
    );
  }
}
