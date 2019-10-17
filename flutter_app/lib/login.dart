import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:flutter/foundation.dart";
import "package:gteams/login_auth.dart";
import "package:gteams/sign_up.dart";

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

  bool _validateAndSave(){
    final form = _formKey.currentState;

    if(form.validate()){
      form.save();
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
                  _showTextFieldTitle("Emailss"),
                  _showEmailTextField(),
                  _showTextFieldTitle("Password"),
                  _showPasswordTextField(),
                  SizedBox(height: 10.0),
                  _showFindPassword(),
                  _showLoginButton(),
                  _showGoogleLoginButton(),
                  SizedBox(height : 30.0),
                  _showRegisterSentence()
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
      margin:
      const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
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
              maxLines: 1,
              keyboardType: TextInputType.emailAddress,
              autofocus: false,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter your email',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              validator: (value) {
                if(_formMode==FormMode.LOGIN)
                  return value.isEmpty ? "Email can\'t be empty" : null;
                else if(_formMode==FormMode.GOOGLE)
                  return null;
              },
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
              maxLines: 1,
              obscureText: true,
              autofocus: false,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter your password',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              validator: (value) {
                if(_formMode==FormMode.LOGIN)
                  return value.isEmpty ? "Password can\'t be empty" : null;
                else if(_formMode==FormMode.GOOGLE)
                  return null;
              },
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
              onPressed: _validateAndSubmit,
              //onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpPage())); },
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
              onPressed: () => {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _showRegisterSentence(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Don\'t have an account ?', style: TextStyle(fontFamily: 'Montserrat')),
        SizedBox(width: 5.0),
        InkWell(
            onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpPage())); },
            child: Text('Register', style: TextStyle(color: Colors.blueAccent, fontFamily: 'Montserrat', fontWeight: FontWeight.bold, decoration: TextDecoration.underline))
        )
      ],
    );
  }
}