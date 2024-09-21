import 'package:flutter/material.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:provider/provider.dart';

import 'address_input_field.dart';
import 'cep_input_field.dart';

class AddressCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartManager = context.watch<CartManager>();
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Consumer<CartManager>(
          builder: (_, cartManager, __) {
            final address = cartManager.address ??
                Address(); // Obtém o endereço ou instancia um novo
            print(address);

            return Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Endereço de Entrega',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Campo de entrada de CEP
                  CepInputField(address),
                  // Exibe o AddressInputField apenas se o zipCode estiver preenchido
                  if (address.zipCode != null && address.zipCode.isNotEmpty && cartManager.deliveryPrice == null)
                    AddressInputField(),
                  if (address.zipCode != null &&
                      address.zipCode.isNotEmpty &&
                      cartManager.deliveryPrice != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        '${address.street}, ${address.number}\n${address.district}\n'
                            '${address.city} - ${address.state}'
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
