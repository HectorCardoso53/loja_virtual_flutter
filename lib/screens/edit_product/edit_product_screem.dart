import 'package:flutter/material.dart';
import 'package:loja_virtual/models/order.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/products_manager.dart';
import 'package:loja_virtual/screens/orders/cancel_order_dialog.dart';
import 'package:provider/provider.dart';

import 'components/images_form.dart';
import 'components/sizes_form.dart';

class EditProductScreen extends StatelessWidget {
  EditProductScreen({Product? product})
      : editing = product != null,
        product = product?.clone() ?? Product();


  final Product product;
  final bool editing;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 4, 125, 141),
          title: Text(
            editing ? 'Editar Produto' : 'Criar Produto',
            style: const TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          actions: [
            if (editing)
              IconButton(
                onPressed: (){
                  context.read<ProductsManager>().delete(product);
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.delete),
              ),
          ],
        ),
        backgroundColor: Colors.white,
        body: Form(
          key: formkey,
          child: ListView(
            children: [
              ImagesForm(product),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      initialValue: product.name,
                      decoration: const InputDecoration(
                        hintText: 'Título',
                        border: InputBorder.none, // Remove a borda
                      ),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      validator: (name) {
                        if (name == null || name.length < 6) {
                          return 'Título muito curto';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (name) => product.name = name!,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        'A partir de ',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ),
                    Text(
                      'R\$ ${product.basePrice.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 4),
                      child: Text(
                        'Descrição',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextFormField(
                      initialValue: product.description,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        hintText: 'Descrição',
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                      validator: (desc) {
                        if (desc == null || desc.length < 10) {
                          return 'Descrição muito curta';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (desc) => product.description = desc!,
                    ),
                    SizesForm(product),
                    const SizedBox(height: 20),
                    Consumer<Product>(
                      builder: (_, product, __) {
                        return ElevatedButton(
                          onPressed: product.loading
                              ? null
                              : () async {
                                  if (formkey.currentState!.validate()) {
                                    formkey.currentState!.save();
                                    await product.save();
                                    context
                                        .read<ProductsManager>()
                                        .update(product);
                                    Navigator.of(context).pop();
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            disabledBackgroundColor:
                                Theme.of(context).primaryColor.withAlpha(100),
                          ),
                          child: product.loading
                              ? const CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                )
                              : const Text(
                                  'Salvar',
                                  style: TextStyle(color: Colors.white),
                                ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
