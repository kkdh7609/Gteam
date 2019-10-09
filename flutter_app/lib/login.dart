import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:flutter/foundation.dart";

class login extends StatelessWidget{
  const login ({
    Key key,
    @required this.onSubmit,
  }) : super (key:key);
  final VoidCallback onSubmit;
  static final TextEditingController _user = TextEditingController();
  static final TextEditingController _pass = TextEditingController();

  String get username => _user.text;
  String get password => _pass.text;

  void clear(){
    _user.clear();
    _pass.clear();
  }

  Future<void> signIn() async{
    try {
      AuthResult result = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: username, password: password);
      print(result);
    }
    catch(e){
      print("!@#!@#!@#");
    }
  }

  @override
  Widget build(BuildContext context){
    return Column(
        children: <Widget>[
          TextField(controller: _user, decoration: InputDecoration(hintText: 'Enter a username'),),
          TextField(controller: _pass, decoration: InputDecoration(hintText: 'Enter a password'), obscureText: true,),
          RaisedButton(child: Text('Submit'), onPressed: onSubmit)
        ]
    );
  }
}