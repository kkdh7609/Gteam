import 'dart:async';
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:flutter/foundation.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'services/crud.dart';

class GameCreatePage extends StatefulWidget{
  @override
  _GameCreatePageState createState() => _GameCreatePageState();
}

class _GameCreatePageState extends State<GameCreatePage>{
  final _formKey = new GlobalKey<FormState>();

  String _game_title;
  String _game_day;
  String _game_time;
  int _duration;
  String _game_type;
  String _game_gender;
  int _game_level;
  bool _can_invite_friends;
  int _game_member_number;
  String _user_uid;

  crudMedthods crudObj = new crudMedthods();
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
          child: new Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _showGameTitle(),
                  _showTextFieldTitle("Game Name"),
                  _showNameTextField(),
                  SizedBox(height: 10.0),
                  _showCreateAccountButton(),
                  _showBackButton(),
                  SizedBox(height : 30.0),
                ],
              )
          )
      ),
    );
  }

  Widget _showGameTitle(){
    return Container(
      child: Stack(
          children: <Widget>[
            Container(
                padding: EdgeInsets.fromLTRB(15.0, 70.0, 0.0, 50.0),
                child: Text('GAME CREATE', style: TextStyle(fontSize: 45.0, fontWeight: FontWeight.bold, color: Colors.black))
            ),
          ]
      ),
    );
  }

  Widget _showTextFieldTitle(String title){
    return Padding(
      padding: const EdgeInsets.only(left: 40.0),
      child: Text(
        title,
        style: TextStyle(color: Colors.grey, fontSize: 16.0),
      ),
    );
  }

  Widget _showNameTextField(){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin:
      const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: <Widget>[
          new Padding(
              padding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Icon(Icons.person_outline, color: Colors.grey)
          ),
          Container(
              height: 30.0,
              width: 1.0,
              color: Colors.grey.withOpacity(0.5),
              margin: const EdgeInsets.only(left: 00.0, right: 10.0)
          ),
          new Expanded(
            child: new TextFormField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Enter GameTitle",
                hintStyle: TextStyle(color: Colors.grey),
              ),
              validator: (value) {
                return value.isEmpty ? "Title can\'t be empty" : null;
              },
              onSaved: (value) { _game_title = value; },
            ),
          )
        ],
      ),
    );
  }

  Widget _showCreateAccountButton(){
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: FlatButton(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              splashColor: Colors.blue,
              color: Colors.blue,
              child: new Row(
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Create game",
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
                        child: Icon(Icons.redo, color: Colors.blue),
                        onPressed: () async {
                          if(_formKey.currentState.validate())
                            _formKey.currentState.save();
                          final FirebaseUser user =await FirebaseAuth.instance.currentUser();
                          crudObj.addData({
                            'gameName':_game_title,
                            'user_uid': user.uid
                          }).catchError((e){
                            print(e);
                          });
                          print(_game_title);
                          Navigator.pop(context); },
                      ),
                    ),
                  )
                ],
              ),
              onPressed: () async {
                if(_formKey.currentState.validate())
                  _formKey.currentState.save();
                final FirebaseUser user =await FirebaseAuth.instance.currentUser();
                print(user.uid);
                crudObj.addData({
                  'gameName':_game_title,
                  'user_uid':user.uid
                }).catchError((e){
                  print(e);
                });
                print(_game_title);
                Navigator.pop(context); },
            ),
          ),
        ],
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
                      "Back to the main Page",
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
                        onPressed: () { Navigator.pop(context); },
                      ),
                    ),
                  )
                ],
              ),
              onPressed: () { Navigator.pop(context); },
            ),
          ),
        ],
      ),
    );
  }

}