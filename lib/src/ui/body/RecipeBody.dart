import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

//import 'package:flutter/material.dart';

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
      backgroundColor: Color(0xFFFCEEE4), // 배경색을 옅은 오렌지색으로 통일
      appBar: AppBar(
        backgroundColor: Color(0xFFE5741F), // 깊은 오렌지색 AppBar
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          widget.recipe["title"].replaceAll('_', ' '),
          style: TextStyle(
            color: Colors.white, // 타이틀 폰트 색상을 하얀색으로 설정
            fontSize: 24,
            fontWeight: FontWeight.w800,
            fontFamily: 'NanumSquareNeo',
          ),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          GestureDetector(
            onTap: _toggleBookMark,
            child: Icon(
              _isbookmarked ? Icons.star : Icons.star_border,
              color: Color(0xFFFFC000), // 별 아이콘의 노란색
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
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 28, left: 10, right: 10), // 마진을 10dp로 설정
                padding: EdgeInsets.all(16), // 기본 패딩 유지
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(4, 5),
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
                        color: Color(0xFFE5741F), // 진한 오렌지색 텍스트
                        fontWeight: FontWeight.w800,
                        fontFamily: 'NanumSquareNeo',
                      ),
                    ),
                    SizedBox(height: 10), // 제목과 내용 사이 간격
                    Text(
                      widget.recipe["introduction"],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'NanumSquareNeo',
                      ),
                    ),
                  ],
                ),
              ),
              // 재료 목록을 위한 컨테이너
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(left: 10, right: 10), // 마진을 10dp로 설정
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(4, 5),
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
                        color: Color(0xFFE5741F), // 진한 오렌지색 텍스트
                        fontWeight: FontWeight.w800,
                        fontFamily: 'NanumSquareNeo',
                      ),
                    ),
                    SizedBox(height: 10), // 제목과 내용 사이 간격
                    Wrap(
                      spacing: 8.0, // Chip 사이의 간격
                      runSpacing: 4.0, // Chip 줄 간격
                      children: _buildIngredientChips(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20), // 간격을 10dp 추가
              Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3 -15 , // 슬라이더 높이 + 5dp
                    child: CarouselSlider.builder(
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

  List<Widget> _buildIngredientChips() {
    // 문자열을 파싱하여 재료 목록을 생성
    var ingredients = widget.recipe['ingredient']
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll(' ,', ',')
        .replaceAll(',', ', ')
        .replaceAll('_', ' ')
        .replaceAll("'", '') // ' 제거
        .split(', ');

    return ingredients.map<Widget>((ingredient) {
      return Chip(
        label: Text(
          ingredient,
          style: TextStyle(
            fontFamily: 'NanumSquareNeo',
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.orange.withOpacity(0.4),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        side: BorderSide.none, // 테두리 제거
      );
    }).toList();
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
          spreadRadius: 1,
          blurRadius: 1,
          offset: Offset(4, 5), // 그림자 위치 조정
        ),
      ],
    ),
    child: Text(
      recipe_instruction[index].replaceAll('_', ' '),
      style: TextStyle(
        fontSize: 18,
        color: Colors.black,
        fontWeight: FontWeight.w700,
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
        activeDotColor: Color(0xFFE5741F),
        dotColor: Color(0xFFFFC000).withOpacity(0.6),
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

