import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../component/RecipeList.dart';
import 'RecipeBody.dart';

class BookMarkBody extends StatefulWidget{
  List<Map<String,dynamic>> all_recipes;
  BookMarkBody(this.all_recipes);
  BookMarkState createState() => BookMarkState();
}

class BookMarkState extends State<BookMarkBody>{
  late Box user_box;
  late List<Map<String,dynamic>> out_recipes;
  late bool _bookmark_tag;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user_box = Hive.box("userBox");
    out_recipes = widget.all_recipes;
    _bookmark_tag = false;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          GestureDetector(
            onTap: switchBookMarkRecipe,
            child: Icon(
              _bookmark_tag ? Icons.star : Icons.star_border,
              color: _bookmark_tag ? Colors.yellow : Colors.grey,
              size: 50.0,
            ),
          ),
          Expanded(child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: out_recipes.length,
              itemBuilder: (BuildContext context, int index){
                return InkWell(
                    onTap: () =>{
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RecipeBody(out_recipes[index]))
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
                                Text(out_recipes[index]["title"]),
                              ]
                          )
                      ),
                    )
                );
              },
            )
          )
        ])  //child: _have_bookmark?Expanded(child: SizedBox(child:RecipeList())):Text("저장된 bookmark가 없습니다."),
      );
  }

  void switchBookMarkRecipe(){
    setState(() {
      if(_bookmark_tag){
        out_recipes = widget.all_recipes;
        _bookmark_tag = !_bookmark_tag;
      }else{
        var ids = user_box.get("bookmark");
        List<Map<String,dynamic>> bookmark_recipes = filterByIds(ids, widget.all_recipes);
        out_recipes = bookmark_recipes;
        _bookmark_tag = !_bookmark_tag;
      }
    });

  }

  List<Map<String, dynamic>> filterByIds(List<dynamic> ids, List<Map<String, dynamic>> data) {
    var result = data.where((map) => ids.contains(map['id'])).toList();
    print(result);
    return result;
  }

}