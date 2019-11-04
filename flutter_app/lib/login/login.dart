import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:flutter/foundation.dart";
import "package:gteams/login/login_auth.dart";
import "package:gteams/signup/sign_up.dart";
import 'package:gteams/validator/login_validator.dart';
import 'package:gteams/game_join/game_join.dart';
import 'package:gteams/root_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onSignedIn});

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  _LoginPageState createState() => _LoginPageState();
}

enum FormMode {LOGIN, GOOGLE, SIGNUP}

class _LoginPageState extends State<LoginPage> {
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage;

  FormMode _formMode = FormMode.LOGIN;
  bool _isIos;
  bool _isLoading;
  bool isAdmin=false;
  bool _isAvailable;      // for checking if we can act now
  String _success = "";

  bool _validateAndSave(){
    final form = _formKey.currentState;

 /* unsolved conflict 
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }
*/
    if(_formMode == FormMode.LOGIN && form.validate()){
      form.save();
      return true;
    }

    if(_formMode == FormMode.GOOGLE){
      return true;
    }
    return false;
  }

  void _validateAndSubmit() async{
    setState((){
      _errorMessage = "";
      _isLoading = true;
    });
    if (_validateAndSave()){
      String userId = "";
      try{
        if(_formMode == FormMode.LOGIN){
          userId = await widget.auth.signIn(_email, _password);
          print("Signed in: $userId");
        }
        else if(_formMode == FormMode.GOOGLE){
          userId = await widget.auth.signInWithGoogle();
          print("Signed in: $userId");
        }
        else{
          userId = await widget.auth.signUp(_email, _password);
          print("Signed up user: $userId");
        }
        setState((){
          _success = "success";
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null && (_formMode == FormMode.LOGIN || _formMode == FormMode.GOOGLE )){
          print("check on signed in");
          widget.onSignedIn();
        }
      } catch (e){
        print('Error: $e');
        setState((){
          _isLoading = false;
          _success = "";
          if (_isIos){
            _errorMessage = e.details;
          }
          else{
            _errorMessage = e.message;
          }
        });
      }

    }
    setState((){
      _isLoading = false;
    });
  }

  @override
  void initState(){
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;

    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
          child: new Form(
              key: _formKey,
              child : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _showTitle(),
                  _showTextFieldTitle("Email"),
                  _showEmailTextField(),
                  _showTextFieldTitle("Password"),
                  _showPasswordTextField(),
                  SizedBox(height: 10.0),
                  _showFindPassword(),
                  _showLoginButton(),
                  _showGoogleLoginButton(),
                  SizedBox(height : 30.0),
                  _showRegisterSentence('일반 사용자 회원가입',true),
                  _showRegisterSentence('시설 관리자 회원가입?',false)
                ],
              )
          )
      ),
    );
  }

  Widget _showTitle(){
    return Container(
      child: Stack(
          children: <Widget>[
            Container(
                padding: EdgeInsets.fromLTRB(15.0, 70.0, 0.0, 0.0),
                child: Text('G-TEAM Login', style: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold, color: Colors.black))
            ),
            Container(
                padding: EdgeInsets.fromLTRB(130.0, 130.0, 0.0, 35.0),
                child: Text('Make your team with G-TEAM', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black))
            ),
          ]
      ),
    );
  }

  Widget _showTextFieldTitle(String title){
    return  Padding(
      padding: const EdgeInsets.only(left: 40.0),
      child: Text(
        title,
        style: TextStyle(color: Colors.grey, fontSize: 16.0),
      ),
    );
  }

  Widget _showEmailTextField(){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: <Widget>[
          new Padding(
            padding:
            EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Icon(
              Icons.email,
              color: Colors.grey,
            ),
          ),
          Container(
            height: 30.0,
            width: 1.0,
            color: Colors.grey.withOpacity(0.5),
            margin: const EdgeInsets.only(left: 00.0, right: 10.0),
          ),
          new Expanded(
            child: new TextFormField(
              key: new Key('email'),
              maxLines: 1,
              autofocus: false,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter your email',
                hintStyle: TextStyle(color: Colors.grey),
                // errorStyle: TextStyle(color: Colors.red),       // we can change error message style using this
              ),
              validator: ValidationMixin.validateEmail,
              onSaved: (value) { _email = value; },
            ),
          )
        ],
      ),
    );
  }

  Widget _showPasswordTextField(){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin:
      const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: <Widget>[
          new Padding(
            padding:
            EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Icon(
              Icons.lock_open,
              color: Colors.grey,
            ),
          ),
          Container(
            height: 30.0,
            width: 1.0,
            color: Colors.grey.withOpacity(0.5),
            margin: const EdgeInsets.only(left: 00.0, right: 10.0),
          ),
          new Expanded(
            child: TextFormField(
              key: new Key('pw'),
              maxLines: 1,
              obscureText: true,
              autofocus: false,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter your password',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              validator: ValidationMixin.validatePW,
              onSaved: (value) => _password = value.trim(),
            ),
          )
        ],
      ),
    );
  }

  Widget _showFindPassword(){
    return Container(
      alignment: Alignment(1.0, 1.0),
      padding: EdgeInsets.only(top: 15.0, right: 30.0),
      child: InkWell(
          onTap: () { },
          child: Text('Forgot Password', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontFamily: 'Montserrat', decoration: TextDecoration.underline))
      ),
    );
  }

  Widget _showLoginButton(){
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: FlatButton(
              key: new Key('login_btn'),
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              splashColor: Colors.blue,
              color: Colors.blue,
              child: new Row(
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      "LOGIN",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  new Expanded(
                    child: Container(),
                  ),
                  new Transform.translate(
                    offset: Offset(15.0, 0.0),
                    child: new Container(
                      padding: const EdgeInsets.all(5.0),
                      child: FlatButton(
                        key: new Key('round_login_btn'),
                        shape: new RoundedRectangleBorder(
                            borderRadius:
                            new BorderRadius.circular(28.0)),
                        splashColor: Colors.white,
                        color: Colors.white,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          _formMode = FormMode.LOGIN;
                          _validateAndSubmit();
                        },
                      ),
                    ),
                  )
                ],
              ),
              onPressed:(){
                _formMode = FormMode.LOGIN;
                _validateAndSubmit();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _showGoogleLoginButton(){
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: FlatButton(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              splashColor: Color(0xff3B5998),
              color: Color(0xff3B5998),
              child: new Row(
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      "LOGIN WITH GOOGLE",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  new Expanded(
                    child: Container(),
                  ),
                  new Transform.translate(
                    offset: Offset(15.0, 0.0),
                    child: new Container(
                      padding: const EdgeInsets.all(5.0),
                      child: FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius:
                            new BorderRadius.circular(28.0)),
                        splashColor: Colors.white,
                        color: Colors.white,
                        child: ImageIcon(
                            AssetImage('assets/google.png'), color: Color(0xff3B5998)),
                        onPressed: () {
                          _formMode = FormMode.GOOGLE;
                          _validateAndSubmit();
                        },
                      ),
                    ),
                  )
                ],
              ),
              onPressed: (){
                _formMode = FormMode.GOOGLE;
                _validateAndSubmit();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _showRegisterSentence(String show_text,bool isUser){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        Text(show_text, style: TextStyle(fontFamily: 'Montserrat')),
        SizedBox(width: 5.0),
        InkWell(
            onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpPage(isUser,widget.auth))); },
            child: Text('Register', style: TextStyle(color: Colors.blueAccent, fontFamily: 'Montserrat', fontWeight: FontWeight.bold, decoration: TextDecoration.underline))
        ),
        SizedBox(width: 5.0),
        InkWell(
            onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context)=>GameJoinPage())); },
            child: Text('Game_Join', style: TextStyle(color: Colors.blueAccent, fontFamily: 'Montserrat', fontWeight: FontWeight.bold, decoration: TextDecoration.underline))
        )
      ],
    );
  }
}

