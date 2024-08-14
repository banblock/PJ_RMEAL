import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
class CsvControl {

  Future<List<Map<String, dynamic>>> loadCSV() async {
    // CSV 파일 읽기
    final csvString = await rootBundle.loadString('assets/all_recipes.csv');

    // CSV 데이터 파싱
    List<List<dynamic>> csvTable = CsvToListConverter().convert(csvString);

    // 첫 번째 행을 헤더로 사용
    List<String> headers = csvTable[0].cast<String>();

    // CSV 데이터 변환
    List<Map<String, dynamic>> csvData = csvTable.sublist(1).map((row) {
      Map<String, dynamic> rowData = {};
      for (int i = 0; i < headers.length; i++) {
        var value = row[i];
        if (value is String) {
          // JSON 형식의 리스트를 파싱
          try {
            rowData[headers[i]] = jsonDecode(value);
          } catch (e) {
            rowData[headers[i]] = value;
          }
        } else {
          rowData[headers[i]] = value;
        }
      }
      return rowData;
    }).toList();

    return csvData;
  }

  Future<List<Map<String, dynamic>>> filterDataByIds(List<int> ids) async {
    List<Map<String, dynamic>> data = await loadCSV();
    return data.where((row) => ids.contains(int.parse(row['id'].toString()))).toList();
  }

}