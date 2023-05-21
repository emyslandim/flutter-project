import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pokemon/screens/login_screen.dart';
import 'package:pokemon/screens/pokemon_screen.dart';

class CadastroScreen extends StatefulWidget {
  static const String id = 'cadastro_screen';
  const CadastroScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {

  final _cadastro_email = TextEditingController();
  final _cadastro_password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Cadastro',
                style: TextStyle(
                  fontSize: 32,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _cadastro_email,
                decoration: const InputDecoration(
                  label: Text('Email'),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _cadastro_password,
                obscureText: true,
                decoration: const InputDecoration(
                  label: Text('Senha'),
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
                      'Cadastrar',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () async {
                      try {
                        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                          email: _cadastro_email.text,
                          password: _cadastro_password.text,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cadastro feito com sucesso. Eu escolho você!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pushNamed(
                          context,
                          PokemonScreen.id,
                        );
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print('The password provided is too weak.');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('A senha é muito fraca, tente outra.'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        } else if (e.code == 'email-already-in-use') {
                          print('The account already exists for that email.');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('A Conta já existe para este e-mail.'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      } catch (e) {
                        print(e);
                      }
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
