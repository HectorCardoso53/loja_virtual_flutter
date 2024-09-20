import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:provider/provider.dart';

class CepInputField extends StatefulWidget {
  const CepInputField({super.key});

  @override
  _CepInputFieldState createState() => _CepInputFieldState();
}

class _CepInputFieldState extends State<CepInputField> {
  final TextEditingController cepController = TextEditingController();

  @override
  void dispose() {
    // Certifique-se de descartar o controlador ao sair
    cepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: cepController,
          decoration: InputDecoration(
            isDense: true,
            labelText: 'CEP',
            hintText: '68.270-000',
            labelStyle: const TextStyle(
              color: Color.fromARGB(255, 4, 125, 141), // Cor do label
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 4, 125, 141), // Cor padrão da borda
              ),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 4, 125, 141), // Cor da borda quando não focado
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 4, 125, 141), // Cor da borda quando focado
              ),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red), // Cor da borda com erro
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red), // Cor da borda com erro e focado
            ),
          ),
          style: const TextStyle(
            color: Color.fromARGB(255, 4, 125, 141), // Cor do texto digitado
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly, // Permite apenas dígitos
            CepInputFormatter(),
          ],
          keyboardType: TextInputType.number,
          validator: (cep) {
            if (cep!.isEmpty) return 'Campo Obrigatório';
            else if (cep.length != 10) return 'CEP inválido';
            return null;
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            if (Form.of(context).validate()) {
              context.read<CartManager>().getAddress(cepController.text);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            disabledBackgroundColor: Theme.of(context).primaryColor.withAlpha(100),
          ),
          child: const Text(
            'Buscar CEP',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
