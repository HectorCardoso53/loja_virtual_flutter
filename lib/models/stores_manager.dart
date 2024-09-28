import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/store.dart';

class StoresManager extends ChangeNotifier {
  late Timer _timer; // Usando 'late' para indicar que será inicializado posteriormente

  StoresManager() {
    _loadStoresList();
    _startTime();
  }

  List<Store> stores = [];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> _loadStoresList() async {
    final snapshot = await firestore.collection('stores').get();
    stores = snapshot.docs.map((e) => Store.fromDocument(e)).toList();
    notifyListeners();
  }

  void _startTime() {
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      _checkOpening();
    });
  }

  void _checkOpening() {
    for (final store in stores) {
      store.updateStatus();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancelar o timer no dispose
    super.dispose();
  }
}
