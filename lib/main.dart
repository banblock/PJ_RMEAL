//import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pj_rmeal/src/ProcessControl.dart';
import 'package:pj_rmeal/src/ai/geminiAPI.dart';
import 'package:pj_rmeal/src/ui/body/BookMarkBody.dart';
import 'package:pj_rmeal/src/ui/body/RecipeBody.dart';
import 'package:pj_rmeal/src/ui/body/SerchBody.dart';
import 'package:pj_rmeal/src/ui/body/SettingBody.dart';
import 'package:pj_rmeal/src/ui/component/RecipeList.dart';
import 'package:pj_rmeal/src/ui/body/MainBody.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();  // 1번코드
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage>{
  MainBody main_body = MainBody();
  SerchBody serch_body = SerchBody();
  SettingBody setting_body = SettingBody();
  BookMarkBody bookmark_body = BookMarkBody();
  RecipeBody recipe_body = RecipeBody();

  ProcessController process_controller = ProcessController();

  TextEditingController controller = TextEditingController();
  String displayText = "";
  GeminiAI ai = GeminiAI();
  int _selectedIndex = 0;


  Widget _getSelectedPage(int index){
    switch (index){
      case 0:
        return serch_body;
      case 1:
        return bookmark_body;
      case 2:
        return setting_body;
      default:
        return serch_body;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Input Example'),
      ),
      body: _getSelectedPage(_selectedIndex),
      bottomNavigationBar: BottomAppBar(),
    );
  }

}