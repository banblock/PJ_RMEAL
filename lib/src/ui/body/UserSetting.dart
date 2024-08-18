import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class UserSettingBody extends StatefulWidget {
  late final Box user_box;
  UserSettingBody(this.user_box);
  UserSettingState createState() => UserSettingState(user_box);
}

class UserSettingState extends State<UserSettingBody> {
  UserSettingState(this._ignordata);
  final String nonemessage = '예외 재료가 없습니다.';
  late var ignores;
  late Box _ignordata;
  late String inputText;
  late bool list_empty;

  @override
  void initState() {
    super.initState();
    ignores = _ignordata.get("ignoreIngredient");
    list_empty = ignores.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCEEE4), // 전체 페이지 배경색
      appBar: AppBar(
        title: Text(
          "예외재료 설정하기",
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'NanumSquareNeo',
            color: Colors.white,
            decoration: TextDecoration.none,
          ),
        ),
        backgroundColor: Color(0xFFE5741F), // AppBar 배경색
        iconTheme: IconThemeData(color: Colors.white), // 뒤로가기 아이콘
      ),
      body: Padding(
        padding: EdgeInsets.all(13), // 패딩을 8에서 13으로 수정
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10), // AppBar 간 간격 추가
              child: Center(
                child: ElevatedButton(
                  onPressed: () async => await addIgnoreIngredient(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE5741F), // 버튼 배경색을 주황색
                    padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15), // 버튼 너비 직접 설정함
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // 둥근 모서리
                    ),
                  ),
                  child: Text(
                    '예외재료 추가하기',
                    style: TextStyle(
                      fontSize: 18, // 폰트 크기
                      fontFamily: 'NanumSquareNeo', // 나눔스퀘어 네오
                      color: Colors.white,
                      decoration: TextDecoration.none, // 언더바 제거
                    ),
                  ),
                ),
              ),
            ),
            
            //폰 크기에 맞추는 버튼은 이걸 사용
            // Row(
            //   children: [
            //     Expanded(
            //       child: ElevatedButton(
            //         onPressed: () async => await addIgnoreIngredient(),
            //         style: ElevatedButton.styleFrom(
            //           primary: Color(0xFFE5741F), // 버튼 배경색을 주황색으로 설정
            //           padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15), // 버튼의 길이와 높이 조정
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(12), // 둥근 모서리
            //           ),
            //         ),
            //         child: Text(
            //           '예외재료 추가하기',
            //           style: TextStyle(
            //             fontSize: 18, // 폰트 크기 조정
            //             fontFamily: 'NanumSquareNeo', // 나눔스퀘어 네오 글씨체 설정
            //             color: Colors.white, // 글씨 색상 하얀색으로 변경
            //             decoration: TextDecoration.none, // 언더바 제거
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            
            Expanded(
              child: Container(
                width: double.infinity, // 컨테이너 너비를 화면 전체로 고정
                margin: EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white, // 컨테이너 배경색 흰색
                  borderRadius: BorderRadius.circular(12), // 둥근 모서리
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFE5741F).withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(4, 5), // 그림자 위치
                    ),
                  ],
                ),
                constraints: BoxConstraints(
                  minHeight: 100, // 최소 높이
                  maxHeight: 200, // 최대 높이
                ),
                child: isEmptyList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addIgnoreIngredient() async {
    await _showTextInputDialog();
    setState(() {
      var ig = _ignordata.get("ignoreIngredient");
      if (ig.contains(inputText)) {
        print('이미 해당 재료를 가지고 있습니다.');
      } else {
        ig.add(inputText);
        ignores = ig;
        _ignordata.put("ignoreIngredient", ig);
        if (list_empty) {
          list_empty = false;
        }
      }
    });
  }

  void removeIgnoreIngredient(String igitem) {
    setState(() {
      var ig = _ignordata.get("ignoreIngredient");
      ig.remove(igitem);
      ignores = ig;
      _ignordata.put("ignoreIngredient", ig);
      if (ignores.isEmpty) {
        list_empty = true;
      }
    });
  }

  Future<void> _showTextInputDialog() async {
    String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String input = "";
        return AlertDialog(
          title: Text(
            '재료 입력',
            style: TextStyle(fontFamily: 'NanumSquareNeo'),
          ),
          content: TextField(
            onChanged: (value) {
              input = value;
            },
            decoration: InputDecoration(hintText: "여기에 재료를 입력하세요"),
            style: TextStyle(fontFamily: 'NanumSquareNeo'
                ,color: Color(0xFFE5741F)),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 아무 값도 전달하지 않고 팝업 닫기
              },
              child: Text('취소', style: TextStyle(fontFamily: 'NanumSquareNeo'
              ,color: Color(0xFFE5741F))),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(input); // 입력된 텍스트를 팝업 종료 시 반환
              },
              child: Text('확인', style: TextStyle(fontFamily: 'NanumSquareNeo'
                  ,color: Color(0xFFE5741F))),
            ),
          ],
        );
      },
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        inputText = result;
      });
    }
  }

  Widget isEmptyList() {
    if (list_empty) {
      return Center(
        child: Text(
          nonemessage,
          style: TextStyle(
            fontSize: 16, // 적절한 크기로 설정
            fontFamily: 'NanumSquareNeo', // 나눔스퀘어 네오 글씨체 설정
            color: Colors.black, // 글씨 색상 검은색으로 변경
            decoration: TextDecoration.none, // 언더바 제거
          ),
        ),
      );
    } else {
      return Wrap(
        spacing: 8.0, // 칩 간의 간격 설정
        runSpacing: 4.0, // 줄 간의 간격 설정
        children: generateIgnoreChips(),
      );
    }
  }

  List<Widget> generateIgnoreChips() {
    return ignores.map<Widget>((ingredient) {
      return Chip(
        label: Text(
          ingredient,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontFamily: 'NanumSquareNeo',
          ),
        ),
        backgroundColor: Color(0xFFE5741F).withOpacity(0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // 칩의 둥근 모서리 조정
          side: BorderSide(color: Colors.white, width: 2), // 테두리 색상 및 두께 조정
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), // 칩 크기 조정
        deleteIcon: Icon(Icons.close, color: Colors.white), // 삭제 아이콘 설정
        onDeleted: () {
          removeIgnoreIngredient(ingredient);
        },
      );
    }).toList();
  }
}
