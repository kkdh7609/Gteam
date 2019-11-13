import 'package:flutter/material.dart';
import 'package:gteams/root_page.dart';
import 'package:gteams/login/login_auth.dart';
import "package:gteams/game/game_create/game_create.dart";

class SettingPage extends StatefulWidget {
  SettingPage({Key key, this.onSignedOut}) : super(key: key);

  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() => new _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Setting"),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                widget.onSignedOut();
                new RootPage(auth: new Auth());
              },
            )
          ],
        ),
        body: Center(child: TempButton()));
  }
}

class TempButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(12.0),
        child: Text('게임 생성'),
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => GameCreatePage()));
      },
    );
  }
}
