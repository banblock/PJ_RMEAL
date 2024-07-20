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


}
