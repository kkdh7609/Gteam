import 'package:flutter/material.dart';
import 'package:gteams/login_auth.dart';
import 'package:gteams/settings.dart';
import 'package:gteams/login.dart';

class RootPage extends StatefulWidget{
  RootPage({this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus{
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class _RootPageState extends State<RootPage>{
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus = AuthStatus.NOT_LOGGED_IN;
        // user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void _onLoggedIn(){
    widget.auth.getCurrentUser().then((user){
      setState((){
        _userId = user.uid.toString();
      });
    });
    setState((){
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void _onSignedOut(){
    setState((){
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  Widget _buildWaitingScreen(){
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    switch (authStatus){
      case AuthStatus.NOT_DETERMINED:
        return _buildWaitingScreen();
        break;

      case AuthStatus.NOT_LOGGED_IN:
        return new LoginPage(
          auth: widget.auth,
          onSignedIn: _onLoggedIn,
        );
        break;

      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null){
          return new SettingPage(onSignedOut: _onSignedOut,);
        }
        else return _buildWaitingScreen();
        break;

      default:
        return _buildWaitingScreen();
    }
  }
}
