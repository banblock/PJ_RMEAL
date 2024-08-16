import 'package:hive/hive.dart';

class Prompt{
  String prompt ='';
  late String base_prompt;
  String inputPrompt(){
    return "$base_prompt\n$prompt";
  }

}

class ChatPrompt extends Prompt{
  late final Box user_box;
  ChatPrompt(){
    user_box = Hive.box("userBox");
    base_prompt = '''jason형식으로 요리 id, title, ingrediant, instruction, introduction이 정리된 data 들을 입력받는다.
      \n사용자 입력을 받는다.\n사용자 입력을 바탕으로 data를 선정하여 id를 배열[]로 출력한다.\n사용자의 요구 조건에 맞지 않은 data는 출력에서 제외한다.
      \nignores에 입력된 재료를 ingrediant에 포함한 data는 출력에서 제외한다.\n복수의 data가 적합한 경우 해당하는 data를 모두 출력한다.
      \n출력 id간 구분은 ','로 한다.\n출력 마지막 데이터에는 ','을 붙이지 않는다. 
      \ndata:''';
  }

  void addRecipeData(List<Map<String, dynamic>> data){
    prompt = "\n$data";
  }
  void addUserComment(String comment){
    prompt = "$prompt\n\nuser: $comment";
  }

  void addUserIgnores(){
    var ignores = user_box.get("ignoreIngredient");
    if(!ignores.isEmpty){
      prompt = "$prompt\nignores: $ignores";
    }
  }
}
