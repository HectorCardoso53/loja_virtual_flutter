import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/models/users.dart';

import 'cart_product.dart';

class CartManager extends ChangeNotifier {
  List<CartProduct> items = [];

  Users? user; // Pode ser nulo
  num productPrice = 0.0;

  // Atualiza o usuário e carrega os itens do carrinho
  void updateUser(UserManager userManager) {
    user = userManager.user;
    items.clear();

    if (user != null) {
      _loadCartItems();
    }
  }

  // Carrega os itens do carrinho do Firestore
  Future<void> _loadCartItems() async {
    try {
      final QuerySnapshot cartSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.id)
          .collection('cart')
          .get();

      // Mapeia os documentos para CartProduct, com tratamento de erros
      items = cartSnap.docs.map((doc) {
        try {
          final cartProduct = CartProduct.fromDocument(doc)
            ..addListener(_onItemUpdated);
          return cartProduct;
        } catch (e) {
          print('Erro ao converter documento do produto: $e');
          return null;
        }
      }).where((cartProduct) => cartProduct != null).cast<CartProduct>().toList();

      print('Itens do carrinho carregados com sucesso: ${items.length}');

      _updateTotalPrice(); // Atualiza o preço total ao carregar os itens

    } catch (e) {
      print('Erro ao carregar itens do carrinho: $e');
    }
  }

  // Adiciona um produto ao carrinho
  void addToCart(Product product) {
    try {
      final existingProduct = items.firstWhere((p) => p.stackable(product));
      existingProduct.increment();
    } catch (e) {
      final cartProduct = CartProduct.fromProduct(product);
      cartProduct.addListener(_onItemUpdated);
      items.add(cartProduct);
      user?.cartReference.add(cartProduct.toCartItemMap()).then((doc) {
        cartProduct.id = doc.id;
      });
    }
    _updateTotalPrice();
    notifyListeners();
  }

  // Atualiza o preço total do carrinho
  void _updateTotalPrice() {
    productPrice = 0;

    for (final cartProduct in items) {
      productPrice += cartProduct.totalPrice;
    }

    print('Preço total atualizado: $productPrice');
    notifyListeners(); // Notifica os ouvintes que o preço total foi atualizado
  }

  // Função chamada quando o carrinho é atualizado
// Função chamada quando o carrinho é atualizado
  void _onItemUpdated() {
    // Reinicia o valor do preço total
    productPrice = 0;

    // Faz uma cópia da lista de itens para evitar erros de modificação concorrente
    final List<CartProduct> itemsCopy = List.from(items);

    bool needsUpdate = false;

    for (final cartProduct in itemsCopy) {
      // Adiciona print para depuração
      print("Verificando item: ${cartProduct.productId}, Quantidade: ${cartProduct.quantity}");

      if (cartProduct.quantity == 0) {
        print("Item ${cartProduct.productId} removido do carrinho.");
        removeOffCart(cartProduct);
        needsUpdate = true;
      } else {
        // Soma o preço total dos produtos no carrinho
        productPrice += cartProduct.totalPrice;
        print("Atualizando item: ${cartProduct.productId}, Preço total do item: ${cartProduct.totalPrice}");

        // Atualiza o produto no Firestore
        _updateCartProduct(cartProduct);
      }
      notifyListeners();
    }

    if (needsUpdate) {
      // Se houve remoções, atualize o preço total
      _updateTotalPrice();
      print("Preço total atualizado após remoções: $productPrice");
    } else {
      print("Nenhuma remoção necessária. Preço total atual: $productPrice");
    }

    // Exibe o preço total no console para depuração
    print("Preço total dos produtos no carrinho: $productPrice");

    // Notifica os ouvintes que o carrinho foi atualizado
    notifyListeners();
  }

  // Atualiza o produto no Firestore
  void _updateCartProduct(CartProduct cartProduct) {
    if (cartProduct.id != null) {
      user!.cartReference.doc(cartProduct.id).update(cartProduct.toCartItemMap());
    }
  }

  // Remove o produto do carrinho
  void removeOffCart(CartProduct cartProduct) {
    items.removeWhere((p) => p.id == cartProduct.id);
    user!.cartReference.doc(cartProduct.id).delete();
    cartProduct.removeListener(_onItemUpdated);
    notifyListeners();
    _updateTotalPrice(); // Atualiza o preço total após a remoção
  }

  // Verifica se todos os produtos no carrinho têm estoque
  bool get isCartValid {
    for (final cartProduct in items) {
      if (!cartProduct.hasStock) return false;
    }
    return true;
  }
}
