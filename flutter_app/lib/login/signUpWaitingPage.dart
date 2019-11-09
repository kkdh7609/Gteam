import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gteams/login/loginTheme.dart';

class SignUpWaitingPage extends StatefulWidget {
  @override
  _SignUpWaitingPageState createState() => _SignUpWaitingPageState();
}

class _SignUpWaitingPageState extends State<SignUpWaitingPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: NotificationListener<OverscrollIndicatorNotification>(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [LoginTheme.loginGradientStart, LoginTheme.loginGradientEnd],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 1.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("Please Wait a minute",
                        style: TextStyle(fontFamily: 'Dosis', fontWeight: FontWeight.w600, color: Colors.white, fontSize: 45)),
                    Text("Make your team with G-TEAM",
                        style: TextStyle(fontFamily: 'Dosis', fontWeight: FontWeight.w400, color: Colors.white, fontSize: 25)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
