// ignore_for_file: constant_identifier_names

import 'package:logger/logger.dart';
import 'package:pokerogue_with_random/backend/datastructures/action.dart';
import 'package:pokerogue_with_random/backend/datastructures/poke_move.dart';
import 'package:pokerogue_with_random/backend/datastructures/pokemon.dart';

enum BattlePhase{
  SETUP,
  PICK,
  PASSIVE,
  EXECUTION
}

class BattleProcessor {
  Logger _logger = Logger();

  List<BattleTeam> teams = [];
  List<Action> actionStack = [];

  BattlePhase phase = BattlePhase.SETUP;

  BattleProcessor();

  void addTeam(String teamName){
    BattleTeam newTeam = BattleTeam(
      name: teamName,
      pokemon: []
    );
    teams.add(
      newTeam
    );
  }

  void addPokemonToTeam(String teamName, Pokemon pokemon){
    BattleTeam? targetTeam = teams.where((team) => team.name == teamName).firstOrNull;
    if (targetTeam == null){
      return;
    }  
    targetTeam.pokemon.add(pokemon);
  }

  bool evaluateNextAction(){
    Action nextAction = actionStack.first;
    nextAction.executableAction(this, nextAction.context);
    return true;
  }

  bool evaluatePokemonMove(ActionContext context){
    // do the logic of one move doing stuff to another pokemon
    return true;
  }

  bool addPokemonMoveAction(Pokemon pokemon, PokeMove move, Pokemon? target){
    if (phase != BattlePhase.PICK){
      return false;
    }

    Pokemon sourcePokemonInTeam = teams.where(
      (team) => team.pokemon.where(
        (pokemonInTeam) => pokemonInTeam.universalId == pokemon.universalId
      ).isNotEmpty
    ).first.pokemon.where(
        (pokemonInTeam) => pokemonInTeam.universalId == pokemon.universalId
    ).first;

    Pokemon? targetPokemonInTeam;

    if (target != null){
      targetPokemonInTeam = teams.where(
        (team) => team.pokemon.where(
          (pokemonInTeam) => pokemonInTeam.universalId == target.universalId
        ).isNotEmpty
      ).first.pokemon.where(
          (pokemonInTeam) => pokemonInTeam.universalId == target.universalId
      ).first;
    }

    if (sourcePokemonInTeam.moves?.any((move) => move.id == move.id) ?? false){
      ActionContext context = ActionContext(
        type: ActionType.MOVE,
        pokemon: sourcePokemonInTeam,
        move: move,
        target: targetPokemonInTeam,
      );
      Action action = Action.fromContext(context);
      _addAction(action);
      return true;
    }
    return false;
  }

  void _addAction(Action newAction){
    actionStack.add(newAction);
  }

  void startBattle(){
    // reset all battle variables
    actionStack = [];
    phase = BattlePhase.PICK;
  }

  bool progressBattlePhase(){
    switch (phase){
      case BattlePhase.SETUP:
        return _progressSetupPhase();
      case BattlePhase.PICK:
        return _progressPickPhase();
      case BattlePhase.PASSIVE:
        return _progressPassivePhase();
      case BattlePhase.EXECUTION:
        return _progressExecutionPhase();
    }
  }

  bool _progressSetupPhase(){
    try{
      phase = BattlePhase.PICK;
      return true;
    }catch(e){
      _logger.e(e);
      return false;
    }
  }

  bool _progressPickPhase(){
    try{
      phase = BattlePhase.PASSIVE;
      return true;
    }catch(e){
      _logger.e(e);
      return false;
    }
  }

  bool _progressPassivePhase(){
    try{
      phase = BattlePhase.EXECUTION;
      return true;
    }catch(e){
      _logger.e(e);
      return false;
    }
  }

  bool _progressExecutionPhase(){
    try{
      phase = BattlePhase.PICK;
      return true;
    }catch(e){
      _logger.e(e);
      return false;
    }
  }
}


class BattleTeam{
  String name;
  List<Pokemon> pokemon = [];

  BattleTeam({
    required this.name,
    required this.pokemon,
  });
}