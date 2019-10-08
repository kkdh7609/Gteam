import 'package:flutter/material.dart';
import 'package:gteams/settings.dart';
import 'package:gteams/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget{
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp>{
  String _title = "Please Login";
  Widget _screen;
  login _login;
  settings _settings;
  bool _authent;

  _MyAppState(){
    _login = new login(onSubmit: (){onSubmit();});
    _settings = new settings();
    _screen = _login;
    _authent = false;
  }

  void onSubmit(){
    print('Login with: ' + _login.username + ' ' + _login.password);
    if(_login.username == 'user' && _login.password =='password'){
      _setAuthenticated(true);
      _screen = _settings;
    }
  }

  void _goHome(){
    print("go home");
    setState(() {
      if (_authent == true) {
        _screen = _settings;
      }
      else {
        _screen = _login;
      }
    }
    );
  }
  void _logout(){
    print("log out");
    _setAuthenticated(false);
  }
  void _setAuthenticated(bool auth){
    setState(() {
      if (auth == true) {
        _authent = true;
        _screen = _login;
        _title = "Welcome";
      }
      else {
        _screen = _login;
        _title = "Please Login";
      }
    }
    );
  }
  @override
  Widget build(BuildContext context){
    return new MaterialApp(
      title: "Lgoin here",
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text(_title),
          actions: <Widget>[
    new IconButton(icon: new Icon(Icons.home), onPressed: (){_goHome();}),
            new IconButton(icon: new Icon(Icons.exit_to_app), onPressed: (){_logout();})
          ],
        ),
        body: _screen,
      ),
    );
  }
}