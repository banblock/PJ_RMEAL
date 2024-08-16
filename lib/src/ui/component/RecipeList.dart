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

    return ListView.builder(
      padding: const EdgeInsets.all(10),  // 리스트의 padding 설정
      itemCount: recipes.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 25.0),  // 아이템 간의 간격 설정 (50dp 간격을 위해 위아래 각각 25dp 설정)
          child: InkWell(
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecipeBody(recipes[index]))
              )
            },
            child: Container(
              height: 150,  // 각 박스의 높이 설정
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(75),  // 알약 모양처럼 타원형 모서리 설정
                border: Border.all(
                  color: Colors.deepOrange,  // 테두리 색상
                  width: 2.0,  // 테두리 두께
                ),
              ),
              child: Center(
                child: Text(
                  recipes[index]["title"],  // 레시피 제목 표시
                  style: TextStyle(fontSize: 20),  // 텍스트 크기 설정
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
