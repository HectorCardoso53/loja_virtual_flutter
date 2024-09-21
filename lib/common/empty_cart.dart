import 'package:flutter/material.dart';

class EmptyCart extends StatelessWidget {
  const EmptyCart({required this.title, required this.iconData});

  final String title;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Center( // Certifica que tudo está centralizado na tela
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Centraliza horizontalmente
          mainAxisAlignment: MainAxisAlignment.center, // Centraliza verticalmente
          children: [
            Icon(
              iconData,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center, // Certifica que o texto está centralizado
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
