import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:provider/provider.dart';
import '../../../models/cart_manager.dart';

class AddressInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartManager>(
      builder: (context, cartManager, child) {
        final address = cartManager.address ?? Address();

        // Criando controladores de texto para cada campo
        final streetController = TextEditingController(text: address.street);
        final numberController = TextEditingController(text: address.number);
        final complementController =
            TextEditingController(text: address.complement);
        final districtController =
            TextEditingController(text: address.district);
        final cityController = TextEditingController(text: address.city);
        final stateController = TextEditingController(text: address.state);

        String? emptyValidator(String? text) {
          return (text == null || text.isEmpty) ? 'Campo Obrigatório' : null;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: streetController,
              decoration: const InputDecoration(
                isDense: true,
                labelText: 'Rua/Travessa',
                hintText: 'Travessa Antônio Bentes',
                labelStyle: const TextStyle(
                  color: Color.fromARGB(255, 4, 125, 141), // Cor do label
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color:
                        Color.fromARGB(255, 4, 125, 141), // Cor padrão da borda
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(
                        255, 4, 125, 141), // Cor da borda quando não focado
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(
                        255, 4, 125, 141), // Cor da borda quando focado
                  ),
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.red), // Cor da borda com erro
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.red), // Cor da borda com erro e focado
                ),
              ),
              style: const TextStyle(
                color:
                    Color.fromARGB(255, 4, 125, 141), // Cor do texto digitado
              ),
              validator: emptyValidator,
              onSaved: (t) {
                address.street = streetController.text;
              },
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: numberController,
                    decoration: const InputDecoration(
                      isDense: true,
                      labelText: 'Número',
                      hintText: '123',
                      labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 4, 125, 141), // Cor do label
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(
                              255, 4, 125, 141), // Cor padrão da borda
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 4, 125,
                              141), // Cor da borda quando não focado
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(
                              255, 4, 125, 141), // Cor da borda quando focado
                        ),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.red), // Cor da borda com erro
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Colors.red), // Cor da borda com erro e focado
                      ),
                    ),
                    style: const TextStyle(
                      color: Color.fromARGB(
                          255, 4, 125, 141), // Cor do texto digitado
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                    validator: emptyValidator,
                    onSaved: (t) {
                      address.number = numberController.text;
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: complementController,
                    decoration: const InputDecoration(
                      isDense: true,
                      labelText: 'Complemento',
                      hintText: 'Próximo a praça centenário',
                      labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 4, 125, 141), // Cor do label
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(
                              255, 4, 125, 141), // Cor padrão da borda
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 4, 125,
                              141), // Cor da borda quando não focado
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(
                              255, 4, 125, 141), // Cor da borda quando focado
                        ),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.red), // Cor da borda com erro
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Colors.red), // Cor da borda com erro e focado
                      ),
                    ),
                    style: const TextStyle(
                      color: Color.fromARGB(
                          255, 4, 125, 141), // Cor do texto digitado
                    ),
                    onSaved: (t) {
                      address.complement = complementController.text;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: districtController,
              decoration: const InputDecoration(
                isDense: true,
                labelText: 'Bairro',
                hintText: 'Fátima',
                labelStyle: const TextStyle(
                  color: Color.fromARGB(255, 4, 125, 141), // Cor do label
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color:
                        Color.fromARGB(255, 4, 125, 141), // Cor padrão da borda
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(
                        255, 4, 125, 141), // Cor da borda quando não focado
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(
                        255, 4, 125, 141), // Cor da borda quando focado
                  ),
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.red), // Cor da borda com erro
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.red), // Cor da borda com erro e focado
                ),
              ),
              style: const TextStyle(
                color:
                    Color.fromARGB(255, 4, 125, 141), // Cor do texto digitado
              ),
              onSaved: (t) {
                address.district = districtController.text;
              },
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: cityController,
                    enabled: false,
                    decoration: const InputDecoration(
                      isDense: true,
                      labelText: 'Cidade',
                      hintText: 'Oriximiná',
                      labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 4, 125, 141), // Cor do label
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(
                              255, 4, 125, 141), // Cor padrão da borda
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 4, 125,
                              141), // Cor da borda quando não focado
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(
                              255, 4, 125, 141), // Cor da borda quando focado
                        ),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.red), // Cor da borda com erro
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Colors.red), // Cor da borda com erro e focado
                      ),
                    ),
                    style: const TextStyle(
                      color: Color.fromARGB(
                          255, 4, 125, 141), // Cor do texto digitado
                    ),
                    onSaved: (t) {
                      address.city = cityController.text;
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: stateController,
                    autocorrect: false,
                    enabled: false,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: 'UF',
                      hintText: 'PA',
                      counterText: '',
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 7, horizontal: 4),
                      labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 4, 125, 141), // Cor do label
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(
                              255, 4, 125, 141), // Cor padrão da borda
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 4, 125,
                              141), // Cor da borda quando não focado
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(
                              255, 4, 125, 141), // Cor da borda quando focado
                        ),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.red), // Cor da borda com erro
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Colors.red), // Cor da borda com erro e focado
                      ),
                    ),
                    style: const TextStyle(
                      color: Color.fromARGB(
                          255, 4, 125, 141), // Cor do texto digitado
                    ),
                    maxLines: 1,
                    // Alterado para 1 linha
                    onSaved: (t) {
                      address.state = stateController.text;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Adicione qualquer lógica adicional que você precise aqui
                if(Form.of(context).validate()){
                  Form.of(context).save();
                  context.read<CartManager>().setAddress(address);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                disabledBackgroundColor:
                    Theme.of(context).primaryColor.withAlpha(100),
              ),
              child: const Text(
                'Calcular Frete',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
