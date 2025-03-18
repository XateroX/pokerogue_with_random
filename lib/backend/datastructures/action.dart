
import 'package:pokerogue_with_random/backend/battle_processor.dart';
import 'package:pokerogue_with_random/backend/datastructures/poke_move.dart';
import 'package:pokerogue_with_random/backend/datastructures/pokemon.dart';

enum ActionType {
  MOVE,
}

class ActionContext {
  ActionType type;
  Pokemon? pokemon;
  PokeMove? move;
  Pokemon? target;

  ActionContext({
    required this.type,
    this.pokemon,
    this.move,
    this.target
  });
}

class Action {
  ActionContext context;
  ActionType type;
  bool Function(BattleProcessor processor, ActionContext context) executableAction = (processor, context) {return false;};

  Action({
    required this.context,
    required this.type,
  });

  static bool Function(
    BattleProcessor processor, 
    ActionContext context
  ) _createMoveExecutableAction(ActionContext context){
    if (
      context.type != ActionType.MOVE || 
      context.move == null || 
      context.pokemon == null
    ) {
      return (processor, context){return false;};
    }

    executable(BattleProcessor processor, ActionContext context) { 
      processor.evaluatePokemonMove(context);
      return true;
    }  
    return executable;
  }

  factory Action.fromContext(ActionContext context){
    Action? action;

    switch (context.type) {
      case ActionType.MOVE:
        action = Action(
          context: context,
          type: ActionType.MOVE
        );
        action.executableAction = _createMoveExecutableAction(context);
        break;
      default:
    }

    if (action == null) {
      throw Exception("Action with type ${context.type} couldn't be created. Action: $action");
    }

    return action;
  }
}