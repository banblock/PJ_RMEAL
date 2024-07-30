//import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';

import 'package:pj_rmeal/src/dto/user.dart';
import 'package:pj_rmeal/src/dto/recipe.dart';
import 'package:pj_rmeal/src/dto/data_control.dart';
import 'package:pj_rmeal/src/ui/data_page.dart';
import 'package:pj_rmeal/src/ui/user_page.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  // Register Hive adapters
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(RecipeAdapter());

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
