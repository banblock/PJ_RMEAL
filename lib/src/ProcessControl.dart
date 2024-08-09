import 'package:pj_rmeal/src/ai/geminiAPI.dart';
import 'package:pj_rmeal/src/dto/CsvControl.dart';
import 'package:pj_rmeal/src/dto/data_control.dart';
import 'package:pj_rmeal/src/webCrawling/crawling.dart';
class ProcessController{
  GeminiAI ai_processer = GeminiAI();
  DataControl data_processer = DataControl();
  CsvControl csv_processer = CsvControl();


  Future<List<String>> responeAIcomment(String usercomment, String key) async{
    ai_processer.addTestData();
    ai_processer.callChatMessage(usercomment);
    ai_processer.RecommendRecipeModel(key);
    String? response = ai_processer.responseChatMessage();
    Future<List<Map<String, dynamic>>> response_data = csv_processer.filterDataByIds(parsingStringtoListint(response));
    Future<List<String>> response_title_data = extractTitles(response_data);
    List<String> respone_titles = await response_title_data;
    return respone_titles;
  }

  void getRecipeData(){

  }
  void addRecipeData(){

  }
  void modifyData(){

  }

  void makeUserData(){

  }
  void writeUserData(){

  }
  void readUserData(){

  }

  List<int> parsingStringtoListint(String? string) {
    if (string != null) {
      // 문자열에서 대괄호 제거
      String cleanedInput = string.replaceAll(RegExp(r'[\[\]]'), '');

      // 문자열을 정수 리스트로 변환
      List<int> intList = cleanedInput.split(',').map((s) =>
          int.parse(s.trim())).toList();
      return intList;
    } else {
      return [0];
    }
  }

  Future<List<String>> extractTitles(Future<List<Map<String, dynamic>>> responseData) async {
    // Future를 await하여 데이터를 받아옵니다.
    List<Map<String, dynamic>> data = await responseData;

    // Map에서 title을 추출하여 List<String>으로 변환합니다.
    List<String> titles = data
        .where((map) => map.containsKey('title')) // title 키가 있는지 확인
        .map((map) => map['title'].toString())    // title 값을 문자열로 변환
        .toList();

    return titles;
  }

}