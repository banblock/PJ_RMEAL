//import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pj_rmeal/src/ProcessControl.dart';
import 'package:pj_rmeal/src/ai/geminiAPI.dart';
import 'package:pj_rmeal/src/ui/body/BookMarkBody.dart';
import 'package:pj_rmeal/src/ui/body/RecipeBody.dart';
import 'package:pj_rmeal/src/ui/body/SerchBody.dart';
import 'package:pj_rmeal/src/ui/body/SettingBody.dart';
import 'package:pj_rmeal/src/ui/body/MainBody.dart';
import 'package:pj_rmeal/src/ui/component/RecipeProvider.dart';
import 'package:provider/provider.dart';

void main() async{
  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();  // 1번코드
  await dotenv.load(fileName: ".env");
  Box box = await Hive.openBox("userBox");
  print(box.values);
  if(!box.containsKey("ignoreIngredient")){
    print("suiiiiii");
    box.put("ignoreIngredient",[]);
  }
  if(!box.containsKey("bookmark")){
    print("suiiiiii");
    box.put("bookmark",[]);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RecipeProvider(),
      child: MaterialApp(
        home: MyHomePage(),
      )
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage>{
  late final Box user_box;
  late final MainBody main_body;
  late final SerchBody serch_body;
  late final SettingBody setting_body;
  late final BookMarkBody bookmark_body;
  late final RecipeBody recipe_body;
  late ProcessController process_controller;
  late final String key;
  GeminiAI ai = GeminiAI();
  int _selectedIndex = 0;


  void initState() {
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Input Example'),
      ),
      body: _getSelectedPage(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmark',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Future<List<String>> callSearchButton(String user_comment) async{
    List<String> titles_data = await process_controller.responeAIcomment(user_comment, key);
    return titles_data;
  }
  @override
  void dispose() {
    user_box.close(); // 박스 닫기
    super.dispose();
  }


}