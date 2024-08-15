import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pj_rmeal/src/ai/Prompt.dart';

class GeminiAI {
  ChatPrompt? chatprompt;
  String? response;

  // final testdata = [
  //   {'title': "달콤짭짤 우삼겹 덮밥",
  //     "ingrediant": [
  //       "우삼겹 250g",
  //       "양파 1/4개",
  //       "설탕 1큰술",
  //       "맛술 1큰술",
  //       "올리고당 1큰술",
  //       "간장 2큰술",
  //       "다진 마늘 1큰술",
  //       "후추 약간",
  //       "밥",
  //       "선택 사항: 고춧가루, 청양고추, 페페론치노, 계란후라이, 달걀 노른자"
  //     ],
  //     "summary": "달콤짭짤한 간장 양념으로 볶아낸 우삼겹을 뜨거운 밥 위에 듬뿍 올려 먹는 덮밥입니다. 간단하게 한 끼 식사를 해결하고 싶을 때 딱 좋은 메뉴입니다. 매콤한 맛을 더하고 싶다면 고춧가루, 청양고추, 페페론치노를 추가해도 좋습니다. 계란후라이나 달걀 노른자를 곁들이면 더욱 풍성하게 즐길 수 있습니다.",
  //   "id": 0},
  //   {"title": "돼지고기 김치찌개",
  //     "ingrediant": [
  //       "돼지고기 (선호하는 부위)",
  //       "김치",
  //       "들기름 2수저",
  //       "된장 1수저",
  //       "설탕 1/2수저",
  //       "물 800ml",
  //       "다진 마늘 1수저",
  //       "후추 2꼬집",
  //       "대파 (어슷썰기)",
  //       "청양고추 (송송썰기)"
  //     ],
  //     "summary": "깊은 맛을 내는 돼지고기 김치찌개 레시피입니다. 들기름과 된장을 볶아 기름진 풍미를 더하고, 돼지고기와 김치를 충분히 볶아 감칠맛을 극대화합니다. 오래 끓일수록 더욱 진하고 깊은 맛을 느낄 수 있습니다.",
  //     "id": 1},
  //   {"title": "중탕 달걀찜 (급식 계란찜)",
  //     "ingrediant": [
  //       "계란 6개",
  //       "물 200ml",
  //       "다시마 2장 (5*5 size)",
  //       "맛술 1큰술",
  //       "새우젓국물 1큰술",
  //       "설탕 2티스푼",
  //       "맛소금 1티스푼",
  //       "참기름 2큰술",
  //       "대파 (다진 것)",
  //       "당근 (다진 것)",
  //       "랩 또는 호일"
  //     ],
  //     "summary": "부드럽고 탱글탱글한 푸딩 같은 식감의 급식 계란찜을 집에서 만들어 보세요. 다시마 육수를 사용하여 깊은 맛을 더하고, 중탕으로 부드러운 식감을 살려냈습니다. 차게 식혀 먹어도 맛있습니다.",
  //     "id": 2}
  // ];

  GeminiAI(){
    chatprompt = ChatPrompt();
  }

  Future<void> RecommendRecipeModel(final key)async {
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: key);
    String text = chatprompt!.inputPrompt();
    final content = [Content.text(text)];
    final response = await model.generateContent(content);
    print(response.text);
    setResponse(response.text);
  }


  void callChatMessage(String text){
    chatprompt?.addUserComment(text);
  }

  void setResponse(String? response){
    this.response = response;
  }

  String? responseChatMessage(){
    return this.response;
  }

  void setData(List<Map<String, dynamic>> data){
    chatprompt?.addRecipeData(data);
  }

  //테스트용 코드
  // void addTestData(){
  //   chatprompt?.addRecipeData(testdata);//테스트용 코드
  // }
}