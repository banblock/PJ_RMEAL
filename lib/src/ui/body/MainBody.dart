import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainBody extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              ElevatedButton(onPressed: onPressed, child: child),
              SizedBox(width: 5),
              ElevatedButton(onPressed: , child: child)
            ],
            
          ),
          SizedBox(height: 10),
          Container(

          ),
          SizedBox(height: 10),
          Container(

          ),

        ],
      )


    );
  }
  
}