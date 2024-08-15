import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class RecipeBody extends StatefulWidget{
  late final Map<String, dynamic> recipe;
  RecipeBody(this.recipe);
  RecipeBodyState createState() => RecipeBodyState(recipe);
}
class RecipeBodyState extends State<RecipeBody>{
  late final Map<String, dynamic> recipe;
  RecipeBodyState(this.recipe);
  int activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Text("${recipe["title"]}"),
          Text("${recipe["introduction"]}"),
          Container(
            child: Text("${recipe['Ingrediant']}"),
          ),
          Stack(alignment: Alignment.bottomCenter, children: <Widget>[
            CarouselSlider.builder(
              options: CarouselOptions(
                initialPage: 0,
                viewportFraction: 1,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) => setState(() {
                  activeIndex = index;
                }),
              ),
              itemCount: recipe["instruction"].length,
              itemBuilder: (context, index, realIndex) {
                return recipeSlider(index);
              },
            ),
            Align(alignment: Alignment.bottomCenter, child: indicator())
          ])

        ],
      ),
    );
  }


  Widget recipeSlider(index) => Container(
    width: double.infinity,
    height: 240,
    color: Colors.grey,
    child: Text(recipe["instruction"][index]),
  );


  Widget indicator() => Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      alignment: Alignment.bottomCenter,
      child: AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: recipe["instruction"].length,
        effect: JumpingDotEffect(
            dotHeight: 6,
            dotWidth: 6,
            activeDotColor: Colors.white,
            dotColor: Colors.white.withOpacity(0.6)),
      ));
}