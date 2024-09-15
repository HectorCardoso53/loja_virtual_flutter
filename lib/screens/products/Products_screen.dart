import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/products_manager.dart';
import 'package:loja_virtual/screens/products/components/product_list_tile.dart';
import 'package:provider/provider.dart';

import '../../models/user_manager.dart';
import 'components/search_dialog.dart';

class ProductsScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 4, 125, 141),
        title: Consumer<ProductsManager>(
          builder: (context, productManager, child) {
            if (productManager.search.isEmpty) {
              return const Text(
                'Produtos',
                style: TextStyle(color: Colors.white),
              );
            } else {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return GestureDetector(
                    onTap: () async {
                      final search = await showDialog<String>(
                        context: context,
                        builder: (context) =>
                            SearchDialog(productManager.search),
                      );
                      if (search != null) {
                        productManager.search = search;
                      }
                    },
                    child: Container(
                      width: constraints.biggest.width,
                      child: Text(
                        productManager.search,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
        centerTitle: true, // Agora dentro do AppBar
        actions: [
          Consumer<ProductsManager>(
            builder: (context, productManager, child) {
              if (productManager.search.isEmpty) {
                return IconButton(
                  onPressed: () async {
                    final search = await showDialog<String>(
                      context: context,
                      builder: (context) => SearchDialog(productManager.search),
                    );
                    if (search != null) {
                      productManager.search = search;
                    }
                  },
                  icon: Icon(Icons.search),
                );
              } else {
                return IconButton(
                  onPressed: () async {
                    productManager.search = '';
                  },
                  icon: Icon(Icons.close),
                );
              }
            },
          ),
          Consumer<UserManager>(
            builder: (_, userManager, child) {
              if (userManager.adminEnabled) {
                return IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                        '/edit_product',
                    );
                  },
                  icon: Icon(Icons.add),
                );
              } else {
                return Container();
              }
            },
          )
        ],
      ),
      body: Consumer<ProductsManager>(
        builder: (context, productManager, child) {
          final filteredProducts = productManager.filteredProducts;
          return ListView.builder(
            padding: const EdgeInsets.all(4),
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              return ProductListTile(filteredProducts[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor:Theme.of(context).primaryColor,
        onPressed:(){
          Navigator.of(context).pushNamed('/cart');
        },
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}
