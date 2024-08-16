import 'package:flutter/cupertino.dart';
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: switchBookMarkRecipe,
            child: Icon(
              _bookmark_tag ? Icons.star : Icons.star_border,
              color: _bookmark_tag ? Colors.yellow : Colors.grey,
              size: 50.0,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: out_recipes.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7.5), // 15dp 간격을 위한 수직 패딩
                  child: InkWell(
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RecipeBody(out_recipes[index])),
                      )
                    },
                    child: Container(
                      height: 100, // 각 항목의 높이 설정
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(75), // 알약 모양을 위한 둥근 테두리
                        border: Border.all(
                          color: Colors.deepOrange, // 테두리 색상
                          width: 2.0, // 테두리 두께
                        ),
                      ),
                      child: Center(
                        child: Text(
                          out_recipes[index]["title"], // 레시피 제목 표시
                          style: TextStyle(fontSize: 20), // 텍스트 크기 설정
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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
