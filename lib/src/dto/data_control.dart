// 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'dart:convert';
import 'package:pj_rmeal/src/dto/user.dart';
import 'package:pj_rmeal/src/dto/recipe.dart';

class DataControl {
  late Box<User> userBox;
  late Box<Recipe> recipeBox;
  final Uuid uuid = Uuid();

  Future<void> init() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      Hive.init(directory.path);

      //Hive.registerAdapter(UserAdapter());
      //Hive.registerAdapter(RecipeAdapter());

      userBox = await Hive.openBox<User>('users');
      recipeBox = await Hive.openBox<Recipe>('recipes');

      // 없으면 user세팅 기본값으로
      //await _clearAllUsers();
      if (userBox.isEmpty) {
        await _initializeDefaultUser();
      }
    } catch (e) {
      print("Error initializing Hive: $e");
      rethrow;
    }
  }

  Future<void> _clearAllUsers() async {
    try {
      await userBox.clear();
      print('All users cleared');
    } catch (e) {
      print("Error clearing all users: $e");
      rethrow;
    }
  }

  Future<void> _initializeDefaultUser() async {
    final defaultUser = User(
      userId: uuid.v4(),
      excludedIngredients: [],
      healthCondition: '',
    );
    await userBox.put('default', defaultUser);
    print('default add');
  }

  User? getUser() {
    try {
      return userBox.get('default');
    } catch (e) {
      print("Error retrieving user: $e");
      return null;
    }
  }

  Future<void> updateUser(User user) async {
    try {
      await userBox.put('default', user);
    } catch (e) {
      print("Error updating user: $e");
      rethrow;
    }
  }

  Future<void> deleteUser() async {
    try {
      await userBox.delete('default');
    } catch (e) {
      print("Error deleting user: $e");
      rethrow;
    }
  }

  // user 처리함수들 싱글톤으로 바꾸며 추가 삭제 코드는 없앰
  // Future<void> addUser({ ... });
  // Future<void> updateUser(int index, User user) { ... }
  // Future<void> deleteUser(int index) { ... }
  // List<User> getAllUsers() { ... }

  // Recipe management methods (unchanged)
  Future<void> addRecipe({
    String? id,
    required String title,
    required String instruction,
    required List<String> ingredients,
    required String image,
  }) async {
    try {
      final recipeId = id ?? uuid.v4();

      if (title.isEmpty || instruction.isEmpty || ingredients.isEmpty) {
        throw Exception('some attribute cannot be empty');
      }

      if (recipeBox.values.any((recipe) => recipe.id == recipeId)) {
        throw Exception('Recipe: id $recipeId already exists');
      }

      final recipe = Recipe(
        id: recipeId,
        title: title,
        instruction: instruction,
        ingredients: ingredients,
        image: image,
      );
      await recipeBox.add(recipe);
    } catch (e) {
      print("Error adding recipe: $e");
      rethrow;
    }
  }

  Future<void> updateRecipe(int index, Recipe recipe) async {
    try {
      if (index < 0 || index >= recipeBox.length) {
        throw RangeError('Index out of range: $index');
      }
      await recipeBox.putAt(index, recipe);
    } catch (e) {
      print("Error updating recipe: $e");
      rethrow;
    }
  }

  Future<void> deleteRecipe(int index) async {
    try {
      if (index < 0 || index >= recipeBox.length) {
        throw RangeError('Index out of range: $index');
      }
      await recipeBox.deleteAt(index);
    } catch (e) {
      print("Error deleting recipe: $e");
      rethrow;
    }
  }

  List<Recipe> getAllRecipes() {
    try {
      return recipeBox.values.toList();
    } catch (e) {
      print("Error retrieving recipes: $e");
      return [];
    }
  }

  Recipe? getRecipeById(String id) {
    try {
      return recipeBox.values.firstWhere((recipe) => recipe.id == id);
    } catch (e) {
      print("Error retrieving recipe by id: $e");
      throw Exception("Recipe not found with id: $id");
    }
  }

  bool isRecipeIdDuplicate(String id) {
    try {
      return recipeBox.values.any((recipe) => recipe.id == id);
    } catch (e) {
      print("Error checking recipe id duplicate: $e");
      return false;
    }
  }
}
