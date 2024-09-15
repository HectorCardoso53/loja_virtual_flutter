import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:loja_virtual/models/firebase_erros.dart';
import 'package:loja_virtual/models/users.dart';

class UserManager extends ChangeNotifier {
  UserManager() {
    _loadCurrentUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  User? firebaseUser; // Usuário do Firebase
  Users? user; // Modelo personalizado de usuário

  bool _loading = false;
  bool get loading => _loading;

  bool get isLoggedIn => user != null;

  // Getter para o firebaseUser
  User? get currentUser => firebaseUser;

  Future<void> signIn({
    required String email,
    required String password,
    required Function(String) onFail,
    required Function onSuccess,
  }) async {
    loading = true;
    try {
      final UserCredential result = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      await _loadCurrentUser(firebaseUser: result.user);

      onSuccess(); // Se a autenticação for bem-sucedida
    } catch (e) {
      if (e is FirebaseAuthException) {
        final errorMessage = getErrorString(e.code);
        onFail(errorMessage);
      } else {
        onFail('Um erro indefinido ocorreu.');
      }
      loading = false;
    }
  }

  Future<void> signUp({
    required Users user, // Modelo personalizado de usuário
    required Function onFail,
    required Function onSuccess,
  }) async {
    loading = true;
    try {
      final UserCredential result = await auth.createUserWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      );

      firebaseUser = result.user;
      user.id = firebaseUser!.uid;

      await user.saveData(); // Salva os dados no Firestore

      this.user = user; // Atribui o modelo `Users` ao gerenciador

      onSuccess();
    } catch (e) {
      if (e is FirebaseAuthException) {
        final errorMessage = getErrorString(e.code);
        onFail(errorMessage);
      } else {
        onFail('Um erro indefinido ocorreu.');
      }
      loading = false;
    }
  }

  void signOut(){
    auth.signOut();
    user = null;
    notifyListeners();
  }

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> _loadCurrentUser({User? firebaseUser}) async {
    firebaseUser = auth.currentUser ?? firebaseUser;

    if (firebaseUser != null) {
      final DocumentSnapshot docUser = await firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      user = Users.fromDocument(docUser); // Converte o documento em `Users`

      final docAdmin = await firestore.collection('admins').doc(user!.id).get();
      if(docAdmin.exists){
        user!.admin = true;
      }

      print(user!.admin);

      notifyListeners();
    }
  }

  bool get adminEnabled => user != null && user!.admin;
}

