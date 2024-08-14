import 'package:hive/hive.dart';

part 'Userdata.g.dart';

@HiveType(typeId: 0)
class UserData extends HiveObject {
  @HiveField(0)
  late List<String> ignoreIngredient;

  @HiveField(1)
  late List<int> bookmarkId;

  UserData({required this.ignoreIngredient, required this.bookmarkId});
}