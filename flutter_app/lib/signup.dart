import 'package:flutter/material.dart';
import 'package:gteams/login.dart';
import 'package:gteams/authentication.dart';
import 'package:gteams/settings.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up test page"),),
    );
  }
}
