import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loja_virtual/common/custom_icon_button.dart';
import 'package:loja_virtual/models/store.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreCard extends StatelessWidget {
  const StoreCard(this.store);

  final Store store;

  @override
  Widget build(BuildContext context) {
    Color colorsForStatus(StoreStatus status) {
      switch (status) {
        case StoreStatus.closed:
          return Colors.redAccent;
        case StoreStatus.open:
          return Colors.green;
        case StoreStatus.closing:
          return Colors.deepOrange;
        default:
          return Colors.green;
      }
    }

    Future<void> _openPhone() async {
      final cleanNumber = store.cleanPhone; // Obtém o número limpo
      print('Número limpo: $cleanNumber'); // Para debug

      if (cleanNumber.isNotEmpty) {
        final url = 'tel:$cleanNumber';
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Não é possível fazer ligação nesse dispositivo',
              ),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Número de telefone inválido.',
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }

    Future<void> openMap() async {
      try {
        final availableMpas = await MapLauncher.installedMaps;

        showModalBottomSheet(
          context: context,
          builder: (_) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final map in availableMpas)
                    ListTile(
                      onTap: () {
                        map.showMarker(
                          coords: Coords(store.address!.lat, store.address!.long),
                          title: store.name,
                          description: store.addresstext,
                        );
                        Navigator.of(context).pop();
                      },
                      title: Text(map.mapName),
                        leading: SvgPicture.asset(
                          map.icon,
                          height: 30.0,
                          width: 30.0,
                        ),
                    )
                ],
              ),
            );
          },
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro nessa bagaça.',
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Container(
            height: 160,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  store.image,
                  fit: BoxFit.cover,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                        )),
                    padding: EdgeInsets.all(8),
                    child: Text(
                      store.statustext,
                      style: TextStyle(
                        color:
                            colorsForStatus(store.status ?? StoreStatus.closed),
                        // Usando o valor padrão aqui
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 140,
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        store.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        store.addresstext,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      Text(
                        store.openingText(context),
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIconButton(
                      iconData: Icons.map,
                      color: Theme.of(context).primaryColor,
                      onTap: openMap,
                    ),
                    CustomIconButton(
                      iconData: Icons.phone,
                      color: Theme.of(context).primaryColor,
                      onTap: _openPhone,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
