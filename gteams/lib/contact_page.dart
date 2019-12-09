import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gteams/login/loginTheme.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: NotificationListener<OverscrollIndicatorNotification>(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
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
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 6),
                child: Text("G-TEAM",
                    style: TextStyle(fontFamily: 'Dosis', fontWeight: FontWeight.w600, color: Colors.white, fontSize: 60)),
              ),
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 20),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("2019 Ajou Software Capstone",
                          style: TextStyle(fontFamily: 'Dosis', fontWeight: FontWeight.w600, color: Colors.white, fontSize: 25)),
                      Text("Made by BAAM-DDOKKAEBI",
                          style: TextStyle(fontFamily: 'Dosis', fontWeight: FontWeight.w400, color: Colors.white, fontSize: 20)),
                    ],
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 20),
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 10),
                      child : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("201420877 Dohyun Kim",
                              style: TextStyle(fontFamily: 'Dosis', fontWeight: FontWeight.w400, color: Colors.white, fontSize: 25)),
                          Text("201420899 Hakjun Kim",
                              style: TextStyle(fontFamily: 'Dosis', fontWeight: FontWeight.w400, color: Colors.white, fontSize: 25)),
                          Text("201420969 Yeungun Kim",
                              style: TextStyle(fontFamily: 'Dosis', fontWeight: FontWeight.w400, color: Colors.white, fontSize: 25)),
                          Text("201420907 Wooil Ahn",
                              style: TextStyle(fontFamily: 'Dosis', fontWeight: FontWeight.w400, color: Colors.white, fontSize: 25)),
                        ],
                      )
                  )
              ),
              Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 20),
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 10),
                      child : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Thank you for using our app!",
                              style: TextStyle(fontFamily: 'Dosis', fontWeight: FontWeight.w400, color: Colors.white, fontSize: 30)),
                        ],
                      )
                  )
              ),
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 20),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  //height: MediaQuery.of(context).size.width * 0.76,
                  child: RaisedButton(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24.0)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Text(
                        "Back to the Main Menu Page",
                        style: TextStyle(
                            fontFamily: 'Dosis',
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Color(0xff20253d)),
                      ),
                    ),
                  ),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
