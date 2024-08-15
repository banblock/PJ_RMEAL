// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:beautiful_soup_dart/beautiful_soup.dart';
// import 'dart:convert';



// class CrawlRecipePageService {
//   String recipepageData = "";
//
//   Future<String> crawlPage(String sourceUrl) async {
//       // URL 설정
//       final uri = Uri.parse(sourceUrl);
//       String prettyJson;
//       // HTTP GET 요청 보내기
//       final response = await http.get(uri);
//
//       // 응답 상태 코드 출력
//       print('Response status: ${response.statusCode}');
//
//       // 응답 상태 코드가 200(OK)인지 확인
//       if (response.statusCode == 200) {
//         // HTML 파싱
//         final soup = BeautifulSoup(response.body);
//
//         // <script type="application/ld+json"> 태그 찾기
//         final scriptTag = soup.find(
//             'script', attrs: {'type': 'application/ld+json'});
//         String jsonData = 'No JSON data found';
//         if (scriptTag != null) {
//           jsonData = scriptTag.text;
//         }
//
//         // JSON 데이터 파싱
//         var data;
//         try {
//           data = json.decode(jsonData);
//
//           // 필요한 부분만 추출
//           var extractedData = {
//             'name': data['name'],
//             'recipeIngredient': data['recipeIngredient'],
//             'recipeInstructions': data['recipeInstructions'].map((
//                 instruction) => instruction['text']).toList(),
//           };
//
//           // 아름답게 JSON 문자열로 변환 최종 JSON 결과물
//           prettyJson = JsonEncoder.withIndent('  ').convert(extractedData);
//
//         } catch (e) {
//           print('Error: $e');
//         }
//         return prettyJson;
//       }
//
//     }
//
//     String getPageData(){
//
//     }
//
//     void saveToFile(){
//
//     }
//     String saveToJSON(){
//
//     }
// }