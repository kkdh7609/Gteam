import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gteams/login/loginTheme.dart';


class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height >= 775.0 ? MediaQuery.of(context).size.height : 775.0,
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [LoginTheme.loginGradientStart, LoginTheme.loginGradientEnd],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        )
    );
  }
}
