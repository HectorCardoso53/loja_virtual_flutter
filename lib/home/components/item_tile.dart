import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loja_virtual/models/home_manager.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/products_manager.dart';
import 'package:loja_virtual/models/section_item.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../models/section.dart';

class ItemTile extends StatelessWidget {
  final SectionItem item;

  const ItemTile(this.item);

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();
    final productsManager = context.read<ProductsManager>();

    return GestureDetector(
      onTap: () {
        if (item.product != null) {
          final product = productsManager.findProductById(item.product!);
          if (product != null) {
            Navigator.of(context).pushNamed('/product', arguments: product);
          }
        }
      },
      onLongPress: homeManager.editing
          ? () {
              showDialog(
                context: context,
                builder: (_) {
                  final product = item.product != null
                      ? productsManager.findProductById(item.product!)
                      : null;
                  return AlertDialog(
                    title: Text('Editar item'),
                    content: product != null
                        ? ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Image.network(product.images.isNotEmpty
                                ? product.images.first
                                : ''),
                            title: Text(
                              product.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            subtitle: Text(
                                'R\$ ${product.basePrice.toStringAsFixed(2)}'),
                          )
                        : Text('Produto não encontrado'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          final section = context.read<Section>();
                          section.removeItem(item);
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Excluir',
                          style: TextStyle(
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (product != null) {
                            // Desvincular produto
                            item.product = null;
                          } else {
                            // Vincular produto
                            final result = await Navigator.of(context)
                                .pushNamed('/select_product');

                            // Verifica se o resultado não é nulo e é do tipo Product
                            if (result != null && result is Product) {
                              item.product = result.id;
                            } else {
                              // Lida com o caso onde nenhum produto foi selecionado ou o resultado é inválido
                              print(
                                  'Nenhum produto selecionado ou resultado inválido');
                            }
                          }
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          product != null ? 'Desvincular' : 'Vincular',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          : null,
      child: item.image is String
          ? FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: item.image as String,
              fit: BoxFit.cover,
            )
          : Image.file(
              item.image as File,
              fit: BoxFit.cover,
            ),
    );
  }
}
