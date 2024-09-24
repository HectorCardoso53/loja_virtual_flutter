import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/helpers/validators.dart';
import 'package:loja_virtual/main.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/models/users.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final Users user = Users();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 4, 125, 141),
        title: const Text(
          'Criar Conta',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Form(
            key: formKey,
            child: Consumer<UserManager>(
              builder: (context, userManager, child) {
                return ListView(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        enabled: !userManager.loading,
                        labelText: 'NomeCompleto',
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
                      keyboardType: TextInputType.name,
                      validator: (name) {
                        if (name!.isEmpty)
                          return 'Campo Obrigatório';
                        else if (name.trim().split(' ').length <= 1)
                          return 'Preencha seu nome Completo';
                        return null;
                      },
                      onSaved: (name) => user.name = name!,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        enabled: !userManager.loading,
                        labelText: 'E-mail',
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
                      keyboardType: TextInputType.emailAddress,
                      validator: (email) {
                        if (email!.isEmpty) {
                          return 'Campo Obrigatório';
                        } else if (!emailValid(email)) return 'E-mail inválido';
                        return null;
                      },
                      onSaved: (email) => user.email = email!,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        enabled: !userManager.loading,
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
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      validator: (pass) {
                        if (pass!.isEmpty)
                          return 'Campo obrigatório';
                        else if (pass.length < 6) return ' Senha muito Curta';
                        return null;
                      },
                      onSaved: (pass) => user.password = pass!,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        enabled: !userManager.loading,
                        labelText: 'Repita a Senha',
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
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      validator: (pass) {
                        if (pass!.isEmpty)
                          return 'Campo obrigatório';
                        else if (pass.length < 6) return ' Senha muito Curta';
                        return null;
                      },
                      onSaved: (pass) => user.confirmPassword = pass!,
                    ),
                    const SizedBox(
                      height: 26,
                    ),
                    ElevatedButton(
                      onPressed: userManager.loading
                          ? null
                          : () {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();

                                if (user.password != user.confirmPassword) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Senhas não coincidem!!'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }
                                userManager.signUp(
                                    user: user,
                                    onFail: (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('Falha ao Cadastrar: $e'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    },
                                    onSuccess: () {
                                      Navigator.of(context).pop();
                                    });
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        disabledBackgroundColor:
                            Theme.of(context).primaryColor.withAlpha(100),
                      ),
                      child: userManager.loading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(
                                Colors.white,
                              ),
                            )
                          : const Text(
                              'Criar Conta',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
