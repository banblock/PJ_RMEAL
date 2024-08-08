import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class RecipeList extends StatefulWidget{
  RecipeListStat createState() => RecipeListStat();
}
class RecipeListStat extends State<RecipeList>{
  List<String> recipes = ['밥','빵','떡','국','면','튀김','쿠이쿠이','데프픗','데챠아아'];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: recipes.length,
      itemBuilder: (BuildContext context, int index){
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.deepOrange, // 테두리 색상
              width: 1.0, // 테두리 두께
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)), // 테두리 둥글기
          ),
          height: 100,
          child: Center(
              child:Row(
              children: [
                Text(recipes[index]),
              ]
          )),
        );
      },
    );
  }
  void getRecipe(List<String> recipelist){
    recipes = recipelist;
  }
}