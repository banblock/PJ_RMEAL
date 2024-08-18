import 'package:hive/hive.dart';

part 'recipes.g.dart';

@HiveType(typeId: 1)
class Recipes extends HiveObject {
  @HiveField(0)
  String id;

  Recipes({
    required this.id,
  });

  //json으로 만드는 코드인데, hive는 알아서 저장해서 딱히 필요는 없음
  factory Recipes.fromJson(Map<String, dynamic> json) => Recipes(
    id: json['id'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
  };
}