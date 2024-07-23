import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data_page.dart';
import 'user_page.dart'; // Import UserPage
import 'dto/recipe.dart'; // Import Recipe model
import 'dto/user.dart'; // Import User model
import 'dto/data_control.dart'; // Import DataControl

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(RecipeAdapter());
  Hive.registerAdapter(UserAdapter());

  // Open boxes
  await Hive.openBox<Recipe>('recipes');
  await Hive.openBox<User>('users');

  // Initialize DataControl
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
