//import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pj_rmeal/src/ProcessControl.dart';
import 'package:pj_rmeal/src/ai/geminiAPI.dart';
import 'package:pj_rmeal/src/ui/body/BookMarkBody.dart';
import 'package:pj_rmeal/src/ui/body/RecipeBody.dart';
import 'package:pj_rmeal/src/ui/body/SerchBody.dart';
import 'package:pj_rmeal/src/ui/body/SettingBody.dart';
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
  late final MainBody main_body;
  late final SerchBody serch_body;
  late final SettingBody setting_body;
  late final BookMarkBody bookmark_body;
  late final RecipeBody recipe_body;

  late ProcessController process_controller;
  late String key;
  String displayText = "";
  GeminiAI ai = GeminiAI();
  int _selectedIndex = 0;

  void initState(){
    super.initState();
    process_controller = ProcessController();
    key = dotenv.get("GEMINI_API_KEY");
    main_body = MainBody();
    serch_body = SerchBody(callSearchButton);
    setting_body = SettingBody();
    bookmark_body = BookMarkBody();
    recipe_body = RecipeBody();

  }

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

  Future<List<String>> callSearchButton(String user_comment) async{
    Future<List<String>> titles = process_controller.responeAIcomment(user_comment, key);
    List<String> titles_data = await titles;
    return titles_data;
  }

}