import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/product.dart';
import 'item_size.dart';

class CartProduct extends ChangeNotifier {

  // Adicionando 'id' para referenciar o documento no Firestore
  late String id;

  // Construtor que inicializa as variáveis
  CartProduct.fromProduct(this.product) {
    productId = product!.id;
    quantity = 1;
    size = product!.selectedSize?.name ?? ''; // Garantir que 'name' não seja nulo
    id = ''; // ID será atribuído quando o produto for salvo no Firestore
  }

  CartProduct.fromDocument(DocumentSnapshot document) {
    id = document.id;
    productId = (document.data() as Map<String, dynamic>)['pid'] as String;
    quantity = (document.data() as Map<String, dynamic>)['quantity'] as int;
    size = (document.data() as Map<String, dynamic>)['size'] as String;

    firestore.doc('products/$productId').get().then(
          (doc) {
             product = Product.fromDocument(doc);
             notifyListeners();
          }
    );
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Product? product;

  late String productId;
  late int quantity;
  late String size;

  ItemSize? get itemSize {
    if (product == null) return null;
    return product!.findSize(size);
  }

  num get unitPrice {
    if (product == null) return 0;
    return itemSize?.price ?? 0;
  }

  num get totalPrice => unitPrice * quantity;

  // Adicionando 'id' no mapa de dados
  Map<String, dynamic> toCartItemMap() {
    return {
      'pid': productId,
      'quantity': quantity,
      'size': size,
    };
  }

  bool stackable(Product product) {
    return product.id == productId && product.selectedSize!.name == size;
  }

  void increment() {
    quantity++;
    notifyListeners();
  }

  void decrement() {
    quantity--;
    notifyListeners();
  }

  bool get hasStock{
    final size= itemSize;
    if(size==null) return false;
    return size.stock >= quantity;

  }

}
