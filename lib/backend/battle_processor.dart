import 'package:pokerogue_with_random/backend/datastructures/pokemon.dart';

class BattleProcessor {
  List<BattleTeam> teams = [];

  BattleProcessor();

  void addTeam(String teamName){
    BattleTeam newTeam = BattleTeam(
      name: teamName,
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

  void startBattle(){

  }
}


class BattleTeam{
  String name;
  List<Pokemon> pokemon;

  BattleTeam({
    required this.name,
    this.pokemon = const []
  });
}