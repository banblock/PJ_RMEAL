import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';

void main() async {
  // CSV 파일 경로
  final String csvFilePath = 'path/to/your/csvfile.csv';

  // CSV 파일 읽기
  final input = File(csvFilePath).openRead();
  final fields = await input
      .transform(utf8.decoder)
      .transform(CsvToListConverter())
      .toList();

  // 첫 번째 행은 헤더로 간주
  final header = fields[0];

  // 나머지 행은 데이터로 간주하여 JSON 형식으로 변환
  List<Map<String, dynamic>> jsonList = [];
  for (int i = 1; i < fields.length; i++) {
    Map<String, dynamic> jsonData = {};
    for (int j = 0; j < header.length; j++) {
      if (header[j] == 'hobbies' && fields[i][j] is String) {
        // 'hobbies' 필드를 콤마로 구분하여 리스트로 변환
        jsonData[header[j]] = (fields[i][j] as String).split(',').map((e) => e.trim()).toList();
      } else {
        jsonData[header[j]] = fields[i][j];
      }
    }
    jsonList.add(jsonData);
  }

  // 변환된 JSON 데이터 출력
  for (var data in jsonList) {
    print(jsonEncode(data));
  }
}