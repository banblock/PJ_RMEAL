//import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pj_rmeal/src/ai/geminiAPI.dart';

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


class MyHomePage extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  String displayText = "";
  GeminiAI ai = GeminiAI();
  void _updateText() {
    String key = dotenv.get("GEMINI_API_KEY");
    ai.callChatMessage(controller.text);
    ai.RecommendRecipeModel(key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Input Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter some text',
              )
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _updateText,
              child: Text('Submit'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}