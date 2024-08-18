import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pj_rmeal/src/ProcessControl.dart';
import 'package:pj_rmeal/src/ai/geminiAPI.dart';
import 'package:pj_rmeal/src/ui/body/BookMarkBody.dart';
import 'package:pj_rmeal/src/ui/body/SearchBody.dart';
import 'package:pj_rmeal/src/ui/body/SettingBody.dart';
import 'package:pj_rmeal/src/ui/component/RecipeProvider.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  Box box = await Hive.openBox("userBox");

  if (!box.containsKey("ignoreIngredient")) {
    box.put("ignoreIngredient", []);
  }
  if (!box.containsKey("bookmark")) {
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
  final ProcessController process_controller;
  final List<Map<String, dynamic>> recipes;

  const MyHomePage({Key? key, required this.process_controller, required this.recipes}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  late final Box user_box;
  late final SearchBody search_body;
  late final SettingBody setting_body;
  late final BookMarkBody bookmark_body;
  late final String key;
  GeminiAI ai = GeminiAI();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    key = dotenv.get("GEMINI_API_KEY");
    search_body = SearchBody(callSearchButton);
    setting_body = SettingBody();
    bookmark_body = BookMarkBody(widget.recipes);
    user_box = Hive.box("userBox");
  }

  Widget _getSelectedPage(int index) {
    switch (index) {
      case 0:
        return search_body;
      case 1:
        return bookmark_body;
      case 2:
        return setting_body;
      default:
        return search_body;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCEEE4),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight), // AppBar의 높이를 설정합니다.
        child: AppBar(
          backgroundColor: Color(0xFFE5741F),
          title: Text(
            'Cook DDak',
            textAlign: TextAlign.center, // 제목을 가운데 정렬
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w800,
              fontFamily: 'NanumSquareNeo',
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app, color: Colors.white),
              onPressed: () {
                // 앱 종료
                SystemNavigator.pop();
              },
            ),
          ],
          centerTitle: true, // 제목을 중앙 정렬
        ),
      ),
      body: _getSelectedPage(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Color(0xFFE5741F)),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark, color: Color(0xFFE5741F)),
            label: 'Bookmark',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Color(0xFFE5741F)),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Future<List<Map<String, dynamic>>> callSearchButton(String user_comment) async {
    List<Map<String, dynamic>> titles_data = await widget.process_controller.responeAIcommentforMap(user_comment, key);
    return titles_data;
  }
}
