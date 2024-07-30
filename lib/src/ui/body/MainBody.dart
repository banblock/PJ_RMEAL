import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class MainBody extends StatelessWidget{
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.deepOrange, // 테두리 색상
                width: 2.0, // 테두리 두께
              ),
              borderRadius: BorderRadius.all(Radius.circular(20)), // 테두리 둥글기
            ),
            child:Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child:TextFormField(
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
                    onPressed: (){

                    },
                    icon: Icon(Icons.search)
                )

              ]
            )


          ),



        ],
      )


    );
  }
  
}