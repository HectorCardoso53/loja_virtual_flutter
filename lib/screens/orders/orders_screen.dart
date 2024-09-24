import 'package:flutter/material.dart';
import 'package:loja_virtual/common/empty_cart.dart';
import 'package:loja_virtual/common/login_card.dart';
import 'package:loja_virtual/models/orders_manager.dart';
import 'package:loja_virtual/screens/orders/components/order_tile.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 4, 125, 141),
        title: Text(
          'Mes Pedidos',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<OrdersManager>(
        builder: (_, ordersManager, __) {
          if (ordersManager.users == null) {
            return LoginCard();
          }
          if (ordersManager.orders.isEmpty) {
            return EmptyCart(
              title: 'Nenhuma compra encontrada!!',
              iconData: Icons.border_clear,
            );
          }
          return ListView.builder(
            itemCount: ordersManager.orders.length,
            itemBuilder: (_,index){
              return OrderTile(
                ordersManager.orders.reversed.toList()[index]
              );
            },
          );
        },
      ),
    );
  }
}
