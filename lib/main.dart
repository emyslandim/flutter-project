import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pokemon/screens/cadastro_screen.dart';
import 'package:pokemon/screens/login_screen.dart';
import 'package:pokemon/screens/pokemon_screen.dart';
import 'package:pokemon/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  runApp(const MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Splash(),
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        CadastroScreen.id: (context) => const CadastroScreen(),
        PokemonScreen.id: (context) => PokemonScreen()
      }
    );
  }
}
