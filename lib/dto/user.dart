import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String userId;

  @HiveField(1)
  List<String> excludedIngredients;

  @HiveField(2)
  String healthCondition;

  User({required this.userId, required this.excludedIngredients, required this.healthCondition});
}
