import 'package:flutter/material.dart';
import 'package:loja_virtual/models/stores_manager.dart';
import 'package:loja_virtual/screens/stores/components/store_card.dart';
import 'package:provider/provider.dart';

import '../../common/custom_drawer/custom_drawer.dart';

class StoresScreen extends StatelessWidget {
  const StoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 4, 125, 141),
        title: Text(
          'Lojas',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<StoresManager>(
        builder: (_, storeManager, __) {
          if (storeManager.stores.isEmpty) {
            return LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(
                Colors.white,
              ),
              backgroundColor: Colors.transparent,
            );
          }
          return ListView.builder(
            itemCount: storeManager.stores.length,
            itemBuilder: (_,index){
              return StoreCard(storeManager.stores[index]);
            },
          );
        },
      ),
    );
  }
}
