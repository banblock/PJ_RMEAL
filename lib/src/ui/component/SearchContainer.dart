import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchContainer extends StatelessWidget{
  void Function() callback;
  SearchContainer(this.callback);

  TextEditingController controller = TextEditingController();
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
                    controller: controller,
                  ),
                ),
                IconButton(
                    onPressed: callback,
                    icon: Icon(Icons.search)
                )

            ]
        )
      );
  }

}