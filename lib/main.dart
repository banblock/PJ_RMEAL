//import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';

import 'package:pj_rmeal/src/dto/user.dart';
import 'package:pj_rmeal/src/dto/recipe.dart';
import 'package:pj_rmeal/src/dto/recipes.dart';
import 'package:pj_rmeal/src/dto/dataControl.dart';
import 'package:pj_rmeal/src/ui/data_page.dart';
import 'package:pj_rmeal/src/ui/user_page.dart';


// Future<void> migrateData() async {
//   final directory = await getApplicationDocumentsDirectory();
//   Hive.init(directory.path);
//
//   // 어댑터 등록
//   Hive.registerAdapter(RecipeAdapter());
//
//   // 기존 데이터베이스 열기 (예: 'recipes_v1'라는 이름의 박스 사용)
//   final oldBox = await Hive.openBox<Recipe>('recipes');
//
//   // 새 데이터베이스 열기 (예: 'recipes'라는 이름의 박스 사용)
//   final newBox = await Hive.openBox<Recipe>('recipe');
//
//   // 기존 데이터를 읽어 새로운 데이터 모델로 변환
//   for (var key in oldBox.keys) {
//     final oldRecipe = oldBox.get(key)!;
//
//     // 현재 데이터 모델이 변경되지 않았으므로 단순히 복사
//     final newRecipe = Recipe(id: oldRecipe.id);
//
//     await newBox.put(key, newRecipe);
//   }
//
//   // 기존 데이터 삭제 (선택 사항)
//   await oldBox.deleteFromDisk();
// }

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // await migrateData();

  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  // Register Hive adapters
  Hive.registerAdapter(UserAdapter());
  //Hive.registerAdapter(RecipeAdapter());
  Hive.registerAdapter(RecipesAdapter());
  await Hive.deleteFromDisk();
  final dataControl = DataControl();
  await dataControl.init();

  runApp(MyApp(dataControl: dataControl));
}

class MyApp extends StatelessWidget {
  final DataControl dataControl;

  const MyApp({Key? key, required this.dataControl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.green),
      home: DataPage(dataControl: dataControl),
      routes: {
        '/userPage': (context) => UserPage(dataControl: dataControl),
      },
    );
  }
}
