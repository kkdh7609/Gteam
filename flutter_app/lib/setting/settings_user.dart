import 'package:flutter/material.dart';
import 'package:gteams/login/login_auth.dart';
import 'package:gteams/root_page.dart';
import 'package:gteams/signup/sign_up.dart';
import 'package:gteams/game/game_create.dart';
import 'package:gteams/map/google_map.dart';
import 'package:gteams/game_join/game_join.dart';

class SettingUserPage extends StatefulWidget{
  SettingUserPage({Key key, this.onSignedOut}) : super(key: key);

  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() => new _SettingUserPageState();
}

class _SettingUserPageState extends State<SettingUserPage>{
  @override
  Widget build(BuildContext context){
    return new Scaffold(
        appBar: AppBar(title: Text("Setting"),
            actions: <Widget>[
              new IconButton(
                  icon: new Icon(Icons.arrow_back),
                  onPressed: (){
                    widget.onSignedOut();
                    new RootPage(auth: new Auth());
                  }
              )
            ]),
        body: Center(
            child: TempButton()
        )
    );
  }
}

class TempButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child:Column(

          children: <Widget>[
            FlatButton(
              child: Text("게임 생성"),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>GameCreatePage()));
              },
            ),
            FlatButton(
              child: Text("게임 참여"),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>GameJoinPage()));
              },
            )
          ],
        )
    );
  }
}