//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dto/user.dart';
import 'dto/recipe.dart';

//await Hive.init();

void main() async{
  //runApp(const MyApp());
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(RecipeAdapter());

  await Hive.openBox<User>('users');
  await Hive.openBox<Recipe>('recipes');

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home : Scaffold(
        appBar: AppBar(
          title: Text('AItest'),
        ),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'chat',
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
