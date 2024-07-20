import 'package:hive/hive.dart';
import 'user.dart';
import 'recipe.dart';

class DataControl {
  final Box<User> userBox = Hive.box<User>('users');
  final Box<Recipe> recipeBox = Hive.box<Recipe>('recipes');

  // User 추가, 삽입, 삭제, 색인
  void addUser(User user) {
    userBox.add(user);
  }

  void updateUser(int index, User user) {
    userBox.putAt(index, user);
  }

  void deleteUser(int index) {
    userBox.deleteAt(index);
  }

  List<User> getAllUsers() {
    return userBox.values.toList();
  }

  // Recipe 추가, 삽입, 삭제, 색인
  void addRecipe(Recipe recipe) {
    recipeBox.add(recipe);
  }

  void updateRecipe(int index, Recipe recipe) {
    recipeBox.putAt(index, recipe);
  }

  void deleteRecipe(int index) {
    recipeBox.deleteAt(index);
  }

  List<Recipe> getAllRecipes() {
    return recipeBox.values.toList();
  }
}
