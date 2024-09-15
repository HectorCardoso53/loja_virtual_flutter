import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:provider/provider.dart';

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
