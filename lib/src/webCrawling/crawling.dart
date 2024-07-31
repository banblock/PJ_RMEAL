import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';



class CrawlRecipePageService {
  String recipepageData = "";

  Future<String?> crawlPage(String sourceUrl) async {
    // URL 설정
    final uri = Uri.parse(sourceUrl);
    // HTTP GET 요청 보내기
    final response = await http.get(uri);

    // 응답 상태 코드 출력
    print('Response status: ${response.statusCode}');

    // 응답 상태 코드가 200(OK)인지 확인
    if (response.statusCode == 200) {
      // HTML 파싱
      final soup = BeautifulSoup(response.body);

      // <script type="application/ld+json"> 태그 찾기
      final scriptTag = soup.find('script', attrs: {'type': 'application/ld+json'});
      if (scriptTag != null) {
        recipepageData = scriptTag.text;
        String jsonFormattedData = saveToJSON(recipepageData);
        saveToFile(jsonFormattedData);
        return jsonFormattedData;
      } else {
        print('No JSON data found');
      }
    } else {
      print('Failed to fetch data');
    }
    return null;
  }

    String getPageData(){
        return recipepageData;
    }

  void saveToFile(String data) {
    getApplicationDocumentsDirectory().then((directory) {
      final file = File('${directory.path}/recipe_data.json');
      file.writeAsStringSync(data);
      print('Data saved to ${file.path}');
    });
  }

    String saveToJSON(String data){
     var jsonData = json.decode(data);
     var extractedData = {
       'name': jsonData['name'],
       'recipeIngredient': jsonData['recipeIngredient'],
       'recipeInstructions': jsonData['recipeInstructions'].map((
           instruction) => instruction['text']).toList(),
     };

      return JsonEncoder.withIndent('  ').convert(extractedData);
    }
}