//import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pj_rmeal/src/ProcessControl.dart';
import 'package:pj_rmeal/src/ai/geminiAPI.dart';
import 'package:pj_rmeal/src/ui/body/BookMarkBody.dart';
import 'package:pj_rmeal/src/ui/body/SerchBody.dart';
import 'package:pj_rmeal/src/ui/body/SettingBody.dart';
import 'package:pj_rmeal/src/ui/body/MainBody.dart';
import 'package:pj_rmeal/src/ui/component/RecipeProvider.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();  // 1번코드
  await dotenv.load(fileName: ".env");
  Box box = await Hive.openBox("userBox");
  print(box.values);
  if(!box.containsKey("ignoreIngredient")){
    print("suiiiiii");
    box.put("ignoreIngredient", []);
  }
  if(!box.containsKey("bookmark")){
    print("suiiiiii");
    box.put("bookmark", []);
  }
  final ProcessController process_controller = ProcessController();
  final List<Map<String, dynamic>> recipes = await process_controller.csv_processer.loadCSV();
  runApp(MyApp(process_controller: process_controller, recipes: recipes));
}

class MyApp extends StatelessWidget {
  final ProcessController process_controller;
  final List<Map<String, dynamic>> recipes;
  const MyApp({Key? key, required this.process_controller, required this.recipes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RecipeProvider(),
      child: MaterialApp(
        home: MyHomePage(process_controller: process_controller, recipes: recipes),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final ProcessController _process_controller;
  final List<Map<String, dynamic>> _recipes;
  const MyHomePage({Key? key, required ProcessController process_controller, required List<Map<String, dynamic>> recipes}) : _recipes = recipes, _process_controller = process_controller, super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage>{
  late final Box user_box;
  late final SerchBody serch_body;
  late final SettingBody setting_body;
  late final BookMarkBody bookmark_body;
  //late ProcessController process_controller;
  late final String key;
  GeminiAI ai = GeminiAI();
  int _selectedIndex = 0;


  void initState() {
    super.initState();
    key = dotenv.get("GEMINI_API_KEY");
    serch_body = SerchBody(callSearchButton);
    setting_body = SettingBody();
    bookmark_body = BookMarkBody(widget._recipes);
    user_box = Hive.box("userBox");
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

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Center(child:Image.asset(
            'cookttake_top_logo.png',
            width: 70,
            height: 70,
            fit: BoxFit.cover
        )),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              // 앱 종료
              SystemNavigator.pop();
            },
          ),
        ],
      ),
      body: _getSelectedPage(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.deepOrange,),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark, color: Colors.deepOrange),
            label: 'Bookmark',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Colors.deepOrange),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Future<List<Map<String,dynamic>>> callSearchButton(String user_comment) async{
    List<Map<String,dynamic>> titles_data = await widget._process_controller.responeAIcommentforMap(user_comment, key);
    return titles_data;
  }


}