import 'package:logger/logger.dart';
import 'package:pokerogue_with_random/backend/battle_processor.dart';
import 'package:pokerogue_with_random/backend/data/pokemon_learnset.dart';
import 'package:pokerogue_with_random/backend/datastructures/pokemon.dart';
import 'package:pokerogue_with_random/backend/loader.dart';

class GameManager {
  PokemonLearnset learnset = PokemonLearnset();
  Loader _loader = Loader();
  Logger _logger = Logger();

  GameManager(){
    _logger.i("--GameManager init()--");
    initialise();
  }

  initialise() async {
    await _loader.initialise();

    testGameplayLoop();
  }

  testGameplayLoop(){
    _logger.i("--testGameplayLoop--");

    Pokemon? pokemonA = _loader.loadGameCompliantByName("Chimchar"); 
    Pokemon? pokemonB = _loader.loadGameCompliantByName("Piplup");

    if (pokemonA == null || pokemonB == null) {
      throw Exception("Failed to load pokemonA or pokemonB");
    }

    BattleProcessor testBattleProcessor = BattleProcessor();
    testBattleProcessor.addTeam("TeamA");
    testBattleProcessor.addTeam("TeamB");

    testBattleProcessor.addPokemonToTeam("TeamA", pokemonA);
    testBattleProcessor.addPokemonToTeam("TeamB", pokemonB);

    testBattleProcessor.startBattle();

    testBattleProcessor.addPokemonMoveAction(pokemonA, pokemonA.moves![0], pokemonB);
    testBattleProcessor.addPokemonMoveAction(pokemonB, pokemonB.moves![0], pokemonA);

    print("");
  }
}