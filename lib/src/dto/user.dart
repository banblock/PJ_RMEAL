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

  User({
    required this.userId, 
    required this.excludedIngredients, 
    required this.healthCondition,
  });
  //유효성 검사부분은 그냥 입력 페이지에서 제한하도록 했음 (성능 이슈)
  // {
  // if (userId.length > 20) {
  // throw ArgumentError('User ID cannot be more than 20 characters');
  // }
  // if (healthCondition.length > 100) {
  // throw ArgumentError('Health Condition cannot be more than 100 characters');
  // }
  // }

  // json으로 변환하는 부분
  factory User.fromJson(Map<String, dynamic> json) => User(
    userId: json['userId'],
    excludedIngredients: List<String>.from(json['excludedIngredients']),
    healthCondition: json['healthCondition'],
  );

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'excludedIngredients': excludedIngredients,
    'healthCondition': healthCondition,
  };
}
