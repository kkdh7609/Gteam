import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gteams/pay/payMethod.dart';

class ManagePay extends StatefulWidget {
  @override
  _ManagePayState createState() => _ManagePayState();
}

class _ManagePayState extends State<ManagePay> {

  int fund = 0;

  @override
  void initState() {
    super.initState();
    PayMethods().getFund().then((data){
      setState(() {
        fund = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PayPage',
      theme: ThemeData(
        fontFamily: 'Montserrat',
        buttonColor: Color(0xff68d69d),
        primaryColor: Color(0xff20253d),
        accentColor: Color(0xffcdd2de),
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 25, fontWeight: FontWeight.w700, color: Colors.white, fontFamily: 'Dosis'),
          display1: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Dosis'),
          subhead: TextStyle(fontSize: 19, fontWeight: FontWeight.w200, color: Colors.black, fontFamily: 'Dosis'),
          title:
          TextStyle(fontSize: 25, fontWeight: FontWeight.w100, color: Colors.white, letterSpacing: 1.3, fontFamily: 'Dosis'),
        ),
      ),
      home: Scaffold(
        backgroundColor: Theme.of(context).accentColor,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              /* background gradient */
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [const Color(0xFF9E9E9E), const Color(0xFFFAFAFA)],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  onTap: () { Navigator.pop(context); },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0
                    ),
                    child: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
              ),
              /* Total Point View */
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.30,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft, // 0xFF424242
                      colors: [const Color(0xff20253d), const Color(0xFF424242)],
                    ),
                  ),
                  padding: EdgeInsets.only(top: 30.0, left: 21.0, right: 21.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              InkWell(
                                borderRadius: BorderRadius.all(Radius.circular(32.0)),
                                onTap: () { Navigator.pop(context); },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 40),
                                  child: Icon(Icons.arrow_back, color: Colors.white),
                                ),
                              ),
                              Text("Your Point",
                                  style:
                                  TextStyle(fontSize: 27, fontWeight: FontWeight.w700, color: Colors.white, fontFamily: 'Dosis')),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(fund.toString() + " P",
                                  style: TextStyle(
                                      fontSize: 80, fontWeight: FontWeight.w700, color: Colors.white, fontFamily: 'Qwigley')),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Divider(color: Colors.white, thickness: 2),
                    ],
                  ),
                ),
              ),
              /* Select Charge Point View */
              Positioned(
                top: MediaQuery.of(context).size.height * 0.3,
                bottom: 0,
                left: 0,
                right: 0,
                child: ListView(
                  children: <Widget>[
                    InkWell(
                        onTap: () {},
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.13,
                          margin: EdgeInsets.symmetric(vertical: 9.0, horizontal: 21.0),
                          decoration: BoxDecoration(
                            color: Color(0xff20253d),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          padding: EdgeInsets.all(15),
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                color: Colors.white,
                                icon: Icon(Icons.monetization_on, size: 40),
                                onPressed: () {},
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Point Refunds",
                                    style: TextStyle(
                                        fontSize: 15, fontFamily: 'Dosis', color: Colors.white, fontWeight: FontWeight.w800),
                                  ),
                                  Text(
                                    "포인트 환급받기",
                                    style: TextStyle(
                                        fontSize: 23, fontFamily: 'Dosis', color: Colors.white, fontWeight: FontWeight.w800),
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}