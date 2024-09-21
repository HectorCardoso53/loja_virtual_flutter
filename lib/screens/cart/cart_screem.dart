import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:provider/provider.dart';

import '../../common/empty_cart.dart';
import '../../common/login_card.dart';
import '../../common/price_card.dart';
import 'componets/cart_tile.dart';

class CartScreem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 4, 125, 141),
        title: const Text(
          'Carrinho',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<CartManager>(
        builder: (context, cartManager, child) {
          if(cartManager.user == null){
            return LoginCard();
          }
          if(cartManager.items.isEmpty){
            return EmptyCart(
              iconData: Icons.remove_shopping_cart,
              title: 'Nenhum Produto no carrinho!!',
            );
          }
          return ListView(
            children: [
              Column(
                children: cartManager.items
                    .map((cartProduct) => CartTile(cartProduct))
                    .toList(),
              ),
              PriceCard(
                buttonText: 'Continua para Entrega',
                onPressed: cartManager.isCartValid
                    ? () {
                  // Coloque a ação desejada aqui
                  Navigator.of(context).pushNamed('/address');
                }
                    : null, // Desabilita o botão quando não for válido
              ),
            ],
          );
        },
      ),
    );
  }
}
