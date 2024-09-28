import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:loja_virtual/models/cart_product.dart';

enum Status { canceled, preparing, transporting, delivery }

class Orders {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String orderId = ''; // Inicializando com valor padrão
  List<CartProduct> items = []; // Inicializando com lista vazia
  num price = 0; // Inicializando com 0
  String userId = ''; // Inicializando com string vazia
  Address address = Address(); // Inicializando com um novo Address
  Timestamp date = Timestamp.now(); // Inicializando com o timestamp atual
  Status status = Status.preparing; // Inicializando com Status padrão

  // Construtor que cria um pedido a partir do CartManager
  Orders.fromCartManager(CartManager cartManager) {
    items = List.from(cartManager.items);
    price = cartManager.totalPrice ?? 0; // Tratamento para null safety
    userId = cartManager.user?.id ?? ''; // Verifica se user ou id é nulo
    address = cartManager.address ?? Address(); // Verifica se address é nulo
    status = Status.preparing;

    print('Pedido criado do CartManager: $this'); // Print para depuração
  }

  // Construtor que cria um pedido a partir de um DocumentSnapshot do Firestore
  Orders.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>; // Obtém os dados do documento como mapa
    orderId = doc.id; // Obtém o ID do pedido

    // Tratamento de nulos para os itens
    items = (data['items'] as List<dynamic>? ?? []).map((e) {
      return CartProduct.fromMap(e as Map<String, dynamic>);
    }).toList();

    // Tratamento de nulos para o preço, usuário e endereço
    price = data['price'] as num? ?? 0; // Define o preço como 0 se for nulo
    userId = data['user'] as String? ?? ''; // Define o userId como string vazia se for nulo

    // Se address for nulo, cria um novo Address
    address = data['address'] != null
        ? Address.fromMap(data['address'] as Map<String, dynamic>)
        : Address(); // Cria um novo endereço vazio se não houver dados

    // Tratamento de nulo para a data
    date = data['date'] as Timestamp? ?? Timestamp.now(); // Define a data como agora se for nula

    // Acessa o status corretamente usando os dados do mapa
    status = Status.values[data['status'] as int];

    print('Pedido criado do Firestore: $this'); // Print para depuração
  }

  void updateFromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>; // Obtém os dados do documento como mapa
    // Acessa o status corretamente usando os dados do mapa
    status = Status.values[data['status'] as int];
  }

  // Método para salvar o pedido no Firestore
  Future<void> save() async {
    try {
      await firestore.collection('orders').doc(orderId).set({
        'items': items.map((e) => e.toOrderItemMap()).toList(),
        'price': price,
        'user': userId,
        'address': address.toMap(),
        'date': date, // Salvar a data do pedido
        'status': status.index
      });
      print('Pedido salvo com sucesso: $this'); // Print para confirmação
    } catch (e) {
      print('Erro ao salvar o pedido: $e'); // Print para erros
    }
  }

  // Propriedades para verificar se pode voltar ou avançar
  bool get canGoBack => status.index > 0; // Pode voltar se não estiver no primeiro status
  bool get canAdvance => status.index < Status.values.length - 1; // Pode avançar se não estiver no último status

  // Formata o ID do pedido
  String get formattedId => '#${orderId.padLeft(6, '0')}';

  String get statusText => getStatusText(status);

  static String getStatusText(Status status) {
    switch (status) {
      case Status.canceled:
        return 'Cancelado';
      case Status.preparing:
        return 'Em Preparação';
      case Status.transporting:
        return 'Em Transporte';
      case Status.delivery:
        return 'Entregue';
      default:
        return '';
    }
  }

  @override
  String toString() {
    return 'Orders{orderId: $orderId, items: $items, price: $price, userId: $userId, address: $address, date: $date}';
  }

  void cancel() {
    status = Status.canceled;
    firestore.collection('orders').doc(orderId).update(
      {'status': status.index},
    );
  }

  Function()? get back {
    // Retorna uma função que retrocede o status, ou null
    if (canGoBack) {
      return () {
        status = Status.values[status.index - 1];
        firestore.collection('orders').doc(orderId).update(
          {'status': status.index},
        );
      };
    }
    return null; // Não retorna nada caso a condição não seja atendida
  }

  Function()? get advance {
    // Retorna uma função que avança o status, ou null
    if (canAdvance) {
      return () {
        status = Status.values[status.index + 1];
        firestore.collection('orders').doc(orderId).update(
          {'status': status.index},
        );
      };
    }
    return null; // Não retorna nada caso a condição não seja atendida
  }
}
