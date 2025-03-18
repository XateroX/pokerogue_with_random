class PokeMove {
  final String name;
  final int id;
  final double? accuracy;
  final int pp;
  final double? power;
  final int priority;
  final String type;
  final String generation;
  final String shortDescription;
  final String damageClass;

  PokeMove({
    required this.name,
    required this.id,
    this.accuracy,
    required this.pp,
    this.power,
    required this.priority,
    required this.type,
    required this.generation,
    required this.shortDescription,
    required this.damageClass,
  });

  factory PokeMove.fromList(List<dynamic> attributeList) {
    if (attributeList.length != 10) {
      throw Exception("Invalid move data");
    }

    String name = attributeList[0];
    int id = attributeList[1];
    double? accuracy = (attributeList[2] != null && attributeList[2] != "") ? attributeList[2] : null;
    int pp = attributeList[3];
    double? power = (attributeList[4] != null && attributeList[4] != "") ? attributeList[4] : null;
    int priority = attributeList[5];
    String type = attributeList[6];
    String generation = attributeList[7];
    String shortDescription = attributeList[8];
    String damageClass = attributeList[9];

    return PokeMove(
      name: name,
      id: id,
      accuracy: accuracy,
      pp: pp,
      power: power,
      priority: priority,
      type: type,
      generation: generation,
      shortDescription: shortDescription,
      damageClass: damageClass
    );
  }

}