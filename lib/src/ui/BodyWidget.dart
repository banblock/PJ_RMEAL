import 'package:flutter/material.dart';

class Bodywidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
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
    );
  }

}

// class Bodywidget extends StatefulWidget{
//   const Bodywidget({super.key});
//
//   @override
//   State<Bodywidget> createState() => _BodyWidgetState();
//
// }
//
// class _BodyWidgetState extends State<Bodywidget>{
//   Widget bodyPage = Container(color: Colors.yellow);
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         bodyPage, // 컨테이너 위젯 변수
//       ],
//     );
//   }
// }
//
//
// class MainPage extends StatelessWidget {
//   const MainPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(color: Colors.blue);
//   }
// }
//
// // 페이지2 : 보라색 화면
// class ChatPage extends StatelessWidget {
//   const ChatPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(color: Colors.deepPurple);
//   }
// }