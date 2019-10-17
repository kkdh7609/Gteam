import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:gteams/login.dart";

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _showTitle(),
              _showFieldTitle("Name"),
              _showTextField(
                  Icon(Icons.person_outline, color: Colors.grey),
                  "Enter your name"
              ),
              _showFieldTitle("Email"),
              _showTextField(
                  Icon(Icons.email, color: Colors.grey),
                  "Enter your email"
              ),
              _showFieldTitle("Password"),
              _showTextField(
                  Icon(Icons.lock_open, color: Colors.grey),
                  "Enter your password"
              ),
              SizedBox(height: 10.0),
              _showButton(
                Icon(Icons.redo, color: Colors.blue),
                "Create My Account",
                Colors.blue
              ),
              _showButton(
                Icon(Icons.undo, color: Color(0xff3B5998)),
                "Back to the Login Page",
                Color(0xff3B5998)
              ),
              SizedBox(height : 30.0),
            ],
          )
      ),
    );
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

  Widget _showFieldTitle(String title){
    return Padding(
      padding: const EdgeInsets.only(left: 40.0),
      child: Text(
        title,
        style: TextStyle(color: Colors.grey, fontSize: 16.0),
      ),
    );
  }

  Widget _showTextField(Icon icons, String hintText){
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
              child: icons
          ),
          Container(
            height: 30.0,
            width: 1.0,
            color: Colors.grey.withOpacity(0.5),
            margin: const EdgeInsets.only(left: 00.0, right: 10.0),
          ),
          new Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _showButton(Icon icons, String buttonText, Color buttonColor){
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: FlatButton(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              splashColor: buttonColor,
              color: buttonColor,
              child: new Row(
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      buttonText,
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
                        child: icons,
                        onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage())); },
                      ),
                    ),
                  )
                ],
              ),
              onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage())); },
            ),
          ),
        ],
      ),
    );
  }

}
