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
    if (ignores.isEmpty) {
      list_empty = true;
    } else {
      list_empty = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50], // 전체 페이지의 배경색 설정
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () => {Navigator.pop(context)},
                    icon: Icon(Icons.arrow_back)),
                SizedBox(width: 20), // 간격 조정
                Text(
                  "UserSetting",
                  style: TextStyle(
                    fontSize: 20, // 폰트 크기 조정
                    color: Colors.black, // 글씨 색상 검은색으로 변경
                    decoration: TextDecoration.none, // 언더바 제거
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  Row(children: [
                    Container(
                      child: Text(
                        '예외 재료',
                        style: TextStyle(
                          fontSize: 18, // 폰트 크기 조정
                          color: Colors.black, // 글씨 색상 검은색으로 변경
                          decoration: TextDecoration.none, // 언더바 제거
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                        onPressed: () async => await addIgnoreIngredient(),
                        child: Text('추가')),
                  ]),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 10), // 컨테이너 간의 간격 조정
                      decoration: BoxDecoration(
                        color: Colors.white, // 컨테이너 배경색 흰색
                        borderRadius: BorderRadius.circular(12), // 둥근 모서리
                        border: Border.all(
                          color: Colors.orange, // 테두리 색상 진한 오렌지색
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // 그림자 위치 조정
                          ),
                        ],
                      ),
                      child: isEmptyLsit(),
                    ),
                  ),
                ],
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
          title: Text('Enter some text'),
          content: TextField(
            onChanged: (value) {
              input = value;
            },
            decoration: InputDecoration(hintText: "Type something here"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 아무 값도 전달하지 않고 팝업 닫기
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(input); // 입력된 텍스트를 팝업 종료 시 반환
              },
              child: Text('OK'),
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

  Widget isEmptyLsit() {
    if (list_empty) {
      return Center(
        child: Text(
          nonemessage,
          style: TextStyle(
            fontSize: 16, // 적절한 크기로 설정
            color: Colors.black, // 글씨 색상 검은색으로 변경
            decoration: TextDecoration.none, // 언더바 제거
          ),
        ),
      );
    } else {
      return ListView.builder(
          itemCount: ignores.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8), // 항목 간의 간격을 10dp로 설정
              padding: EdgeInsets.all(12), // 항목 내부 여백 추가
              decoration: BoxDecoration(
                color: Colors.white, // 항목 배경색 흰색
                borderRadius: BorderRadius.circular(12), // 둥근 모서리
                border: Border.all(
                  color: Colors.orange, // 테두리 색상 진한 오렌지색
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // 그림자 위치 조정
                  ),
                ],
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ignores[index],
                      style: TextStyle(
                        fontSize: 16, // 폰트 크기 조정
                        color: Colors.black, // 글씨 색상 검은색으로 변경
                        decoration: TextDecoration.none, // 언더바 제거
                      ),
                    ),
                    IconButton(
                      onPressed: () => {removeIgnoreIngredient(ignores[index])},
                      icon: Icon(Icons.delete, color: Colors.orange),
                    )
                  ],
                ),
              ),
            );
          });
    }
  }
}
