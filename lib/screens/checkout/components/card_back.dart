import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/screens/checkout/components/card_text_field.dart';

class CardBack extends StatelessWidget {
  const CardBack(this.cvvFocus);

  final FocusNode cvvFocus;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 16,
      child: Container(
        height: 200,
        color: const Color(0xFF1B4B52),
        child: SingleChildScrollView( // Adicionado para evitar overflow
          child: Column(
            children: [
              Container(
                color: Colors.black,
                height: 40,
                margin: const EdgeInsets.symmetric(vertical: 16),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 70,
                    child: Container(
                      color: Colors.grey[500],
                      height: 30,
                      margin: const EdgeInsets.only(left: 12), // Adicionando margens
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: CardTextField(
                        hint: '123',
                        maxLength:3,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        textAlign: TextAlign.end,
                        textInputType: TextInputType.number,
                        validator: (cvc){
                          if(cvc!.length != 3) return 'Inválido';
                          return null;
                        },
                        focusNode: cvvFocus, onSubmitted: (String ) {  },
                        // Parâmetros adicionais podem ser passados se necessário
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 30,
                    child: Container(), // Você pode adicionar um widget aqui se necessário
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
