import 'package:pokerogue_with_random/backend/data/pokemon_learnset.dart';
import 'package:pokerogue_with_random/backend/datastructures/poke_move.dart';

enum PokeGenMode {
  FULL_RANDOM,
  GAME_COMPLIANT,
  SKELETON,
}

class Pokemon {
  final String name;
  final int id;
  final int hp;
  final int attack;
  final int defense;
  final int specialAttack;
  final int specialDefense;
  final int speed;
  final int height;
  final int weight;
  final String type1;
  final String type2;
  List<PokeMove>? moves;
  PokeGenMode pokeGenMode;

  // initial fields with variable defaults
  int lvl = 1;
  double exp = 0.0;
  
  Pokemon({
    required this.name,
    required this.id,
    required this.hp,
    required this.attack,
    required this.defense,
    required this.specialAttack,
    required this.specialDefense,
    required this.speed,
    required this.height,
    required this.weight,
    required this.type1,
    required this.type2,
    this.moves,
    this.pokeGenMode = PokeGenMode.GAME_COMPLIANT,
    this.lvl = 1,
    this.exp = 0.0,
  }){
   
  }

  factory Pokemon.fromList(
    List<dynamic> attributeList, 
    {
      List<PokeMove>? moveset,
      PokemonLearnset? learnset,
      List<PokeMove>? moves, 
      PokeGenMode pokeGenMode = PokeGenMode.SKELETON,
    }
  ) {
    if (attributeList.length != 12) {
      throw Exception("Invalid pokemon data");
    }

    String name = attributeList[0];
    int id = attributeList[1];
    int hp = attributeList[2];
    int attack = attributeList[3];
    int defense = attributeList[4];
    int specialAttack = attributeList[5];
    int specialDefense = attributeList[6];
    int speed = attributeList[7];
    int height = attributeList[8];
    int weight = attributeList[9];
    String type1 = attributeList[10];
    String type2 = attributeList[11];

    Pokemon pokemon = Pokemon(
      name: name,
      id: id,
      hp: hp,
      attack: attack,
      defense: defense,
      specialAttack: specialAttack,
      specialDefense: specialDefense,
      speed: speed,
      height: height,
      weight: weight,
      type1: type1,
      type2: type2,
      moves: moves,
      pokeGenMode: pokeGenMode ?? PokeGenMode.GAME_COMPLIANT
    );

    if (pokeGenMode == PokeGenMode.SKELETON){
      return pokemon;
    }

    if (
      learnset == null || 
      moveset == null
    ){
      throw Exception("Invalid pokemon data: missing ${learnset == null ? "learnset" : ""}${moveset == null ? "moveset" : learnset == null ? "" : " and learnset"} while pokeGenMode is not PokeGenMode.SKELETON");
    }

    pokemon.populateRequiredFields(
      moveset: moveset,
      learnset: learnset,
      desiredGenMode: pokemon.pokeGenMode
    );

    return pokemon;
  }


  // Poke Gen methods //
  void populateRequiredFields(
    {
      required List<PokeMove> moveset,
      required PokemonLearnset learnset,
      required desiredGenMode,
    }
  ) {
    if (moves == null) {
      switch (desiredGenMode) {
        case PokeGenMode.GAME_COMPLIANT:
          _generateGameCompliant(
            moveset: moveset,
            learnset: learnset
          );
          break;
        case PokeGenMode.FULL_RANDOM:
          _generateFullRandom(
            moveset: moveset,
            learnset: learnset
          );
          break;
        default:
      }
    }
  } 
  
  void _generateGameCompliant(
    {
      required List<PokeMove> moveset,
      required PokemonLearnset learnset
    }
  ) {
    Map<String,List<String>> myLearnset = learnset.learnset[name.toLowerCase()]["learnset"] as Map<String,List<String>>;
    List<String> movesWithinLevelRestriction = myLearnset.keys.where(
      (key) => 
      myLearnset[key]!.where(
        (condition) => 
        condition.contains("L") && int.parse(condition.split("L").last as String) <= lvl
      ).isNotEmpty
    ).toList();
    List<PokeMove?> validMoves = movesWithinLevelRestriction
    .map(
      (levelValidMoveName) => 
      moveset.where((move) => move.name.toLowerCase() == levelValidMoveName.toLowerCase()).firstOrNull
    ).where((move) => move != null).toList();

    // safe due to above where
    moves = validMoves.map((pokeMove)=>pokeMove!).toList();
  }

  void _generateFullRandom(
    {
      required List<PokeMove> moveset,
      required PokemonLearnset learnset
    }
  ) {
    
  }
}
     
