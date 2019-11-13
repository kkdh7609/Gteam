import 'package:flutter/material.dart';
import 'package:gteams/root_page.dart';
import 'package:gteams/login/login_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xff3B5998),
        accentColor: Color(0xff3B5998),
        fontFamily: 'Dosis',
      ),
      home: new RootPage(auth: new Auth()),
      debugShowCheckedModeBanner: false,
    );
  }
}
