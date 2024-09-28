import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/helpers/validators.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/screens/signup/signup_screen.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordlcontroller = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 4, 125, 141),
        title: const Text(
          'Entrar',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/signup');
            },
            child: Text(
              'Criar conta',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: Consumer<UserManager>(
              builder: (context, userManager, child) {
                // Retorna o ListView explicitamente
                if(userManager.loadingFace){
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                    ),
                  );
                }
                return ListView(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  children: [
                    TextFormField(
                      controller: emailcontroller,
                      enabled: !userManager.loading,
                      decoration: const InputDecoration(
                        labelText: ' E-mail',
                        labelStyle: const TextStyle(
                          color:
                              Color.fromARGB(255, 4, 125, 141), // Cor do label
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(
                                  255, 4, 125, 141)), // Cor padrão da borda
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 4, 125,
                                  141)), // Cor da borda quando não focado
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 4, 125,
                                  141)), // Cor da borda quando focado
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red), // Cor da borda com erro
                        ),
                        focusedErrorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  Colors.red), // Cor da borda com erro e focado
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      validator: (email) {
                        if (!emailValid(email!)) {
                          return 'E-mail inválido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: passwordlcontroller,
                      enabled: !userManager.loading,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        labelStyle: const TextStyle(
                          color:
                              Color.fromARGB(255, 4, 125, 141), // Cor do label
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(
                                  255, 4, 125, 141)), // Cor padrão da borda
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 4, 125,
                                  141)), // Cor da borda quando não focado
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 4, 125,
                                  141)), // Cor da borda quando focado
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.red), // Cor da borda com erro
                        ),
                        focusedErrorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  Colors.red), // Cor da borda com erro e focado
                        ),
                      ),
                      style: const TextStyle(
                        color: Color.fromARGB(
                            255, 4, 125, 141), // Cor do texto digitado
                      ),
                      autocorrect: false,
                      obscureText: true,
                      validator: (password) {
                        if (password!.isEmpty || password.length < 6) {
                          return 'Senha inválida';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    child!, // O child é passado corretamente aqui
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      onPressed: userManager.loading
                          ? null
                          : () {
                              if (formKey.currentState!.validate()) {
                                context.read<UserManager>().signIn(
                                      email: emailcontroller.text.trim(),
                                      password: passwordlcontroller.text,
                                      onFail: (errorMessage) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Falha ao entrar: $errorMessage'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      },
                                      onSuccess: () {
                                        // Faz o pop na tela de login e retorna para a tela anterior
                                        Navigator.of(context).pop();
                                      },
                                      context:
                                          context, // Certifique-se de passar o context aqui
                                    );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        disabledBackgroundColor:
                            Theme.of(context).primaryColor.withAlpha(100),
                      ),
                      child: userManager.loading
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            )
                          : Text(
                              'Entrar',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                              userManager.signInWithGoogle(
                                onSuccess: () {
                                  // Você pode realizar alguma ação adicional aqui se precisar
                                },
                                onFail: (errorMessage) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Falha ao entrar com Google: $errorMessage'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                },
                                context: context, // Passa o contexto aqui
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        disabledBackgroundColor:
                            Theme.of(context).primaryColor.withAlpha(100),
                      ),
                      child:Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.g_mobiledata,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Entra com Google',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                    ),
                  ],
                );
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Esqueci minha senha',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
