import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:screenshot/screenshot.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ExportAddressDialog extends StatelessWidget {
  ExportAddressDialog(this.address);

  final Address address;
  final ScreenshotController screenshotController = ScreenshotController();

  Future<void> saveScreenshotToFirebase(Uint8List? capturedImage, BuildContext context) async {
    if (capturedImage == null) return;

    try {
      // Gerar um nome único para a imagem
      String fileName = 'address_screenshot_${DateTime.now().millisecondsSinceEpoch}.png';
      final storageRef = FirebaseStorage.instance.ref().child('screenshots/$fileName');

      // Fazer o upload da imagem para o Firebase Storage
      await storageRef.putData(capturedImage);
      print('Imagem salva com sucesso no Firebase Storage!');

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Imagem salva com sucesso no Firebase!"),
      ));
    } catch (e) {
      print('Erro ao salvar imagem no Firebase: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Falha ao salvar a imagem no Firebase."),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Endereço de Entrega'),
      content: Screenshot(
        controller: screenshotController,
        child: Container(
          padding: EdgeInsets.all(8),
          color: Colors.white,
          child: Text(
            '${address.street}, ${address.number} ${address.complement}\n'
                '${address.district}\n'
                '${address.city}/${address.state}\n'
                '${address.zipCode}',
          ),
        ),
      ),
      contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 0),
      actions: [
        TextButton(
          onPressed: () async {
            final capturedImage = await screenshotController.capture();

            if (capturedImage != null) {
              await saveScreenshotToFirebase(capturedImage, context);
            } else {
              print('Falha ao capturar a imagem.');
            }

            Navigator.of(context).pop();
          },
          child: Text(
            'Exportar',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
