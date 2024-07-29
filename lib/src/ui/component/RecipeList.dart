import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class RecipeList extends StatefulWidget{
  RecipeListStat createState() => RecipeListStat();
}
class RecipeListStat extends State<RecipeList>{
  List<String> recipes = ['밥','빵','떡','국','면','튀김'];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: recipes.length,
      itemBuilder: (BuildContext context, int index){
        return Container(
          height: 100,
          child: Center(child: Text(recipes[index])),
        );
      },
    );
  }
  void getRecipe(List<String> recipelist){
    recipes = recipelist;
  }
}