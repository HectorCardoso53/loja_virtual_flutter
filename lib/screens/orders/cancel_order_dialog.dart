import 'package:flutter/material.dart';
import 'package:loja_virtual/models/order.dart';

class CancelOrderDialog extends StatelessWidget {
  const CancelOrderDialog(this.order);

  final Orders order;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Cancelar: ${order.formattedId}?'),
      content: const Text('Esta ação não poderá ser desfeita!!'),
      actions: [
        TextButton(
          onPressed: () {
            order.cancel();
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancelar Pedido',
            style: TextStyle(
              color: Colors.redAccent,
            ),
          ),
        ),
      ],
    );
  }
}
