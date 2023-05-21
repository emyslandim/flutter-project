import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pokemon/screens/login_screen.dart';
import 'package:pokemon/screens/model/pokemon_model.dart';
import 'package:pokemon/screens/splash_screen.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class PokemonScreen extends StatefulWidget {
  static const String id = 'pokemon_screen';

  PokemonScreen({Key? key}) : super(key: key);

  @override
  _PokemonScreenState createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  List<Pokemon> pokemonList = [];
  bool isLoading = false;
  int offset = 0;
  int totalPokemons = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    HttpOverrides.global = MyHttpOverrides();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchPokemon();
      }
    });
    fetchPokemonCount();
    fetchPokemon();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        child: Text('Sair'),
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Agora vou escolher o Pikachu, tchau. Logout feito com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacementNamed(context, LoginScreen.id);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total de Pokémon: $totalPokemons',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                controller: _scrollController,
                itemCount: pokemonList.length +
                    1, // +1 para o indicador de carregamento
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (_, index) {
                  if (index < pokemonList.length) {
                    final pokemon = pokemonList[index];
                    return Material(
                      elevation: 2,
                      borderRadius: BorderRadius.circular(10),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    pokemon.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Habilidades: ${pokemon.abilities.join(", ")}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Image.network(
                              pokemon.imageUrl,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Exibir indicador de carregamento
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void fetchPokemonCount() async {
    try {
      final uri = Uri.parse('https://pokeapi.co/api/v2/pokemon');
      final response = await get(uri);

      final responseJson = jsonDecode(response.body);
      final totalCount = responseJson['count'];

      setState(() {
        totalPokemons = totalCount;
      });
    } catch (e) {
      print('Erro ao obter a contagem de Pokémon: $e');
    }
  }

  void fetchPokemon() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final uri = Uri.parse('https://pokeapi.co/api/v2/pokemon?offset=$offset&limit=20');
      final response = await get(uri);

      final responseJson = jsonDecode(response.body);
      final List<dynamic> results = responseJson['results'];

      final List<Pokemon> newPokemonList = [];

      for (var result in results) {
        final pokemonUri = Uri.parse(result['url']);
        final pokemonResponse = await get(pokemonUri);
        final pokemonJson = jsonDecode(pokemonResponse.body);
        
        final pokemon = Pokemon.fromMap(pokemonJson);
        newPokemonList.add(pokemon);
      }

      setState(() {
        pokemonList.addAll(newPokemonList);
        offset += 20;
        isLoading = false;
      });
    } catch (e) {
      print('Erro ao obter a lista de Pokémon: $e');
      setState(() {
        isLoading = false;
      });
    }
  }
}

