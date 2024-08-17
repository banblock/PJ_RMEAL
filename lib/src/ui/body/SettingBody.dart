import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pj_rmeal/src/ui/body/UserSetting.dart';

class SettingBody extends StatelessWidget {
  final Box user_box = Hive.box("userBox");

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2열로 
          crossAxisSpacing: 30, // 열 건격
          mainAxisSpacing: 30, // 행  간격
          childAspectRatio: 1, // 비율
        ),
        itemCount: 4, // 개수
        itemBuilder: (context, index) {
          return _buildGridItem(context, index);
        },
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserSettingBody(user_box)),
          );
        }
        // 여따 필요하면 클릭 동작 추가
      },
      child: Container(
        padding: EdgeInsets.all(10), // 컨테이너 내부 패딩
        decoration: BoxDecoration(
          color: Colors.white, // 배경색
          borderRadius: BorderRadius.circular(20), // 둥근 모서리
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3), // 그림자 색상
              offset: Offset(0, 4), // 위치
              blurRadius: 6, // 흐리기
              spreadRadius: 1, // 퍼짐
            ),
          ],
        ),
        child: Center(
          child: index == 0
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.filter_alt, // 필터 아이콘
                size: 60,
                color: Color(0xFFE5741F), // 아이콘 색상
              ),
              SizedBox(height: 8), // 아이콘과 텍스트 사이의 간격
              Text(
                "예외재료 설정",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE5741F), // 텍스트 색상
                ),
              ),
            ],
          )
              : Icon(
            Icons.settings, // 기능 없는 설정 버튼
            size: 60,
            color: Color(0xFFE5741F).withOpacity(0.3), //기본 색에 투명하게 함
          ),
        ),
      ),
    );
  }
}
