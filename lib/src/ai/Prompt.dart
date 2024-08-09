import 'package:google_generative_ai/google_generative_ai.dart';
class Prompt{
  String prompt ='';
  late String base_prompt;
  String inputPrompt(){
    return "$base_prompt\n$prompt";
  }

}

class ChatPrompt extends Prompt{
  ChatPrompt(){
    base_prompt = "jason형식으로 요리 id, title, ingrediant, instruction, introduction이 정리된 data 들을 입력받는다.\n사용자 입력을 받는다.\n사용자 입력을 바탕으로 data를 선정하여 id를 배열[]로 출력한다.\n복수의 data가 적합한 경우 해당하는 data를 모두 출력한다.\n출력 id간 구분은 ','로 한다.\ndata:";
  }

  void addRecipeData(List<Map<String, dynamic>> data){
    prompt = "\n$data";
  }
  void addUserComment(String comment){
    prompt = "$prompt\n\nuser: $comment";
  }
}
