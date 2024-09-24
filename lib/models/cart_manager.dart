import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/models/users.dart';
import 'package:loja_virtual/services/cepaberto_service.dart';

import 'cart_product.dart';

class CartManager extends ChangeNotifier {
  List<CartProduct> items = [];

  Users? user; // Pode ser nulo

  Address? address;
  num productPrice = 0.0;
  num? deliveryPrice;
  num get totalPrice => productPrice + (deliveryPrice ?? 0.0);

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value){
    _loading = value;
    notifyListeners();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Atualiza o usuário e carrega os itens do carrinho
  void updateUser(UserManager userManager) {
    user = userManager.user;
    productPrice = 0.0;
    items.clear();
    removeAddress();
    if (user != null) {
      _loadCartItems();
      _loadUserAddress();
    }
  }

  void clear(){
   for(final cartProduct in items){
     user!.cartReference.doc(cartProduct.id).delete();
   }
   items.clear();
   notifyListeners();
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

  Future<void> _loadUserAddress() async {
    if (user?.address != null // Verifica se user e address não são nulos
        && await calculateDelivery(user!.address!.lat, user!.address!.long)) {
      address = user!.address;
      notifyListeners();
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

  bool get isAddressValid => address != null && deliveryPrice != null;

  Future<void> setAddress(Address address)async{
    loading = true;
    this.address = address;

    if(await calculateDelivery(address.lat, address.long)){
      user?.setAddress(address);
      loading = false;
    }else{
      loading = false;
      return Future.error('Endereço fora do raio de entrega:(');
    }
  }

  //ENDEREÇO
  Future<void> getAddress(String cep) async {
    loading = true;
    final cepAbertoService = CepAbertoService();

    try {
      final cepAbertoAddress = await cepAbertoService.getAddressFromCep(cep);

      print(cepAbertoAddress);

      if (cepAbertoAddress != null) {
        address = Address(
          street: cepAbertoAddress.logradouro ?? '',
          district: cepAbertoAddress.bairro ?? '',
          zipCode: cepAbertoAddress.cep ?? '',
          city: cepAbertoAddress.cidade.nome ?? '',
          state: cepAbertoAddress.estado.sigla ?? '',
          lat: cepAbertoAddress.latitude ?? 0.0,
          long: cepAbertoAddress.longitude ?? 0.0,
        );

      }
      loading = false;
    } catch (e) {
      loading = false;
     return Future.error('CEP inválido ');
    }

  }

  void removeAddress(){
    address = null;
    deliveryPrice = null;
    notifyListeners();
  }

  Future<bool> calculateDelivery(double lat, double long) async {
    final DocumentSnapshot doc = await firestore.doc('aux/delivery').get();

    // Corrigir para doc.data() e usar os colchetes corretamente
    final latStore = (doc.data() as Map<String, dynamic>)['lat'] as double;
    final longStore = (doc.data() as Map<String, dynamic>)['long'] as double;

    final base = (doc.data() as Map<String, dynamic>)['base'] as num;
    final km = (doc.data() as Map<String, dynamic>)['km'] as num;
    final maxKm = (doc.data() as Map<String, dynamic>)['maxKm'] as num;

    // Corrigir o nome do método para `distanceBetween`
    double dis = await Geolocator.distanceBetween(latStore, longStore, lat, long);

    dis /= 1000.0;

    print('Distância: $dis km');

    if(dis>maxKm){
      return false;
    }

    deliveryPrice = base + dis * km;
    return true;
  }
}
