import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
class geminiAI {

  void RecommendRecipeModel()async {
    await dotenv.load();
    final key = dotenv.get("GEMINI_API_KEY");
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: key);
  }

  void getRecipePrompt(){

  }

  
}