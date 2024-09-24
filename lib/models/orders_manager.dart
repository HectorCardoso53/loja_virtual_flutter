import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/order.dart';
import 'package:loja_virtual/models/users.dart';

class OrdersManager extends ChangeNotifier {
  Users? users;
  List<Orders> orders = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  StreamSubscription? _subscription;

  void updateUser(Users user) {
    this.users = user;
    orders.clear(); // Limpa a lista de pedidos quando o usuário muda
    print('Usuário atualizado: ${user.id}'); // Print para depuração

    _subscription?.cancel(); // Cancela a assinatura anterior
    if (user != null) {
      _listenToOrders(); // Inicia a escuta de pedidos se o usuário não for nulo
    }
  }

  void _listenToOrders() {
    _subscription = firestore.collection('orders')
        .where('user', isEqualTo: users!.id) // Filtra os pedidos pelo ID do usuário
        .snapshots().listen((e) {
      orders.clear(); // Limpa a lista de pedidos
      for (final doc in e.docs) {
        orders.add(Orders.fromDocument(doc)); // Adiciona os pedidos recebidos
      }
      print('Pedidos atualizados: $orders'); // Print para ver os pedidos recebidos
      notifyListeners(); // Notifica os ouvintes sobre mudanças na lista de pedidos
    }, onError: (error) {
      print('Erro ao ouvir pedidos: $error'); // Print para erros de escuta
    });
  }

  @override
  void dispose() {
    _subscription?.cancel(); // Cancela a assinatura ao descartar o manager
    super.dispose();
  }
}
