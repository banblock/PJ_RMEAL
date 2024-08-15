import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class UserSettingBody extends StatefulWidget{
  late final Box user_box;
  UserSettingBody(this.user_box);
  UserSettingState createState() => UserSettingState(user_box);
}

class UserSettingState extends State<UserSettingBody>{
  UserSettingState(this._ignordata);
  final String nonemessage = '예외 재료가 없습니다.';
  late var ignores;
  late Box _ignordata;
  late String inputText;
  late bool list_empty;
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    ignores = _ignordata.get("ignoreIngredient");
    print(ignores);
    if(ignores.isEmpty){
      list_empty = true;
    }else{
      list_empty = false;
    }

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
          Expanded(child: Column(
                children: [
                  Row(
                      children:[
                        Container(child: Text('예외 재료')),
                        ElevatedButton(onPressed: () async => await addIgnoreIngredient(), child: Text('추가')),
                      ]
                  ),
                  Expanded(child: Container(
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
                      child: isEmptyLsit()
                    )
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> addIgnoreIngredient()async{
    await _showTextInputDialog();
    setState(() {
      var ig = _ignordata.get("ignoreIngredient");
      if (ig.contains(inputText)){
        print('이미 해당 재료를 가지고 있습니다.');
      }else{
        ig.add(inputText);
        ignores = ig;
        _ignordata.put("ignoreIngredient",ig);
        if(list_empty){
          list_empty = false;
        }
      }
    });
  }

  void removeIgnoreIngredient(String igitem){
    setState(() {
      var ig = _ignordata.get("ignoreIngredient");
      ig.remove(igitem);
      ignores = ig;
      _ignordata.put("ignoreIngredient", ig);
      if(ignores.isEmpty){
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

  Widget isEmptyLsit(){
    print(ignores.length);
    if(list_empty){
      return Text(nonemessage);
    }else{
      return ListView.builder(
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
      );
    }
  }


}