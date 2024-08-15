import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class RecipeBody extends StatefulWidget {
  final Map<String, dynamic> recipe;

  RecipeBody(this.recipe);

  @override
  RecipeBodyState createState() => RecipeBodyState();
}

class RecipeBodyState extends State<RecipeBody> {
  late bool _isbookmarked;
  late Box user_box;
  int activeIndex = 0;
  late List<String> recipe_instruction;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splitRecipe(widget.recipe["instruction"]);
    user_box = Hive.box("userBox");
    var bookmark_list = user_box.get("bookmark");
    if(bookmark_list.contains(widget.recipe["id"])){
      _isbookmarked = true;
    }else{
      _isbookmarked = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(onPressed: ()=>{Navigator.pop(context)}, icon: Icon(Icons.arrow_back)),
                Text(
                  widget.recipe["title"],
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: _toggleBookMark,
                  child: Icon(
                    _isbookmarked ? Icons.star : Icons.star_border,
                    color: _isbookmarked ? Colors.yellow : Colors.grey,
                    size: 50.0,
                  ),
                ),
              ],
            ),

            SizedBox(height: 8),
            Text(
              widget.recipe["introduction"],
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.recipe['ingredient'],
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 16),
            Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                CarouselSlider.builder(
                  options: CarouselOptions(
                    initialPage: 0,
                    viewportFraction: 1,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        activeIndex = index;
                      });
                    },
                  ),
                  itemCount: recipe_instruction.length,
                  itemBuilder: (context, index, realIndex) {
                    return recipeSlider(index);
                  },
                ),
                indicator(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget recipeSlider(int index) => Container(
    width: double.infinity,
    margin: EdgeInsets.symmetric(horizontal: 12),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey[300],
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      recipe_instruction[index],
      style: TextStyle(fontSize: 18),
    ),
  );

  Widget indicator() => Container(
    margin: const EdgeInsets.only(bottom: 20.0),
    child: AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: recipe_instruction.length,
      effect: JumpingDotEffect(
        dotHeight: 6,
        dotWidth: 6,
        activeDotColor: Colors.white,
        dotColor: Colors.white.withOpacity(0.6),
      ),
    ),
  );

  void splitRecipe(String recipe) {
    String input = recipe;

    // 대괄호와 작은따옴표를 제거하고, 항목을 추출
    // 정규식을 사용하여 작은따옴표 안의 내용을 올바르게 추출
    RegExp regExp = RegExp(r"'([^']*)'");
    Iterable<RegExpMatch> matches = regExp.allMatches(input);

    recipe_instruction = matches.map((match) => match.group(1)!).toList();

  }

  void _toggleBookMark(){
    setState(() {
      var bookmark_list = user_box.get("bookmark");
      if(_isbookmarked){
        bookmark_list.remove(widget.recipe["id"]);
        user_box.put("bookmark", bookmark_list);
      }else{
        bookmark_list.add(widget.recipe["id"]);
        user_box.put("bookmark", bookmark_list);
      }
      _isbookmarked = !_isbookmarked;
    });
  }
}