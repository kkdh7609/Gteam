import 'package:flutter/material.dart';
import 'package:gteams/authentication.dart';
import 'package:gteams/root_page.dart';

class settings extends StatefulWidget{
  settings({Key key, this.onSignedOut}) : super(key: key);

  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() => new _sett();
}

class _sett extends State<settings>{
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