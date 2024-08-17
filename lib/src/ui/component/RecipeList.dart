import 'package:flutter/material.dart';
import 'package:pj_rmeal/src/ui/body/RecipeBody.dart';
import 'package:pj_rmeal/src/ui/component/RecipeProvider.dart';
import 'package:provider/provider.dart';

class RecipeList extends StatefulWidget {
  @override
  _RecipeListStat createState() => _RecipeListStat();
}

class _RecipeListStat extends State<RecipeList> {
  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);
    final recipes = recipeProvider.recipes;

    return Scaffold(
      backgroundColor: Color(0xFFFCEEE4), // 배경색 설정
      body: ListView.builder(
        padding: const EdgeInsets.all(8),  // 리스트의 padding 설정
        itemCount: recipes.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeBody(recipes[index]),
                    ),
                  );
                },
                child: Container(
                  height: 80,  // 각 박스의 높이 설정
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5), // 좌우 및 상하 마진 설정
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(75),  // 타원형 모서리 설정
                    // border: Border.all(
                    //   color: Color(0xFFE5741F),  // 테두리 색상
                    //   width: 5.0,  // 테두리 두께
                    // ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFE5741F).withOpacity(0.3), // 그림자 색상
                        offset: Offset(2, 3), // 그림자의 위치 (x: 2, y: 3)
                        blurRadius: 1, // 그림자의 흐림 정도
                        spreadRadius: 1, // 그림자의 퍼짐 정도
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      recipes[index]["title"],  // 레시피 제목 표시
                      style: TextStyle(
                        fontSize: 22,  // 글씨 크기 22pt
                        fontWeight: FontWeight.w800, // 글씨 두께 설정
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
    );
  }
}
