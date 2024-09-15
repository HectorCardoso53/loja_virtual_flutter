import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:provider/provider.dart';

class PriceCard extends StatelessWidget {
  const PriceCard({required this.buttonText, this.onPressed});

  final String buttonText;
  final VoidCallback? onPressed; // Permite que onPressed seja nulo

  @override
  Widget build(BuildContext context) {
    final bool isButtonEnabled = onPressed != null;

    final cartmanager = context.watch<CartManager>();
    final productPrice = cartmanager.productPrice;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Resumo do Pedido',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [const Text('Subtotal: '), Text('R\$ ${productPrice.toStringAsFixed(2)}')],
            ),
            const Divider(),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: ',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'R\$ ${productPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isButtonEnabled
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).primaryColor.withAlpha(100),
                  disabledForegroundColor: Theme.of(context).primaryColor.withAlpha(100).withOpacity(0.38), disabledBackgroundColor: Theme.of(context).primaryColor.withAlpha(100).withOpacity(0.12),
                ),
                child: Text(
                  buttonText,
                  style: TextStyle(
                    color: isButtonEnabled ? Colors.white : Colors.white70,
                    // Texto mais claro quando o botão está desativado
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
