import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pj_rmeal/src/ui/component/RecipeList.dart';
import 'package:pj_rmeal/src/ui/component/SearchContainer.dart';
class SerchBody extends StatefulWidget{
  @override
  SerchState createState() => SerchState();
}

class SerchState extends State<SerchBody>{
  SearchContainer search_container = SearchContainer();
  final recipelist = RecipeList();
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child:SizedBox(width: 1000, height: 1000,child:recipelist)),
          search_container
        ],

      ),

    );
  }

}