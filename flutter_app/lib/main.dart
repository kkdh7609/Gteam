import 'package:flutter/material.dart';
import 'package:gteams/login/login_auth.dart';
import 'package:gteams/root_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return new MaterialApp(
      title: 'Flutter login demo',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch:  Colors.grey,
      ),
      home: new RootPage(auth: new Auth())
    );
  }
}