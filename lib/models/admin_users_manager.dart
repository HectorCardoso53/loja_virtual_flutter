import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/models/users.dart';

class AdminUsersManager extends ChangeNotifier {
  List<Users> users = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
   StreamSubscription? _subscription;
  
  void updateUser(UserManager userManager) {
    _subscription?.cancel();
    if (userManager.adminEnabled) {
      _listemToUsers();
    }else{
      users.clear();
      notifyListeners();
    }
  }

  void _listemToUsers() {
    _subscription = firestore.collection('users').snapshots().listen((snapshot){
      users = snapshot.docs.map((d)=> Users.fromDocument(d)).toList();
      // Classifica a lista com valores não nulos
      users.sort((a, b) =>
          (a.name ?? '').toLowerCase().compareTo((b.name ?? '').toLowerCase())
      );

      notifyListeners();
    });


  }

  // Alterado para retornar uma lista de strings
  List<String> get names => users.map((e) => e.name ?? '').toList();

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

}
