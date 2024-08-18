import 'package:hive/hive.dart';

part 'recipe.g.dart';

@HiveType(typeId: 1)
class Recipe extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String instruction;

  @HiveField(3)
  List<String> ingredients;

  @HiveField(4)
  String image;

  Recipe({
    required this.id,
    required this.title,
    required this.instruction,
    required this.ingredients,
    required this.image,
  });

  //json으로 만드는 코드인데, hive는 알아서 저장해서 딱히 필요는 없음
  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
    id: json['id'],
    title: json['title'],
    instruction: json['instruction'],
    ingredients: List<String>.from(json['ingredients']),
    image: json['image'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'instruction': instruction,
    'ingredients': ingredients,
    'image': image,
  };
}
