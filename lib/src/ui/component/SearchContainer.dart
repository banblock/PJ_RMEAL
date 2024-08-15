import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchContainer extends StatelessWidget{
  final Function(String) callback;
  SearchContainer(this.callback);

  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
          alignment: Alignment.center,
          width: 800,
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.deepOrange, // 테두리 색상
              width: 2.0, // 테두리 두께
            ),
            borderRadius: BorderRadius.all(Radius.circular(20)), // 테두리 둥글기
          ),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 10,),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'hint',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    controller: _controller,
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      _showLoadingDialog(context);
                      await callback(_controller.text);
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    icon: Icon(Icons.search)
                )

            ]
        )
      );
  }

  Future<void> _showLoadingDialog(BuildContext context)async{
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // 다이얼로그의 핸들을 저장합니다.
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text('Loading...'),
              ],
            ),
          ),
        );
      },
    );
  }

}