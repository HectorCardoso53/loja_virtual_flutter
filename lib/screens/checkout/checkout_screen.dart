import 'package:flutter/material.dart';
import 'package:loja_virtual/common/price_card.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/checkout_manager.dart';
import 'package:loja_virtual/models/page_manager.dart';
import 'package:loja_virtual/screens/checkout/components/credit_card_widget.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatelessWidget {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<CartManager, CheckoutManager>(
      create: (_) => CheckoutManager(),
      update: (_, cartManager, checkoutManager) =>
      checkoutManager!..updateCart(cartManager),
      lazy: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 4, 125, 141),
          title: const Text(
            'Pagamento',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: (){FocusScope.of(context).unfocus();},
          child: Consumer<CheckoutManager>(
            builder: (_, checkoutManager, __) {
              if (checkoutManager.loading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Procesando seu pagamento...',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Form(
                  key: formkey,
                  child: ListView(
                    children: [
                      CreditCardWidget(),
                      PriceCard(
                        buttonText: 'Finalizar Pedido',
                        onPressed: () {
                          // Aqui você valida os campos do formulário
                          if (formkey.currentState!.validate()) {
                            print('enviar');
                            // Se todos os campos forem válidos, prosseguir com o checkout
                           /* checkoutManager.checkout(
                              onStockFail: (e) {
                                Navigator.of(context).popUntil(
                                        (route) => route.settings.name == '/cart');
                              },
                              onSuccess: (order) {
                                Navigator.of(context).popUntil(
                                        (route) => route.settings.name == '/');
                                Navigator.of(context).pushNamed(
                                  '/confirmation',
                                  arguments: order,
                                );
                              },
                            );*/
                          } else {
                            // Caso os campos estejam inválidos, exibir uma mensagem
                            print('Campos inválidos');
                          }
                        },
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
