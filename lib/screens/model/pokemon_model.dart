class Pokemon {
  final String name;
  final List<String> abilities;
  final String imageUrl;

  Pokemon({
    required this.name,
    required this.abilities,
    required this.imageUrl,
  });

  factory Pokemon.fromMap(Map<String, dynamic> map) {
    final abilities = map['abilities'] as List<dynamic>;
    final imageUrl = map['sprites']['front_default'] as String;

    final pokemonAbilities = abilities
        .map((ability) => ability['ability']['name'] as String)
        .toList();

    return Pokemon(
      name: map['name'] as String,
      abilities: pokemonAbilities,
      imageUrl: imageUrl,
    );
  }
}
