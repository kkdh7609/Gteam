import 'package:flutter/material.dart';
import 'package:gteams/services/crud.dart';
import 'package:gteams/menu/main_menu.dart';
import 'package:gteams/login/login_auth.dart';
import 'package:gteams/setting/settings_admin.dart';
import 'package:gteams/setting/settings_user.dart';
import 'package:gteams/login/login.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN_CHECK,
  LOGGED_IN_USER,
  LOGGED_IN_ADMIN,
}

class _RootPageState extends State<RootPage> {
  crudMedthods crudObj = new crudMedthods();

  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";
  String _userMail = "";
  String _userDocID = "";
  bool _infoStatus = false;

  @override
  void initState() {
    //print("initState");
    super.initState();
    widget.auth.getCurrentUser().then(
      (user) {
        setState(
          () {
            if (user != null) {
              _userId = user?.uid;
            }
            authStatus = AuthStatus.NOT_LOGGED_IN;
            //user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return _buildWaitingScreen();
        break;

      case AuthStatus.NOT_LOGGED_IN:
        //print('NOT_LOGGED_IN');
        _isUser();
        return new LoginPage(
          auth: widget.auth,
          onSignedIn: onLoggedIn,
        );
        break;

      case AuthStatus.LOGGED_IN_CHECK:
        //print("LOGGED_IN_CHECK");
        _isUser();
        return _buildWaitingScreen();
        break;

      case AuthStatus.LOGGED_IN_USER:
        print('user check in');
        if (!_infoStatus) {
          // 초기로그인 일때
          print("info_status : $_infoStatus");
          return new SettingUser(
            onSignedOut: _onSignedOut,
            userDocID: _userDocID,
          );
        } else {
          //초기로그인이 아닐때
          print("info_status : $_infoStatus");
          return MainMenuPage(
            onSignedOut: _onSignedOut,
          );
          //return new HomePage(onSignedOut: _onSignedOut,);
        }
        break;

      case AuthStatus.LOGGED_IN_ADMIN:
        print('admin check in');
        return new SettingAdminPage(
          onSignedOut: _onSignedOut,
        );
        break;

      default:
        return _buildWaitingScreen();
    }
  }

  void onLoggedIn() {
    //print("ON_LOGGED_IN");
    widget.auth.getCurrentUser().then(
      (user) {
        setState(
          () {
            _userId = user.uid.toString();
            _userMail = user.email.toString();
          },
        );
      },
    );
    setState(() {
      authStatus = AuthStatus.LOGGED_IN_CHECK;
    });
  }

  void _onSignedOut() {
    setState(
      () {
        authStatus = AuthStatus.NOT_LOGGED_IN;
        _userId = "";
        _userMail = "";
      },
    );
  }

  void _isUser() {
    // Check User or Admin
    if (_userId != null && _userId.length > 0) {
      var userQuery = crudObj.getDocumentByWhere('user', 'email', _userMail);
      setState(
        () {
          userQuery.then(
            (data) {
              if(data.documents.length >= 1) {
                if (data.documents[0].data['isUser']) {
                  print('set authstatus user');
                  setState(
                        () {
                      authStatus = AuthStatus.LOGGED_IN_USER;
                    },
                  );
                } else {
                  print('set authstatus manager');
                  setState(
                        () {
                      authStatus = AuthStatus.LOGGED_IN_ADMIN;
                    },
                  );
                }
              }
              setState(
                () {
                  if(data.documents.length >= 1){
                    _infoStatus = data.documents[0].data['info_status'];
                    _userDocID = data.documents[0].documentID;
                  }
                },
              );
            },
          );
        },
      );
    }
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
