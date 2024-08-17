import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'RecipeBody.dart';

class BookMarkBody extends StatefulWidget {
  final List<Map<String, dynamic>> all_recipes;
  BookMarkBody(this.all_recipes);

  @override
  BookMarkState createState() => BookMarkState();
}

class BookMarkState extends State<BookMarkBody> {
  late Box user_box;
  late List<Map<String, dynamic>> out_recipes;
  late bool _bookmark_tag;

  @override
  void initState() {
    super.initState();
    user_box = Hive.box("userBox");
    out_recipes = widget.all_recipes;
    _bookmark_tag = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCEEE4), // 배경 색상 설정
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: switchBookMarkRecipe,
              child: Icon(
                _bookmark_tag ? Icons.star : Icons.star_border,
                color: Color(0xFFFFC000), // 항상 노란색으로 설정
                size: 50.0,
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: out_recipes.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RecipeBody(out_recipes[index])),
                          );
                        },
                        child: Container(
                          height: 80, // 각 항목의 높이 설정
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5), // 컨테이너 양쪽에 5pt 마진 추가
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(75), // 알약 모양을 위한 둥근 테두리
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5), // 그림자 색상
                                offset: Offset(2, 3), // 그림자의 위치 (x: 4, y: 5)
                                blurRadius: 1, // 그림자의 흐림 정도
                                spreadRadius: 1, // 그림자의 퍼짐 정도
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              out_recipes[index]["title"], // 레시피 제목 표시
                              style: TextStyle(
                                fontSize: 22, // 글씨 크기 20에서 2pt 증가
                                fontWeight: FontWeight.w800,
                                fontFamily: 'NanumSquareNeo', // 글씨체 설정
                                color: Color(0xFFE5741F), // 글씨 색상 설정
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15), // 컨테이너 간의 간격을 15pt로 설정
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void switchBookMarkRecipe() {
    setState(() {
      if (_bookmark_tag) {
        out_recipes = widget.all_recipes;
        _bookmark_tag = !_bookmark_tag;
      } else {
        var ids = user_box.get("bookmark");
        List<Map<String, dynamic>> bookmark_recipes = filterByIds(ids, widget.all_recipes);
        out_recipes = bookmark_recipes;
        _bookmark_tag = !_bookmark_tag;
      }
    });
  }

  List<Map<String, dynamic>> filterByIds(List<dynamic> ids, List<Map<String, dynamic>> data) {
    return data.where((map) => ids.contains(map['id'])).toList();
  }
}
