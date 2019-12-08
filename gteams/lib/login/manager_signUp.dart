import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gteams/login/loginTheme.dart';
import 'package:gteams/login/login_auth.dart';
import 'package:gteams/services/manager_management.dart';

class ManagerSignUpPage extends StatefulWidget {
  ManagerSignUpPage({this.auth});

  final BaseAuth auth;

  @override
  _ManagerSignUpPageState createState() => _ManagerSignUpPageState();
}

class _ManagerSignUpPageState extends State<ManagerSignUpPage> {
  final _formKey = new GlobalKey<FormState>();

  String _managerSignUpName;
  String _managerSignUpEmail;
  String _managerSignUpPassword;
  String _managerSignUpBusinessNum;
  String managerId = "";

  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeName = FocusNode();
  final FocusNode myFocusNodeBusinessNum = FocusNode();

  TextEditingController signUpEmailController = new TextEditingController();
  TextEditingController signUpNameController = new TextEditingController();
  TextEditingController signUpPasswordController = new TextEditingController();
  TextEditingController signUpBusinessNumController = new TextEditingController();

  bool _obscureTextSignUp = true;

  @override
  void initState() {
    _obscureTextSignUp = true;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: NotificationListener<OverscrollIndicatorNotification>(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height >= 775.0 ? MediaQuery.of(context).size.height : 775.0,
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
                    padding: EdgeInsets.only(top: 75.0),
                    /* show Title of SignUp */
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("G-TEAM",
                            style:
                                TextStyle(fontFamily: 'Dosis', fontWeight: FontWeight.w600, color: Colors.white, fontSize: 50)),
                        Text("Facility Manager Sign Up",
                            style:
                                TextStyle(fontFamily: 'Dosis', fontWeight: FontWeight.w400, color: Colors.white, fontSize: 25)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: new ConstrainedBox(
                      constraints: const BoxConstraints.expand(),
                      child: _showManagerSignUpScreen(context),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _showManagerSignUpScreen(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 470.0,
                  child: Column(
                    children: <Widget>[
                      /* Name */
                      Padding(
                        padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextFormField(
                            focusNode: myFocusNodeName,
                            controller: signUpNameController,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            style: TextStyle(fontFamily: "Dosis", fontSize: 16.0, color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.user,
                                color: Colors.black,
                              ),
                              hintText: "Name",
                              hintStyle: TextStyle(fontFamily: "Dosis", fontSize: 16.0),
                            ),
                            validator: (value) {
                              return value.isEmpty ? "Name can\'t be empty" : null;
                            },
                            onSaved: (value) {
                              _managerSignUpName = value;
                            }),
                      ),
                      /* Name underline */
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      /* Email */
                      Padding(
                        padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextFormField(
                          focusNode: myFocusNodeEmail,
                          controller: signUpEmailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(fontFamily: "Dosis", fontSize: 16.0, color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.envelope,
                              color: Colors.black,
                            ),
                            hintText: "Email Address",
                            hintStyle: TextStyle(fontFamily: "Dosis", fontSize: 16.0),
                          ),
                          validator: (value) {
                            return value.isEmpty ? "Email can\'t be empty" : null;
                          },
                          onSaved: (value) {
                            //print(value);
                            _managerSignUpEmail = value;
                          },
                        ),
                      ),
                      /* Email underline */
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      /* Password */
                      Padding(
                        padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextFormField(
                          focusNode: myFocusNodePassword,
                          controller: signUpPasswordController,
                          obscureText: _obscureTextSignUp,
                          style: TextStyle(fontFamily: "Dosis", fontSize: 16.0, color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.lock,
                              color: Colors.black,
                            ),
                            hintText: "Password",
                            hintStyle: TextStyle(fontFamily: "Dosis", fontSize: 16.0),
                            suffixIcon: GestureDetector(
                              onTap: _toggleSignUp,
                              child: Icon(
                                _obscureTextSignUp ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          validator: (value) {
                            return value.isEmpty ? "Password can\'t be empty" : null;
                          },
                          onSaved: (value) {
                            //print(value);
                            _managerSignUpPassword = value;
                          },
                        ),
                      ),
                      /* Password underline */
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      /* Business Number */
                      Padding(
                        padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextFormField(
                          focusNode: myFocusNodeBusinessNum,
                          controller: signUpBusinessNumController,
                          obscureText: _obscureTextSignUp,
                          style: TextStyle(fontFamily: "Dosis", fontSize: 16.0, color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.store,
                              color: Colors.black,
                            ),
                            hintText: "Business Number",
                            hintStyle: TextStyle(fontFamily: "Dosis", fontSize: 16.0),
                          ),
                          validator: (value) {
                            return value.isEmpty ? "Bussiness Number can\'t be empty" : null;
                          },
                          onSaved: (value) {
                            //print(value);
                            _managerSignUpBusinessNum = value;
                          },
                        ),
                      ),
                      /* Business Number underline */
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 450.0),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: LoginTheme.loginGradientStart,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                    BoxShadow(
                      color: LoginTheme.loginGradientEnd,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                  ],
                  gradient: new LinearGradient(
                      colors: [LoginTheme.loginGradientEnd, LoginTheme.loginGradientStart],
                      begin: const FractionalOffset(0.2, 0.2),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: MaterialButton(
                    highlightColor: Colors.transparent,
                    splashColor: LoginTheme.loginGradientEnd,
                    //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
                      child: Text(
                        "SIGN UP",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontFamily: "Dosis",
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) _formKey.currentState.save();
                      widget.auth.signUp(_managerSignUpEmail, _managerSignUpPassword).then((user) {
                        managerId = user.toString();
                        //print("Signed Up: $managerId");
                        ManagerManagement()
                            .storeNewManager(_managerSignUpEmail, context, _managerSignUpName, _managerSignUpBusinessNum, false);

                        signUpEmailController.clear();
                        signUpNameController.clear();
                        signUpPasswordController.clear();
                        signUpBusinessNumController.clear();
                      }).catchError((e) {
                        print(e);
                      });
                    }),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Are you G-TEAM User? click here.",
                style: TextStyle(decoration: TextDecoration.underline, color: Colors.white, fontSize: 16.0, fontFamily: "Dosis"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleSignUp() {
    setState(() {
      _obscureTextSignUp = !_obscureTextSignUp;
    });
  }
}
