import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

//원래 backup하는 부분인데 toJson은 데이터 모델에서 그냥 쓰기로 했음
import 'user.dart';
import 'recipe.dart';

class DataControl {
  late Box<User> userBox;
  late Box<Recipe> recipeBox;
  final Uuid uuid = Uuid();

  Future<void> init() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      Hive.init(directory.path);

      // main에서 호출하기
      // Hive.registerAdapter(UserAdapter());
      // Hive.registerAdapter(RecipeAdapter());

      userBox = await Hive.openBox<User>('users');
      recipeBox = await Hive.openBox<Recipe>('recipes');
    } catch (e) {
      print("Error initializing Hive: $e");
      // 상위 코드 에서 실행시 예외 처리 넘기기
      rethrow;
    }
  }

  Future<void> addUser({
    required List<String> excludedIngredients,
    required String healthCondition,
  }) async {
    try {
      final user = User(
        userId: uuid.v4(), // UUID 생성
        excludedIngredients: excludedIngredients,
        healthCondition: healthCondition,
      );
      await userBox.add(user);
    } catch (e) {
      print("Error adding user: $e");
      rethrow;
    }
  }

  Future<void> updateUser(int index, User user) async {
    try {
      // 인덱스 체크하는 부분, 안맞으면 에러 발생
      if (index < 0 || index >= userBox.length) {
        throw RangeError('Index out of range: $index');
      }
      await userBox.putAt(index, user);
    } catch (e) {
      print("Error updating user: $e");
      rethrow;
    }
  }

  Future<void> deleteUser(int index) async {
    try {
      //인덱스 체크
      if (index < 0 || index >= userBox.length) {
        throw RangeError('Index out of range: $index');
      }
      await userBox.deleteAt(index);
    } catch (e) {
      print("Error deleting user: $e");
      // 위로 넘기기
      rethrow;
    }
  }

  List<User> getAllUsers() {
    try {
      return userBox.values.toList();
    } catch (e) {
      print("Error retrieving users: $e");
      // 에러나면 빈 걸로
      return [];
    }
  }

  Future<void> addRecipe({
    required String title,
    required String instruction,
    required List<String> ingredients,
    required String image,
  }) async {
    try {
      final recipe = Recipe(
        id: uuid.v4(), // UUID 생성
        title: title,
        instruction: instruction,
        ingredients: ingredients,
        image: image,
      );
      await recipeBox.add(recipe);
    } catch (e) {
      print("Error adding recipe: $e");
      // 위로 넘기기
      rethrow;
    }
  }

  Future<void> updateRecipe(int index, Recipe recipe) async {
    try {
      // 인덱스 체크
      if (index < 0 || index >= recipeBox.length) {
        throw RangeError('Index out of range: $index');
      }
      await recipeBox.putAt(index, recipe);
    } catch (e) {
      print("Error updating recipe: $e");
      // 위로 넘기기
      rethrow;
    }
  }

  Future<void> deleteRecipe(int index) async {
    try {
      // 인덱스 확인
      if (index < 0 || index >= recipeBox.length) {
        throw RangeError('Index out of range: $index');
      }
      await recipeBox.deleteAt(index);
    } catch (e) {
      print("Error deleting recipe: $e");
      // 위로 넘기기
      rethrow;
    }
  }

  List<Recipe> getAllRecipes() {
    try {
      return recipeBox.values.toList();
    } catch (e) {
      print("Error retrieving recipes: $e");
      // 여기도 에러나면 빈 리스트로 반환
      return [];
    }
  }
}
