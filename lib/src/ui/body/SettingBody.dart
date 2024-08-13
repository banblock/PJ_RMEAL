import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pj_rmeal/src/ui/body/UserSetting.dart';

class SettingBody extends StatelessWidget{
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
              MaterialPageRoute(builder: (context) => UserSettingBody())
            )
          }, child: Text("UI")),
          // TextButton(onPressed: ()=>{
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) => const )
          //   )
          // }, child: Text("User")),
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