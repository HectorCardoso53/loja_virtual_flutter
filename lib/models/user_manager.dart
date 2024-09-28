
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
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


  bool _loadingface = false;
  bool get loadingFace => _loadingface;
  set loadingFace(bool value){
    _loadingface = value;
    notifyListeners();
  }



  Future<void> signInWithGoogle({
    required Function onSuccess,
    required Function(String) onFail,
    required BuildContext context, // Adicione o contexto aqui
  }) async {
    try {
      loadingFace = true;
      final GoogleSignInAccount? googleUserAccount = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUserAccount?.authentication;
      final credentialUser = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final UserCredential userCredential = await auth.signInWithCredential(credentialUser);
      firebaseUser = userCredential.user;

      // Carregar ou salvar o usuário no Firestore
      await _loadCurrentUser(firebaseUser: firebaseUser);

      // Exibe o SnackBar para informar que o login foi bem-sucedido
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login com Google realizado com sucesso!'))
      );

      // Redireciona para a tela Home após um curto delay
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, '/home'); // Navega para a tela Home
      });

      // Chama a função de sucesso
      onSuccess();
      loadingFace= false;
    } catch (e) {
      print('Erro ao fazer login com o Google: $e');
      if (e is FirebaseAuthException) {
        onFail(getErrorString(e.code)); // Lida com erros de autenticação
      } else {
        onFail('Um erro indefinido ocorreu.');
      }
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
    required Function(String) onFail,
    required Function onSuccess,
    required BuildContext context, // Adicione o contexto aqui
  }) async {
    try {
      loading = true;
      final UserCredential result = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      await _loadCurrentUser(firebaseUser: result.user);

      onSuccess(); // Se a autenticação for bem-sucedida

      // Exibe o SnackBar para informar que o login foi bem-sucedido
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login realizado com sucesso!'))
      );

      // Redireciona para a tela Home após um curto delay
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, '/home'); // Navega para a tela Home
      });
    } catch (e) {
      if (e is FirebaseAuthException) {
        final errorMessage = getErrorString(e.code);
        onFail(errorMessage);
      } else {
        onFail('Um erro indefinido ocorreu.');
      }
    } finally {
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
    } finally {
      loading = false; // Resetar o carregamento no final
    }
  }


  void signOut() async {
    await auth.signOut();
    await GoogleSignIn().signOut();
    firebaseUser = null;
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
      final DocumentSnapshot docUser = await firestore.collection('users').doc(firebaseUser.uid).get();

      if (docUser.exists) {
        user = Users.fromDocument(docUser);
      } else {
        // Se o usuário não existe, cria um novo documento
        user = Users(
          id: firebaseUser.uid,
          email: firebaseUser.email,
          name: firebaseUser.displayName,
        );
        await user!.saveData();
      }

      final docAdmin = await firestore.collection('admins').doc(user!.id).get();
      if (docAdmin.exists) {
        user!.admin = true;
      }

      notifyListeners();
    }
  }

  bool get adminEnabled => user != null && user!.admin;
}
