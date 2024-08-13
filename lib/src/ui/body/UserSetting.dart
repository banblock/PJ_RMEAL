import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pj_rmeal/src/dto/Userdata.dart';
import 'package:hive_flutter/adapters.dart';

class UserSettingBody extends StatefulWidget{
  UserSettingState createState() => UserSettingState();
}

class UserSettingState extends State<UserSettingBody>{
  final String nonemessage = '예외 재료가 없습니다.';
  late var ignores;
  late Box _ignordata;
  late String inputText;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ignordata = Hive.box("userBox");
    ignores = _ignordata.get("ignoreIngredient");
    ignores ??= [nonemessage];
  }
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Row(children: [
            IconButton(onPressed: ()=>{Navigator.pop(context)}, icon: Icon(Icons.arrow_back)),
            SizedBox(width: 300,),Text("UserSetting")
          ],),
          Container(
            height: 1000,
            width: 1000,
            child: Column(
                children: [
                  Row(
                      children:[
                        Container(child: Text('예외 재료')),
                        ElevatedButton(onPressed: ()=>addIgnoreIngredient(), child: Text('추가')),
                      ]
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ListView.builder(
                      itemCount: ignores.length,
                      itemBuilder: (BuildContext context, int index){
                        return Container(
                          height: 100,
                          child: Center(
                              child:Row(
                                  children: [
                                    Text(ignores[index]),
                                    IconButton(onPressed: () => {removeIgnoreIngredient(ignores[index])}, icon: Icon(Icons.delete))
                                  ]
                              )),
                        );
                      }
                  )),
              ],
            ),
          )
        ],
      ),
    );
  }

  void addIgnoreIngredient(){
    _showTextInputDialog();
    setState(() {
      var ig = _ignordata.get("ignoreIngredient");
      if (ig.contains(inputText)){
        print('이미 해당 재료를 가지고 있습니다.');
      }else{
        ig.add(inputText);
        ignores = ig;
        _ignordata.put("ignoreIngredient", ig);
      }
    });
  }

  void removeIgnoreIngredient(String igitem){
    setState(() {
      var ig = _ignordata.get("ignoreIngredient");
      ig.remove(igitem);
      ignores = ig;
      _ignordata.put("ignoreIngredient", ig);
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


}