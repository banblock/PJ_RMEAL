import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pj_rmeal/src/ui/component/RecipeList.dart';
import 'package:pj_rmeal/src/ui/component/SearchContainer.dart';
import '../component/RecipeProvider.dart';

class SerchBody extends StatefulWidget {
  final Future<List<String>> Function(String) search_callback;

  SerchBody(this.search_callback);

  @override
  SerchState createState() => SerchState();
}

class SerchState extends State<SerchBody> {
  late final SearchContainer search_container;
  final recipelist = RecipeList();
  final TextEditingController controller = TextEditingController();
  bool _visibility = false;

  @override
  void initState() {
    super.initState();
    search_container = SearchContainer(setRecommendRecipe);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Visibility(
            child: SizedBox(
              width: double.infinity,
              height: 300, // 적절한 높이로 설정
              child: recipelist,
            ),
            visible: _visibility,
          ),
          search_container,
        ],
      ),
    );
  }

  Future<void> setRecommendRecipe(String text) async {
    List<String> title_data = await widget.search_callback(text);
    print(title_data);

    // 상태를 업데이트하고 UI를 갱신합니다.
    Provider.of<RecipeProvider>(context, listen: false).updateRecipes(title_data);

    if (!_visibility) {
      setState(() {
        _visibility = true;
      });
    }
  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:pj_rmeal/src/ui/component/RecipeList.dart';
// import 'package:pj_rmeal/src/ui/component/SearchContainer.dart';
// import 'package:provider/provider.dart';
//
// import '../component/RecipeProvider.dart';
// class SerchBody extends StatefulWidget{
//   late final Future<List<String>> Function(String) search_callback;
//   SerchBody(this.search_callback);
//   @override
//   SerchState createState() => SerchState(this.search_callback);
// }
//
// class SerchState extends State<SerchBody>{
//   late final Future<List<String>> Function(String) search_callback;
//   late final SearchContainer search_container;
//   final recipelist = RecipeList();
//   final TextEditingController controller = TextEditingController();
//   bool _visibility  = false;
//
//   SerchState(this.search_callback);
//   // 생성자
//   @override
//   void initState() {
//     super.initState();
//     // initState에서 search_container를 초기화
//     search_container = SearchContainer(this.setRecommendRecipe);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Center(
//       //padding: const EdgeInsets.all(8),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Visibility(
//             child: Expanded(child:SizedBox(width: 1000, height: 1000,child:recipelist)),
//             visible:_visibility
//           ),
//           search_container
//         ],
//
//       ),
//
//     );
//   }
//
//   void setRecommendRecipe(String text) async{
//     List<String> title_data = await search_callback(text);
//     print(title_data);
//     Provider.of<RecipeProvider>(context, listen: false)
//         .updateRecipes(title_data);
//     if (_visibility == false){
//       _visible();
//     }
//     //recipelist.updateState(newRecipe);
//   }
//
//   void _visible(){
//     setState(() {
//       _visibility = true;
//     });
//   }
// }