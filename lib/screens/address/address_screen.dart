import 'package:flutter/material.dart';

import 'components/address_card.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 4, 125, 141), // Cor da AppBar
        title: const Text(
          'Entrega',
          style: TextStyle(
            color: Colors.white, // Cor do texto do título
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          AddressCard(),
        ],
      ),
    );
  }
}
