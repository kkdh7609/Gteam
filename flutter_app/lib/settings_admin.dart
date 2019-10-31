import 'package:flutter/material.dart';
import 'package:gteams/game_create.dart';
import 'package:gteams/login_auth.dart';
import 'package:gteams/root_page.dart';

class SettingAdminPage extends StatefulWidget{
  SettingAdminPage({Key key, this.onSignedOut}) : super(key: key);

  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() => new _SettingAdminPageState();
}

class _SettingAdminPageState extends State<SettingAdminPage>{
  final _formKey = new GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
          child: new Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _showBackButton(),
                  SizedBox(height : 30.0),
                ],
              )
          )
      ),
    );
  }

    Widget _showBackButton(){
      return Container(
        margin: const EdgeInsets.only(top: 20.0),
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: FlatButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                splashColor: Color(0xff3B5998),
                color: Color(0xff3B5998),
                child: new Row(
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        "Admin page",
                        style: TextStyle(fontSize : 17.0, color: Colors.white),
                      ),
                    ),
                    new Expanded(
                      child: Container(),
                    ),
                    new Transform.translate(
                      offset: Offset(15.0, 0.0),
                      child: new Container(
                        padding: const EdgeInsets.all(5.0),
                        child: FlatButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius:
                              new BorderRadius.circular(28.0)),
                          splashColor: Colors.white,
                          color: Colors.white,
                          child: Icon(Icons.undo, color: Color(0xff3B5998)),
                          onPressed: () {  Navigator.push(context, MaterialPageRoute(builder: (context)=>GameCreatePage())); },
                        ),
                      ),
                    )
                  ],
                ),
                onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context)=>GameCreatePage())); },
              ),
            ),
          ],
        ),
      );
    }

}