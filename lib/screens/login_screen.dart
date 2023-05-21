import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pokemon/screens/pokemon_screen.dart';
import 'package:pokemon/screens/cadastro_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 32,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _email,
                decoration: const InputDecoration(
                  label: Text('Email'),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _password,
                obscureText: true,
                decoration: const InputDecoration(
                  label: Text('Senha'),
                ),
              ),
              SizedBox(height: 20),
              Material(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(16),
                elevation: 4,
                child: InkWell(
                  child: ListTile(
                    title: Text(
                      'Login',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () async {
                      try {
                        final credential = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: _email.text, password: _password.text);
                        final user = credential.user;
                        Navigator.pushReplacementNamed(
                            context, PokemonScreen.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Eu escolho você ${user?.displayName ?? user?.email ?? 'Pokemon'}! Login feito com sucesso!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          print('No user found for that email.');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Usuário não encontrado.'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        } else if (e.code == 'wrong-password') {
                          print('Wrong password provided for that user.');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Sua senha está errada.'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 30),
              Material(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(16),
                elevation: 4,
                child: InkWell(
                  child: ListTile(
                    title: Text(
                      'Cadastre-se',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        CadastroScreen.id,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
