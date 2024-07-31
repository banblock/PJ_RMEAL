// 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'dart:convert';
import 'package:pj_rmeal/src/dto/user.dart';
import 'package:pj_rmeal/src/dto/recipe.dart';
import 'package:pj_rmeal/src/dto/recipes.dart';

class DataControl {
  late Box<User> userBox;
  late Box<Recipe> recipeBox;
  late Box<Recipes> recipesBox;
  final Uuid uuid = Uuid();


  Future<void> resetHive() async {
    await Hive.deleteFromDisk(); // 모든 데이터를 삭제
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path); // 새 데이터베이스 초기화
    print("DSFSDnakhdfjashdkfadgshfadsf");
  }

  Future<void> init() async {
    try {
      await resetHive();
      final directory = await getApplicationDocumentsDirectory();
      Hive.init(directory.path);

      //어뎁터 등록은 메인에서 해줌
      //Hive.registerAdapter(UserAdapter());
      //Hive.registerAdapter(RecipeAdapter());

      userBox = await Hive.openBox<User>('users');
      recipeBox = await Hive.openBox<Recipe>('recipes');
      recipesBox = await Hive.openBox<Recipes>('recipes');

      await recipesBox.clear();
      //만약 남아있는 데이터때문에 default 설정이 안되면 이걸 활성화해서 초기화
      //await _clearAllUsers();

      // 없으면 user세팅 기본값으로
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

  // Recipe 추가하기
  // 추후 json형식의 리스트를 String으로 반환하기에, 이를 Map으로 쪼개서 넣어야 한다.
  // 즉슨 전체 데이터를 받아 직접 매핑하여 추가하도록 하는 추가 함수 필요
  // string으로 받아 split 한 뒤 map하는 것과, 이미 split해서 변환한 json을 받는것도 추가

  //Future<void> addRecipe(String allRecipe){....}
  //Future<void> addRecipe(JSON allRecipe){....}

  Future<void> addRecipe({
    required id,
  }) async {
    try {
      final recipeId = id ?? uuid.v4();

      if (recipesBox.values.any((recipe) => recipe.id == recipeId)) {
        throw Exception('Recipe: id $recipeId already exists');
      }

      final recipe = Recipes(
        id: recipeId,
      );
      await recipesBox.add(recipe);
    } catch (e) {
      print("Error adding recipe: $e");
      rethrow;
    }
  }

  Future<void> updateRecipe(int index, Recipes recipe) async {
    try {
      if (index < 0 || index >= recipesBox.length) {
        throw RangeError('Index out of range: $index');
      }
      await recipesBox.putAt(index, recipe);
    } catch (e) {
      print("Error updating recipe: $e");
      rethrow;
    }
  }

  Future<void> deleteRecipe(int index) async {
    try {
      if (index < 0 || index >= recipesBox.length) {
        throw RangeError('Index out of range: $index');
      }
      await recipesBox.deleteAt(index);
    } catch (e) {
      print("Error deleting recipe: $e");
      rethrow;
    }
  }

  Future<void> deleteRecipeById(String id) async {
    try {
      // id 찾기
      final key = recipesBox.keys.cast<int>().firstWhere(
              (key) => recipesBox.get(key)?.id == id,
          orElse: () => throw Exception('Recipe not found with id: $id')
      );

      // 해당 레시피 인덱스로 삭제
      await recipesBox.delete(key);
    } catch (e) {
      print("Error deleting recipe: $e");
      rethrow;
    }
  }


  List<Recipes> getAllRecipes() {
    try {
      return recipesBox.values.toList();
    } catch (e) {
      print("Error retrieving recipes: $e");
      return [];
    }
  }

  //id 색인은 다수로 존재하지 않음
  Recipes? getRecipeById(String id) {
    try {
      return recipesBox.values.firstWhere((recipe) => recipe.id == id);
    } catch (e) {
      print("Error retrieving recipe by id: $e");
      throw Exception("Recipe not found with id: $id");
    }
  }

//Recipe? getRecipeByTitle(String title){....}
// Recipe? getRecipeByInstruction(String instruction){....}
// Recipe? getRecipeByIngredients(List<String> ingredients){....}
// 이건 걍 다 포함하는 걸로 검색하는 기능도 구현해야 함
//Recipe? searchRecipe(String name){....}

  bool isRecipeIdDuplicate(String id) {
    try {
      return recipesBox.values.any((recipe) => recipe.id == id);
    } catch (e) {
      print("Error checking recipe id duplicate: $e");
      return false;
    }
  }
}

//AI한테 주는 형식 여기에 $표시를 앞에 붙이면 AI는 스트링으로 표시해줌

