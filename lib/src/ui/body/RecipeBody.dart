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
    super.initState();
    splitRecipe(widget.recipe["instruction"]);
    user_box = Hive.box("userBox");
    var bookmark_list = user_box.get("bookmark");
    _isbookmarked = bookmark_list.contains(widget.recipe["id"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50], // 배경색을 옅은 오렌지색으로 통일
      appBar: AppBar(
        backgroundColor: Colors.deepOrange, // 깊은 오렌지색 AppBar
        title: Text(
          widget.recipe["title"].replaceAll('_', ' '),
          style: TextStyle(
            color: Colors.white, // 타이틀 폰트 색상을 하얀색으로 설정
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'NanumSquareNeo',
          ),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          GestureDetector(
            onTap: _toggleBookMark,
            child: Icon(
              _isbookmarked ? Icons.star : Icons.star_border,
              color: Colors.yellow,
              size: 30.0,
            ),
          ),
          SizedBox(width: 16), // 아이콘과 오른쪽 끝 사이에 간격 추가
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 음식 소개를 위한 컨테이너
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 18),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "요리 개요",
                      style: TextStyle(
                        fontSize: 20,
                        //fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                        fontFamily: 'NanumSquareNeo',
                      ),
                    ),
                    SizedBox(height: 10), // 제목과 내용 사이 간격
                    Text(
                      widget.recipe["introduction"],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontFamily: 'NanumSquareNeo',
                      ),
                    ),
                  ],
                ),
              ),
              // 재료 목록을 위한 컨테이너
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "요리 재료",
                      style: TextStyle(
                        fontSize: 20,
                        //fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                        fontFamily: 'NanumSquareNeo',
                      ),
                    ),
                    SizedBox(height: 10), // 제목과 내용 사이 간격
                    Text(
                      widget.recipe['ingredient']
                          .replaceAll('[', '')
                          .replaceAll(']', '')
                          .replaceAll(' ,', ',')
                          .replaceAll(',', ', ')
                          .replaceAll('_', ' '),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontFamily: 'NanumSquareNeo',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18),
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
      ),
    );
  }

  Widget recipeSlider(int index) => Container(
    width: double.infinity,
    margin: EdgeInsets.symmetric(horizontal: 12),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white, // 내부 색상을 흰색으로 변경
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3), // 그림자 위치 조정
        ),
      ],
    ),
    child: Text(
      recipe_instruction[index].replaceAll('_', ' '),
      style: TextStyle(
        fontSize: 18,
        color: Colors.black,
        fontFamily: 'NanumSquareNeo',
        decoration: TextDecoration.none, // 밑줄 제거
        backgroundColor: Colors.transparent, // 하이라이트 제거
      ),
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
        activeDotColor: Colors.deepOrange,
        dotColor: Colors.orange.withOpacity(0.6),
      ),
    ),
  );

  void splitRecipe(String recipe) {
    // 작은따옴표 안의 내용을 추출하여 리스트로 변환
    RegExp regExp = RegExp(r"'([^']*)'");
    Iterable<RegExpMatch> matches = regExp.allMatches(recipe);

    recipe_instruction = matches.map((match) => match.group(1)!).toList();
  }

  void _toggleBookMark() {
    setState(() {
      var bookmark_list = user_box.get("bookmark");
      if (_isbookmarked) {
        bookmark_list.remove(widget.recipe["id"]);
        user_box.put("bookmark", bookmark_list);
      } else {
        bookmark_list.add(widget.recipe["id"]);
        user_box.put("bookmark", bookmark_list);
      }
      _isbookmarked = !_isbookmarked;
    });
  }
}
