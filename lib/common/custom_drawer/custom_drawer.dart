import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_drawer/custom_drawer_header.dart';
import 'package:loja_virtual/common/custom_drawer/drawer_tile.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 203, 236, 241),
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          ListView(
            children: [
              CustomDrawerHeader(),
              const Divider(),
              DrawerTile(Icons.home, 'Início', 0),
              DrawerTile(Icons.list, 'Produtos', 1),
              DrawerTile(Icons.playlist_add_check, 'Meus Pedidos', 2),
              DrawerTile(Icons.location_on, 'Lojas', 3),
              Consumer<UserManager>(
                builder: (context,userManager, child){
                  if(userManager.adminEnabled){
                    return Column(
                      children: [
                        Divider(),
                        DrawerTile(Icons.verified_user, 'Usuários', 4),
                        DrawerTile(Icons.settings, 'Pedidos', 5),
                      ],
                    );
                  }else{
                    return Container();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
