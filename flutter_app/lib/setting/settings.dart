import 'package:flutter/material.dart';
import 'package:gteams/login/login_auth.dart';
import 'package:gteams/root_page.dart';

class SettingPage extends StatefulWidget{
  SettingPage({Key key, this.onSignedOut}) : super(key: key);

  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() => new _SettingPageState();
}

class _SettingPageState extends State<SettingPage>{
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
      body: Text("setting")
    );
  }
}