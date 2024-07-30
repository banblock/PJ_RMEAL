import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pj_rmeal/src/ui/component/RecipeList.dart';
class SerchBody extends StatefulWidget{
  @override
  SerchState createState() => SerchState();
}

class SerchState extends State<SerchBody>{
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Expanded(child: RecipeList()),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.deepOrange, // 테두리 색상
                width: 2.0, // 테두리 두께
              ),
              borderRadius: BorderRadius.all(Radius.circular(20)), // 테두리 둥글기
            ),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'hint',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      controller: controller,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        print('he');
                      },
                      icon: Icon(Icons.search)
                  )

                ]
            )
          )
        ],

      ),

    );
  }

}