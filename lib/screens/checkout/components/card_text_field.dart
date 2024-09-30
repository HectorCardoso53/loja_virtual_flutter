import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardTextField extends StatelessWidget {
  const CardTextField({
    Key? key,
    this.title = '',
    this.bold = false,
    this.hint = '',
    this.textInputType = TextInputType.text,
    this.inputFormatters = const [],
    this.validator = _defaultValidator,
    this.maxLength,
    this.textAlign,
    this.focusNode,
    required this.onSubmitted,
  }) : textInputAction = onSubmitted == null
      ?TextInputAction.done
      : TextInputAction.next;

  final String title;
  final bool bold;
  final String hint;
  final TextInputType textInputType;
  final List<TextInputFormatter> inputFormatters;
  final FormFieldValidator<String> validator;
  final int? maxLength;
  final TextAlign? textAlign;
  final FocusNode? focusNode;
  final Function(String) onSubmitted;
  final TextInputAction textInputAction;

  static String? _defaultValidator(String? value) {
    return null; // Retorna nulo, indicando que não há erro
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: '',
      validator: validator,
      builder: (state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: SingleChildScrollView(
            // Solução com scroll
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title.isNotEmpty)
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      if (state.hasError)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: const Text(
                            ' Preencha o campo',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 9,
                            ),
                          ),
                        )
                    ],
                  ),
                TextFormField(
                  style: TextStyle(
                    color: title == null && state.hasError ? Colors.redAccent : Colors.white,
                    fontWeight: bold ? FontWeight.bold : FontWeight.w600,
                  ),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: title == null && state.hasError ? Colors.redAccent : Colors.white.withAlpha(100),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 2),
                    counterText: '',
                  ),
                  keyboardType: textInputType,
                  inputFormatters: inputFormatters,
                  onChanged: (text) {
                    state.didChange(text);
                  },
                  maxLength: maxLength,
                  textAlign:
                      textAlign ?? TextAlign.start, // Define um valor padrão
                      focusNode: focusNode,
                      onFieldSubmitted: onSubmitted,
                      textInputAction: textInputAction,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
