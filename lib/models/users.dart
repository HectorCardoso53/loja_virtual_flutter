import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String? id;
  String? name;
  String? email;
  String? password;
  String? confirmPassword;

  bool admin = false;

  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.doc('users/$id');

  CollectionReference get cartReference =>
    firestoreRef.collection('cart');

  Future<void> saveData() async {
    await firestoreRef.set(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
    };
  }

  // Construtor com parâmetros opcionais
  Users({this.id, this.name, this.email, this.password, this.confirmPassword});

  Users.fromDocument(DocumentSnapshot document) {
    id = document.id;
    final data = document.data() as Map<String, dynamic>;
    name = data['name'] as String;
    email = data['email'] as String;
  }
}
