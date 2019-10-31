import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'login_auth.dart';
import 'settings.dart';
import 'login.dart';
import 'settings_admin.dart';

class RootPage extends StatefulWidget{
  RootPage({this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus{
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN_USER,
  LOGGED_IN_ADMIN,
}

class _RootPageState extends State<RootPage>{
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";
  String _user_mail ="";

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
        _user_mail = user.email.toString();
      });
    });
    var userQuery = Firestore.instance.collection('user').where('email',isEqualTo: _user_mail).limit(1);
    userQuery.getDocuments().then((data){
      if (data.documents[0].data['isUser']) {
        print('set authstatus user');
        setState(() {
          authStatus = AuthStatus.LOGGED_IN_USER;
        });
      } else {
        print('set authstatus admin');
        setState(() {
          authStatus = AuthStatus.LOGGED_IN_ADMIN;
        });
      }
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

      case AuthStatus.LOGGED_IN_ADMIN:
        print('1');
        if (_userId.length > 0 && _userId != null){
          print('user check in');
          return new SettingPage(onSignedOut: _onSignedOut,);
        }
        else return _buildWaitingScreen();
        break;

      default:
        return _buildWaitingScreen();
    }
  }
}



/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gteams/game_create.dart';
import 'package:gteams/login_auth.dart';
import 'package:gteams/settings.dart';
import 'package:gteams/login.dart';
import 'package:gteams/sign_up.dart';
import 'services/crud.dart';
import 'settings_admin.dart';

class RootPage extends StatefulWidget{
  RootPage({this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus{
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN_USER,
  LOGGED_IN_ADMIN,
}

class _RootPageState extends State<RootPage>{
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";
  crudMedthods crudObj = new crudMedthods();
  FirebaseUser user;
  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          this.user=user;
          _userId = user?.uid;
        }
        authStatus = AuthStatus.NOT_LOGGED_IN;
        // user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void _onLoggedIn(){

    var userQuery = Firestore.instance.collection('user').where('email',isEqualTo: user.email).limit(1);
    userQuery.getDocuments().then((data){
      if(data.documents.length >0){
        if(data.documents[0].data['isUser']){
          print('set authstatus user');
          setState(() {
            authStatus = AuthStatus.LOGGED_IN_USER;
          });
        }else{
          print('set authstatus admin');
          setState(() {
            authStatus = AuthStatus.LOGGED_IN_ADMIN;
          });
        }
      }
    });
    /*
    widget.auth.getCurrentUser().then((user){
      setState((){
        _userId = user.uid.toString();
      });
    });
    setState((){
      authStatus = AuthStatus.LOGGED_IN_USER;
    });
    */
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

      case AuthStatus.LOGGED_IN_USER:
        if(user.uid.length > 0 && user.uid != null){
          print('user');
          return new SettingPage(onSignedOut: _onSignedOut,);
        }else return _buildWaitingScreen();
        break;

      case AuthStatus.LOGGED_IN_ADMIN:
        if(user.uid.length > 0 && user.uid != null){
          print('why??');
          return new SettingAdminPage(onSignedOut: _onSignedOut,);
        }else return _buildWaitingScreen();
        break;


       /* if (_userId.length > 0 && _userId != null){
          // is User를 체크해 각각 다른 페이지 리턴!
        print('1');
        var userQuery = Firestore.instance.collection('user').where('email',isEqualTo: user.email).limit(1);
        userQuery.getDocuments().then((data){
          if(data.documents.length >0){
              if(data.documents[0].data['isUser']){
                return new SettingPage(onSignedOut: _onSignedOut,);
              }else{
                print('admin');
                return new SettingAdminPage(onSignedOut: _onSignedOut,);
              }
            }
        });

        }else return _buildWaitingScreen();
        break;
        */
      default:
        return _buildWaitingScreen();
    }
  }
}
*/