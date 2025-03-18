import 'package:flutter/services.dart';
import 'package:pokerogue_with_random/backend/data/pokemon_learnset.dart';
import 'package:pokerogue_with_random/backend/datastructures/poke_move.dart';
import 'package:logger/logger.dart';
import 'package:csv/csv.dart';
import 'package:pokerogue_with_random/backend/datastructures/pokemon.dart';

class Loader {
  List<PokeMove> _moves = [];
  List<Pokemon> _pokemon = [];
  Logger _logger = Logger();

  Loader(){
    _logger.i("--Loader init()--");
  }

  initialise() async {
    await loadMoves();
    await loadPokemon();
  }

  Future<void> loadMoves() async {
    String data = await rootBundle.loadString('assets/pokemon_moves.csv');
    List<List<dynamic>> moveData = CsvToListConverter().convert(data, fieldDelimiter: ',', textDelimiter: '"', eol: '\n').sublist(1);
    _moves = moveData.map((moveList)=>PokeMove.fromList(moveList)).toList();
  }

  Future<void> loadPokemon() async {
    String data = await rootBundle.loadString('assets/pokemon.csv');
    List<List<dynamic>> pokemonData = CsvToListConverter().convert(data, fieldDelimiter: ',', textDelimiter: '"', eol: '\n').sublist(1);
    _pokemon = pokemonData.map(
      (pokemonFieldList)=>Pokemon.fromList(pokemonFieldList)
    ).toList();
  }

  Pokemon? loadByName(String name){
    Pokemon? returnPokemon = _pokemon.where((pokemon)=>pokemon.name.toLowerCase() == name.toLowerCase()).firstOrNull;
    return returnPokemon;
  }

  
  Pokemon? loadGameCompliantByName(String name,){
    Pokemon? skeletonPokemon = loadByName(name);
    if (skeletonPokemon == null) {
      return null;
    }
    skeletonPokemon.populateRequiredFields(
      moveset: _moves,
      learnset: PokemonLearnset(),
      desiredGenMode: PokeGenMode.GAME_COMPLIANT,
    );
    return skeletonPokemon;
  }
}