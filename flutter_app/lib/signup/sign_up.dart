import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gteams/login/login_auth.dart';
import 'package:gteams/services/user_mangement.dart';

class SignUpPage extends StatefulWidget {

  BaseAuth _auth;
  bool _isUser;
  SignUpPage(bool isAdmin, BaseAuth auth){
    this._isUser=isAdmin;
    this._auth=auth;
  }
  @override
  _SignUpPageState createState() => _SignUpPageState(_isUser);
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = new GlobalKey<FormState>();
  bool _isUser;
  _SignUpPageState(bool isAdmin){
    this._isUser=isAdmin;
  }
  String _email;
  String _password;
  String _name;
  String userId = "";

  @override
  Widget build(BuildContext context) {
    if(_isUser){ // Check User or Admin
      return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
            child: new Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _showTitle(),
                    _showTextFieldTitle("Name"),
                    _showNameTextField(),
                    _showTextFieldTitle("Email"),
                    _showEmailTextField(),
                    _showTextFieldTitle("Password"),
                    _showPasswordTextField(),
                    SizedBox(height: 10.0),
                    _showCreateAccountButton(),
                    _showBackButton(),
                    SizedBox(height : 30.0),
                  ],
                )
            )
        ),
      );
    }else{ // IF admin show admin signUp page
      return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
            child: new Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _showTitle(),
                    _showTextFieldTitle("Name"),
                    _showNameTextField(),
                    _showTextFieldTitle("Email"),
                    _showEmailTextField(),
                    _showTextFieldTitle("Password"),
                    _showPasswordTextField(),
                    //ToDo: Edit 사업자 번호 TextField..
                    _showTextFieldTitle("사업자번호"),
                    _showPasswordTextField(),
                    SizedBox(height: 10.0),
                    _showCreateAccountButton(),
                    _showBackButton(),
                    SizedBox(height : 30.0),
                  ],
                )
            )
        ),
      );
    }
  }

  Widget _showTitle(){
    return Container(
      child: Stack(
          children: <Widget>[
            Container(
                padding: EdgeInsets.fromLTRB(15.0, 70.0, 0.0, 50.0),
                child: Text('G-TEAM Sign-Up', style: TextStyle(fontSize: 45.0, fontWeight: FontWeight.bold, color: Colors.black))
            ),
          ]
      ),
    );
  }

  Widget _showTextFieldTitle(String title){
    return Padding(
      padding: const EdgeInsets.only(left: 40.0),
      child: Text(
        title,
        style: TextStyle(color: Colors.grey, fontSize: 16.0),
      ),
    );
  }

  Widget _showNameTextField(){
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
              child: Icon(Icons.person_outline, color: Colors.grey)
          ),
          Container(
            height: 30.0,
            width: 1.0,
            color: Colors.grey.withOpacity(0.5),
            margin: const EdgeInsets.only(left: 00.0, right: 10.0)
          ),
          new Expanded(
            child: new TextFormField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Enter your name",
                hintStyle: TextStyle(color: Colors.grey),
              ),
              validator: (value) {
                return value.isEmpty ? "Name can\'t be empty" : null;
              },
              onSaved: (value) { _name = value; },
            ),
          )
        ],
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
              child: Icon(Icons.email, color: Colors.grey)
          ),
          Container(
              height: 30.0,
              width: 1.0,
              color: Colors.grey.withOpacity(0.5),
              margin: const EdgeInsets.only(left: 00.0, right: 10.0)
          ),
          new Expanded(
            child: new TextFormField(
              maxLines: 1,
              keyboardType: TextInputType.emailAddress,
              autofocus: false,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter your email..',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              validator: (value) {
                return value.isEmpty ? "eEmail can\'t be empty" : null;
              },
              onSaved: (value) {
                print(value);
                _email = value;},
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
              child: Icon(Icons.lock_open, color: Colors.grey)
          ),
          Container(
              height: 30.0,
              width: 1.0,
              color: Colors.grey.withOpacity(0.5),
              margin: const EdgeInsets.only(left: 00.0, right: 10.0)
          ),
          new Expanded(
            child: new TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Enter your password",
                hintStyle: TextStyle(color: Colors.grey),
              ),
              validator: (value) {
                return value.isEmpty ? "password can\'t be empty" : null;
              },
              onSaved: (value) { _password = value; },
            ),
          )
        ],
      ),
    );
  }

  Widget _showCreateAccountButton(){
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
                      "Create My Account",
                      style: TextStyle(fontSize : 17.0, color: Colors.white),
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
                        child: Icon(Icons.redo, color: Colors.blue),
                        onPressed: () {
                          if(_formKey.currentState.validate())
                            _formKey.currentState.save();
                          widget._auth.signUp(_email, _password).then((user){
                            userId=user.toString();
                            print("Signed Up: $userId");
                            UserManagement().storeNewUser(_email, context,_name,_isUser);
                          }).catchError((e){
                            print(e);
                          });
                          Navigator.pop(context); },
                      ),
                    ),
                  )
                ],
              ),
              onPressed: () {
                if(_formKey.currentState.validate())
                  _formKey.currentState.save();
                FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                    email: _email, password: _password)
                    .then((user) {
                      UserManagement().storeNewUser(_email, context,_name,_isUser); // Add new user info at 'user' collection
                 }).catchError((e) {
                  print(e);
                });
                print(_email);
                Navigator.pop(context); },
            ),
          ),
        ],
      ),
    );
  }

  Widget _showBackButton(){
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
                      "Back to the Login Page",
                      style: TextStyle(fontSize : 17.0, color: Colors.white),
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
                        child: Icon(Icons.undo, color: Color(0xff3B5998)),
                        onPressed: () { Navigator.pop(context); },
                      ),
                    ),
                  )
                ],
              ),
              onPressed: () { Navigator.pop(context); },
            ),
          ),
        ],
      ),
    );
  }

}
