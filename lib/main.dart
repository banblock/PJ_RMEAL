//import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final DataControl dataControl;

  const MyApp({Key? key, required this.dataControl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.green),
      home: DataPage(dataControl: dataControl),
      routes: {
        '/userPage': (context) => UserPage(dataControl: dataControl),
      },
    );
  }
}
