import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/users.dart';
import 'order.dart';

class AdminOrdersManager extends ChangeNotifier {
  final List<Orders> _orders = [];
  Users? userFilter;
  List<Status> statusFilter = [Status.preparing]; // Status padrão

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  StreamSubscription? _subscription;

  // Atualiza o status do administrador e inicia a escuta de pedidos
  void updateAdmin({required bool adminEnable}) {
    _orders.clear();
    _subscription?.cancel();
    if (adminEnable) {
      _listenToOrders();
    }
  }

  // Getter para obter os pedidos filtrados
  List<Orders> get filteredOrders {
    var filtered = _orders.reversed.toList();

    if (userFilter != null) {
      filtered = filtered.where((order) => order.userId == userFilter!.id).toList();
    }

    filtered = filtered.where((order) => statusFilter.contains(order.status)).toList();

    return filtered;
  }

  // Escuta as atualizações da coleção de pedidos no Firestore
  void _listenToOrders() {
    _subscription = firestore.collection('orders').snapshots().listen((snapshot) {
      _orders.clear();
      for (final doc in snapshot.docs) {
        _orders.add(Orders.fromDocument(doc));
      }
      notifyListeners(); // Notifica os ouvintes quando há mudanças
    });
  }

  // Define o filtro de usuário
  void setUserFilter(Users? user) {
    userFilter = user;
    notifyListeners();
  }

  // Define o filtro de status
  void setStatusFilter(Status status, bool enabled) {
    if (enabled && !statusFilter.contains(status)) {
      statusFilter.add(status); // Adiciona o status se ele não estiver presente
    } else if (!enabled && statusFilter.contains(status)) {
      statusFilter.remove(status); // Remove o status se ele estiver presente
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel(); // Cancela a assinatura ao descartar o manager
    super.dispose();
  }
}
