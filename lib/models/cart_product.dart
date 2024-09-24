import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/product.dart';
import 'item_size.dart';

class CartProduct extends ChangeNotifier {
  late String id; // ID do documento no Firestore
  Product? _product; // Produto vinculado ao item do carrinho
  bool _isLoading = true; // Para controlar o estado de carregamento
  late String productId; // ID do produto
  late int quantity; // Quantidade do item no carrinho
  late String size; // Tamanho do produto
  num? fixedPrice; // Preço fixo, se aplicável

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Getters
  Product? get product => _product;
  bool get isLoading => _isLoading;
  num get unitPrice => _product?.findSize(size)?.price ?? 0; // Preço por unidade
  num get totalPrice => unitPrice * quantity; // Preço total
  bool get hasStock {
    final itemSize = _product?.findSize(size);
    return itemSize != null && itemSize.stock >= quantity; // Verifica estoque
  }

  set product(Product? value) {
    _product = value;
    notifyListeners();
  }

  // Construtores
  CartProduct.fromProduct(this._product) {
    productId = _product!.id;
    quantity = 1;
    size = _product!.selectedSize?.name ?? '';
    id = '';
    _isLoading = false;
  }

  CartProduct.fromDocument(DocumentSnapshot document) {
    id = document.id;
    _initializeFromMap(document.data() as Map<String, dynamic>);
    _loadProduct();
  }

  CartProduct.fromMap(Map<String, dynamic> map) {
    _initializeFromMap(map);
    _loadProduct();
  }

  void _initializeFromMap(Map<String, dynamic> map) {
    productId = map['pid'] as String;
    quantity = map['quantity'] as int;
    size = map['size'] as String;
    fixedPrice = map['fixedPrice'] as num? ?? 0; // Valor padrão se null
  }

  // Carregar o produto do Firestore
  Future<void> _loadProduct() async {
    _isLoading = true;
    notifyListeners();

    try {
      DocumentSnapshot doc = await firestore.doc('products/$productId').get();
      if (doc.exists) {
        _product = Product.fromDocument(doc);
        print('Produto carregado: ${_product!.name}');
      } else {
        print('Produto não encontrado');
        _product = null;
      }
    } catch (e) {
      print('Erro ao carregar produto: $e');
      _product = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Mapa de dados para salvar o item do carrinho
  Map<String, dynamic> toCartItemMap() {
    return {
      'pid': productId,
      'quantity': quantity,
      'size': size,
    };
  }

  // Verifica se o produto pode ser empilhado
  bool stackable(Product product) {
    return product.id == productId && product.selectedSize!.name == size;
  }

  // Incrementa a quantidade do item
  void increment() {
    quantity++;
    notifyListeners();
  }

  // Decrementa a quantidade do item
  void decrement() {
    if (quantity > 1) {
      quantity--;
      notifyListeners();
    }
  }

  // Mapa de dados para salvar o item do pedido
  Map<String, dynamic> toOrderItemMap() {
    return {
      'pid': productId,
      'quantity': quantity,
      'size': size,
      'fixedPrice': fixedPrice ?? unitPrice,
    };
  }
}
