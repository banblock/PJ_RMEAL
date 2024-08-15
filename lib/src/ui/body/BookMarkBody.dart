import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import '../component/RecipeList.dart';

class BookMarkBody extends StatefulWidget{
  BookMarkState createState() => BookMarkState();
}

class BookMarkState extends State<BookMarkBody>{
  late Box user_box;
  late bool _have_bookmark;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user_box = Hive.box("userBox");
    var bookmarkids = user_box.get("bookmark");
    if(bookmarkids.isEmpty){
      _have_bookmark = false;
    }else{
      _have_bookmark = true;
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Expanded(child: SizedBox(child:RecipeList())),
        //child: _have_bookmark?Expanded(child: SizedBox(child:RecipeList())):Text("저장된 bookmark가 없습니다."),
    );
  }



}