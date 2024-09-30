import 'package:brasil_fields/brasil_fields.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/screens/checkout/components/card_text_field.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CardFront extends StatelessWidget {

  CardFront(this.numberFocus, this.dateFocus, this.nameFocus, this.finished);
  final dateFormater = MaskTextInputFormatter(
      mask: '!#/####',
      filter: {
        '#': RegExp('[0-9]'),
        '!': RegExp('[0-1]')
      }
  );

  final VoidCallback finished;

  final FocusNode numberFocus;
  final FocusNode dateFocus;
  final FocusNode nameFocus;

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
        padding: const EdgeInsets.all(32),
        child: SingleChildScrollView( // Adicionando a rolagem
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CardTextField(
                title: 'Número',
                hint: '0000 0000 0000 0000',
                textInputType: TextInputType.number,
                bold: true,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CartaoBancarioInputFormatter(),
                ],
                validator: (number) {
                  if (number == null || number.isEmpty) {
                    return 'Campo obrigatório';
                  } else if (number.length != 19) {
                    return 'Número de cartão inválido';
                  } else {
                    final cardType = detectCCType(number);
                    if (cardType.isEmpty) {
                      return 'Cartão inválido';
                    }
                  }
                  return null;
                },
                onSubmitted: (_) {
                  dateFocus.requestFocus();
                },
                focusNode: numberFocus,
              ),
              CardTextField(
                title: 'Validade',
                hint: '11/2025',
                textInputType: TextInputType.number,
                bold: true,
                inputFormatters: [
                  dateFormater,
                ],
                validator: (date) {
                  if (date == null || date.isEmpty) {
                    return 'Campo obrigatório';
                  } else if (date.length != 7) {
                    return 'Data inválida';
                  }
                  return null;
                },
                onSubmitted: (_) {
                  nameFocus.requestFocus();
                },
                focusNode: dateFocus,
              ),
              CardTextField(
                title: 'Titular',
                hint: 'Hector de Araújo',
                textInputType: TextInputType.text,
                bold: true,
                inputFormatters: [],
                validator: (name) {
                  if (name == null || name.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
                onSubmitted: (String ) {
                  finished();
                },
                focusNode: nameFocus,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
