import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gteams/services/user_mangement.dart';
import 'package:gteams/login/loginTheme.dart';
import 'package:gteams/login/painter.dart';
import 'package:gteams/login/login_auth.dart';
import 'package:gteams/login/manager_signUp.dart';
import 'package:gteams/login/signUpWaitingPage.dart';
import 'package:gteams/validator/login_validator.dart';
import 'package:gteams/util/pushPostUtil.dart';
import 'package:gteams/util/alertUtil.dart';
import 'package:http/http.dart';


class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onSignedIn});

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  _LoginPageState createState() => new _LoginPageState();
}

enum FormMode { LOGIN, GOOGLE, SIGNUP }

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final _formKey = new GlobalKey<FormState>();

  String _loginEmail;
  String _loginPassword;
  String _errorMessage;

  String _signUpName;
  String _signUpEmail;
  String _signUpPassword;

  String userId = "";
  FormMode _formMode = FormMode.LOGIN;
  bool isAdmin = false;
  bool _isLoading;
  bool _isIos = Platform.isIOS;
  String _success = "";

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeName = FocusNode();

  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  TextEditingController signUpEmailController = new TextEditingController();
  TextEditingController signUpNameController = new TextEditingController();
  TextEditingController signUpPasswordController = new TextEditingController();

  bool _obscureTextLogin = true;
  bool _obscureTextSignUp = true;

  PageController _pageController;

  Color left = Colors.black;
  Color right = Colors.white;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _pageController = PageController();
  }

  @override
  void dispose() {
    myFocusNodePassword.dispose();
    myFocusNodeEmail.dispose();
    myFocusNodeName.dispose();
    _pageController?.dispose();
    super.dispose();
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
                  /* Team Title */
                  Padding(
                      padding: EdgeInsets.only(top: 75.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text("G-TEAM",
                              style:
                                  TextStyle(fontFamily: 'Dosis', fontWeight: FontWeight.w600, color: Colors.white, fontSize: 50)),
                          Text("Make Your Team Now",
                              style:
                                  TextStyle(fontFamily: 'Dosis', fontWeight: FontWeight.w400, color: Colors.white, fontSize: 25)),
                        ],
                      )),
                  /* Login | Sign-up button */
                  Padding(
                    padding: EdgeInsets.only(top: 40.0),
                    child: _showMenuBar(context),
                  ),
                  /* Different Page View according to button */
                  Expanded(
                    flex: 2,
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (i) {
                        if (i == 0) {
                          setState(() {
                            right = Colors.white;
                            left = Colors.black;
                          });
                        } else if (i == 1) {
                          setState(() {
                            right = Colors.black;
                            left = Colors.white;
                          });
                        }
                      },
                      children: <Widget>[
                        new ConstrainedBox(
                          constraints: const BoxConstraints.expand(),
                          child: _showLoginScreen(context),
                        ),
                        new ConstrainedBox(
                          constraints: const BoxConstraints.expand(),
                          child: _showSignUpScreen(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Response> postTest() async{
    Map<String, String> body = {"type" : '3', "target" : "fNycl8GHUaqMlccoR8t8"};
    Response response = await post('http://45.119.145.96/api/push/', body: body);
    return response;
  }

  Widget _showMenuBar(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: Color(0x552B2B2B),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(pageController: _pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignInButtonPress,
                child: Text(
                  "Login",
                  style: TextStyle(color: left, fontSize: 16.0, fontFamily: "Dosis", fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Container(height: 33.0, width: 1.0, color: Colors.white),
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignUpButtonPress,
                child: Text(
                  "Sign-up",
                  style: TextStyle(color: right, fontSize: 16.0, fontFamily: "Dosis", fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _showLoginScreen(BuildContext context) {
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
                  height: 220.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 20.0, bottom: 10.0, left: 25.0, right: 25.0),
                        child: TextFormField(
                          key: new Key('email'),
                          validator: ValidationMixin.validateEmail,
                          onSaved: (value) {
                            _loginEmail = value;
                          },
                          focusNode: myFocusNodeEmailLogin,
                          controller: loginEmailController,
                          keyboardType: TextInputType.emailAddress,
                          inputFormatters: [LengthLimitingTextInputFormatter(30)],
                          style: TextStyle(fontFamily: "Dosis", fontSize: 16.0, color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.envelope,
                              color: Colors.black,
                              size: 22.0,
                            ),
                            hintText: "Email Address",
                            hintStyle: TextStyle(fontFamily: "Dosis", fontSize: 17.0),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 0.5,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0, bottom: 10.0, left: 25.0, right: 25.0),
                        child: TextFormField(
                          key: new Key('pw'),
                          validator: ValidationMixin.validatePW,
                          onSaved: (value) => _loginPassword = value.trim(),
                          focusNode: myFocusNodePasswordLogin,
                          controller: loginPasswordController,
                          obscureText: _obscureTextLogin,
                          style: TextStyle(fontFamily: "Dosis", fontSize: 16.0, color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.lock,
                              size: 22.0,
                              color: Colors.black,
                            ),
                            hintText: "Password",
                            hintStyle: TextStyle(fontFamily: "Dosis", fontSize: 17.0),
                            suffixIcon: GestureDetector(
                              onTap: _toggleLogin,
                              child: Icon(
                                _obscureTextLogin ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      )
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 210.0),
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
                  key: new Key('login_btn'),
                  highlightColor: Colors.transparent,
                  splashColor: LoginTheme.loginGradientEnd,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
                    child: Text(
                      "LOGIN",
                      style: TextStyle(color: Colors.white, fontSize: 25.0, fontFamily: "Dosis"),
                    ),
                  ),
                  onPressed: () {
                    _formMode = FormMode.LOGIN;
                    _validateAndSubmit();
                  },
                ),
              ),
            ],
          ),
          /*Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: FlatButton(
                onPressed: () async {
                  var t = await postTest();
                  print(t.body);
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpWaitingPage()));
                },
                child: Text(
                  "Forgot Password?",
                  style:
                      TextStyle(decoration: TextDecoration.underline, color: Colors.white, fontSize: 16.0, fontFamily: "Dosis"),
                )),
          ),*/
          Padding(
            padding: EdgeInsets.only(top: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [
                          Colors.white10,
                          Colors.white,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  width: 100.0,
                  height: 1.0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                    "Or",
                    style: TextStyle(color: Colors.white, fontSize: 16.0, fontFamily: "Dosis"),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [
                          Colors.white,
                          Colors.white10,
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 1.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  width: 100.0,
                  height: 1.0,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 3.0),
                child: GestureDetector(
                  onTap: () {
                    _formMode = FormMode.GOOGLE;
                    _validateAndSubmit();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(9.0),
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: new Icon(
                      FontAwesomeIcons.google,
                      color: Color(0xFF0084ff),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _showSignUpScreen(BuildContext context) {
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
                  height: 300.0,
                  child: Column(
                    children: <Widget>[
                      /* Name */
                      Padding(
                        padding: EdgeInsets.only(top: 20.0, bottom: 10.0, left: 25.0, right: 25.0),
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
                            inputFormatters: [LengthLimitingTextInputFormatter(10)],
                            validator: (value) {
                              return value.isEmpty ? "Name can\'t be empty" : null;
                            },
                            onSaved: (value) {
                              _signUpName = value;
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
                        padding: EdgeInsets.only(top: 20.0, bottom: 10.0, left: 25.0, right: 25.0),
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
                            print(value);
                            _signUpEmail = value;
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
                        padding: EdgeInsets.only(top: 20.0, bottom: 5.0, left: 25.0, right: 25.0),
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
                            print(value);
                            _signUpPassword = value;
                          },
                        ),
                      ),
                      /* Password underline */
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
                margin: EdgeInsets.only(top: 290.0),
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
                      widget.auth.signUp(_signUpEmail, _signUpPassword).then((user) {
                        userId = user.toString();
                        print("Signed Up: $userId");
                        UserManagement().storeNewUser(_signUpEmail, context, _signUpName, true,false);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpWaitingPage()));
                        signUpEmailController.clear();
                        signUpNameController.clear();
                        signUpPasswordController.clear();
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ManagerSignUpPage(auth: widget.auth)));
                },
                child: Text(
                  "Are you Facility Manager? click here.",
                  style:
                      TextStyle(decoration: TextDecoration.underline, color: Colors.white, fontSize: 16.0, fontFamily: "Dosis"),
                )),
          ),
        ],
      ),
    );
  }

  void _onSignInButtonPress() {
    _pageController.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController?.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  void _toggleSignUp() {
    setState(() {
      _obscureTextSignUp = !_obscureTextSignUp;
    });
  }

  bool _validateAndSave() {
    final form = _formKey.currentState;

    /* unsolved conflict
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }
*/
    if (_formMode == FormMode.LOGIN && form.validate()) {
      form.save();
      return true;
    }

    if (_formMode == FormMode.GOOGLE) {
      return true;
    }
    return false;
  }

  void _validateAndSubmit() async {
    setState(
      () {
        _errorMessage = "";
        _isLoading = true;
      },
    );
    if (_validateAndSave()) {
      String userId = "";
      try {
        if (_formMode == FormMode.LOGIN) {
          userId = await widget.auth.signIn(_loginEmail, _loginPassword);
          print("Signed in: $userId");
        } else if (_formMode == FormMode.GOOGLE) {
          FirebaseUser userInfo = await widget.auth.signInWithGoogle();
          //구글 로그인시 유저 정보 받아서 유저 collection에 추가..
          Firestore.instance.collection('user').where('email',isEqualTo: userInfo.email).getDocuments().then((document){
            if(document.documents.length == 0){
              UserManagement().storeNewUser(userInfo.email, context, userInfo.displayName, true,true);
            }else{
              print("signed wiht $userInfo");
              print("check on signed in");
              widget.onSignedIn();
            }
          });
        } else {
          userId = await widget.auth.signUp(_loginEmail, _loginPassword);
          print("Signed up user: $userId");
        }
        setState(
          () {
            _success = "success";
            _isLoading = false;
          },
        );
        print("userid lenght : "+ userId.length.toString());
        if (userId.length > 0 && userId != null && _formMode == FormMode.LOGIN) {
          print("check on signed in");
          widget.onSignedIn();
        }


      } catch (e) {
        print('Error: $e');
        String errorMsg;
        if(Platform.isAndroid){
          if(e.message == 'There is no user record corresponding to this identifier. The user may have been deleted.' || e.message == 'The password is invalid or the user does not have a password.'){
            errorMsg = "잘못된 아이디 혹은 비밀번호입니다. 다시 한 번 확인해 주세요.";
          }
          else if(e.message == 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.'){
            errorMsg = "네트워크 연결을 확인해 주세요.";
          }
          else{
            errorMsg = "알 수 없는 오류가 발생했습니다. 다시 시도해 주세요";
          }
        }
        else if(Platform.isIOS){
          if(e.code == 'Error 17011' || e.code == 'Error 17009'){
            errorMsg = "잘못된 아이디 혹은 비밀번호입니다. 다시 한 번 확인해 주세요.";
          }
          else if(e.code == 'Error 17020'){
            errorMsg = "네트워크 연결을 확인해 주세요.";
          }
          else{
            errorMsg = "알 수 없는 오류가 발생했습니다. 다시 시도해 주세요";
          }
        }

        showAlertDialog("로그인 실패", errorMsg, context);
        setState(
          () {
            _isLoading = false;
            _success = "";
            if (_isIos) {
              _errorMessage = e.details;
            } else {
              _errorMessage = e.message;
            }
          },
        );
      }
    }
    setState(
      () {
        _isLoading = false;
      },
    );
  }
}
