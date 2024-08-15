import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'RecipeBody.dart';

class AllRecipeBody extends StatelessWidget{
  List<Map<String,dynamic>> recipes;
  AllRecipeBody(this.recipes);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw Padding(
      padding: EdgeInsets.all(8),
      child: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (BuildContext context, int index){
          return InkWell(
            onTap: () =>{
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RecipeBody(recipes[index]))
              )
            },
            child:Container(
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
                    Text(recipes[index]["title"]),
                  ]
                )
              ),
            )
          );
        },
      )
    );
  }

}
