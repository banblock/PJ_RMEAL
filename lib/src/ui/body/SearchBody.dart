import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pj_rmeal/src/ui/component/RecipeList.dart';
import 'package:pj_rmeal/src/ui/component/SearchContainer.dart';
import 'package:provider/provider.dart';

import '../component/RecipeProvider.dart';

class SearchBody extends StatefulWidget {
  late final Future<List<Map<String, dynamic>>> Function(String) search_callback;

  SearchBody(this.search_callback);

  @override
  SearchState createState() => SearchState(this.search_callback);
}

class SearchState extends State<SearchBody> {
  late final Future<List<Map<String, dynamic>>> Function(String) search_callback;
  late final SearchContainer search_container;
  final recipelist = RecipeList();
  final TextEditingController controller = TextEditingController();
  bool _visibility = false;

  SearchState(this.search_callback);

  @override
  void initState() {
    super.initState();
    search_container = SearchContainer(this.setRecommendRecipe);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Visibility(
              child: Expanded(
                  child: Container(
                    width: 1000,
                    height: 750, // Adjusted to show approximately 5 items
                    child: recipelist,
                    padding: EdgeInsets.all(10), // Padding around the list
                  )),
              visible: _visibility),
          search_container
        ],
      ),
    );
  }

  void setRecommendRecipe(String text) async {
    List<Map<String, dynamic>> title_data = await search_callback(text);
    Provider.of<RecipeProvider>(context, listen: false)
        .updateRecipes(title_data);

    if (_visibility == false) {
      _visible();
    }
  }

  void _visible() {
    setState(() {
      _visibility = true;
    });
  }
}
