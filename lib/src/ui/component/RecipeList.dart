import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pj_rmeal/src/ui/component/RecipeProvider.dart';
import 'package:provider/provider.dart';
class RecipeList extends StatefulWidget{
  _RecipeListStat createState() => _RecipeListStat();
}
class _RecipeListStat extends State<RecipeList>{
  @override

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final recipeProvider = Provider.of<RecipeProvider>(context);
    final recipes = recipeProvider.recipes;
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

}

//List<Map<String, Object>>