import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiAI {

  void RecommendRecipeModel(final key)async {
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: key);
  }

  void SummarizeRecipeModel(final key) async{
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: key);
  }


}