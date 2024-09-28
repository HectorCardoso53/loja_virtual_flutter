import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/order.dart';

class CheckoutManager extends ChangeNotifier {
  CartManager? cartManager;


  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value){
    _loading = value;
    notifyListeners();
  }
  // Atualiza o cartManager
  void updateCart(CartManager cartManager) {
    this.cartManager = cartManager;
  }

  // Chama as funções de checkout
  Future<void> checkout({required Function onStockFail, required Function onSuccess}) async{
   loading = true;
    try{
      await _decrementStock();
    }catch(e){
      onStockFail(e);
      loading = false;
      return;
    }

    //  TODO PROCESSAR PAGAMENTO



    final orderId = await _getOrderId();

    final order = Orders.fromCartManager(cartManager!);
    order.orderId = orderId.toString();

    await order.save();

    cartManager!.clear();

    onSuccess(order);

    loading = false;

  }

  Future<int> _getOrderId() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      final ref = firestore.doc('aux/ordercount');
      final result = await firestore.runTransaction((tx) async {
        final doc = await tx.get(ref);
        final data = doc.data(); // Chama o método data()

        if (data != null && data.containsKey('current')) {
          final orderId = data['current'] as int;
          await tx.update(ref, {'current': orderId + 1});
          return {'orderId': orderId};
        } else {
          throw Exception('Campo "current" não encontrado ou dados nulos.');
        }
      });

      return result['orderId'] as int;
    } catch (e) {
      debugPrint(e.toString());
      return Future.error('Falha ao gerar Id');
    }
  }

  // Função para decrementar o estoque
  Future<void> _decrementStock() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Verifica se cartManager não é nulo antes de acessar
    if (cartManager != null) {
      return firestore.runTransaction((tx) async {
        final List<Product> productsToUpdate = [];
        final List<Product> productsWiththoutStock = [];
        // Acessa cartManager!.items se ele não for nulo
        for (final cartProduct in cartManager!.items) {
          Product product;

          if(productsToUpdate.any((e)=>e.id ==cartProduct.productId )){
            product = productsToUpdate.firstWhere((e)=>e.id ==cartProduct.productId);
          }else{
            final doc =
            await tx.get(firestore.doc('products/${cartProduct.productId}'));
            product = Product.fromDocument(doc);
          }

          cartProduct.product = product;

          final size = product.findSize(cartProduct.size);
          if (size!.stock - cartProduct.quantity < 0) {
            productsWiththoutStock.add(product);
          } else {
            size.stock -= cartProduct.quantity;
            productsToUpdate.add(product);
          }
        }
        if(productsWiththoutStock.isNotEmpty){
          return Future.error('${productsWiththoutStock.length} produtos sem estoque');
        }

        for(final product in productsToUpdate){
          tx.update(
              firestore.doc('products/${product.id}'),
              {'sizes':product.exportSizeList()});
        }
      });
    } else {
      debugPrint('cartManager é nulo');
    }
  }
}
