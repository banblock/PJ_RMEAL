import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'dart:convert';

class CrawlSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CrawlSamplePage(),
    );
  }
}

class CrawlSamplePage extends StatefulWidget {
  @override
  _CrawlSamplePageState createState() => _CrawlSamplePageState();
}

class _CrawlSamplePageState extends State<CrawlSamplePage> {
  String _content = "Fetching data...";
  TextEditingController _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void fetchSample(String url) async {
    try {
      // URL 설정
      final uri = Uri.parse(url);

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
        String jsonData = 'No JSON data found';
        if (scriptTag != null) {
          jsonData = scriptTag.text;
        }

        // JSON 데이터 파싱
        var data;
        try {
          data = json.decode(jsonData);

          // 필요한 부분만 추출
          var extractedData = {
            'name': data['name'],
            'recipeIngredient': data['recipeIngredient'],
            'recipeInstructions': data['recipeInstructions'].map((instruction) => instruction['text']).toList(),
          };

          // 아름답게 JSON 문자열로 변환 최종 JSON 결과물
          String prettyJson = JsonEncoder.withIndent('  ').convert(extractedData);

          setState(() {
            _content = prettyJson;
          });
        } catch (e) {
          setState(() {
            _content = 'Error parsing JSON: $e';
          });
        }
      } else {
        setState(() {
          _content = 'Failed to load page: ${response.statusCode}';
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _content = 'An error occurred: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'Enter URL',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                fetchSample(_urlController.text);
              },
              child: Text('Fetch Data'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_content),
              ),
            ),
          ],
        ),
      ),
    );
  }
}