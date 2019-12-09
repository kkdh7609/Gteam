import 'package:flutter/material.dart';
import 'package:gteams/root_page.dart';
import 'package:gteams/login/login_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xff20253d),
        accentColor: Color(0xff20253d),
        fontFamily: 'Dosis',
      ),
      home: new RootPage(auth: new Auth()),
      debugShowCheckedModeBanner: false,
    );
  }
}
