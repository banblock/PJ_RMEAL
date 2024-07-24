import 'package:google_generative_ai/google_generative_ai.dart';
class Prompt{
  var prompt ='';
  String inputPrompt(){
    return prompt;
  }

}

class ChatPrompt extends Prompt{
  ChatPrompt(){
    prompt = "jason형식으로 요리title, ingrediant, summary이 정리된 data 들을 입력받는다.\n사용자 입력을 받는다.\n사용자 입력을 바탕으로 data를 선정하여 title을 배열[]안에 담아 출력한다.\n복수의 data가 적합한 경우 해당하는 data를 모두 출력한다.\ndata:";
  }

  void addRecipeData(List<Map> data){
    prompt = "$prompt\n$data";
  }
  void addUserComment(String comment){
    prompt = "$prompt\n\nuser: $comment";
  }

  String getPrompt(){
    return prompt;
  }
}

class RecipeSummaryPrompt extends Prompt{
  RecipeSummaryPrompt(){
    prompt = "글에서 레시피를 추출한다.\n추출한 레시피를 Jason형식으로 출력한다.\nJason 데이터는 title(요리명), instruction(레시피), ingrediant(재료), summary(간단한 요리소개)의 4가지 이다.\n";
  }

  void addRecipe(String recipe){
    prompt = "$prompt\n$recipe";
  }
}