import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pj_rmeal/src/ui/body/UserSetting.dart';

class SettingBody extends StatelessWidget{
  final Box user_box = Hive.box("userBox");
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          TextButton(onPressed: ()=>{
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserSettingBody(user_box))
            )
          }, child: Text("User")),
          // TextButton(onPressed: ()=>{
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) => const )
          //   )
          // }, child: Text("UI")),
          // TextButton(onPressed: ()=>{
          //   Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => const )
          //   )
          // }, child: Text("Recipes"))


        ],
      ),

    );
  }

}