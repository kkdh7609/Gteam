import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gteams/pay/iamport_payment.dart';

enum Cost { ONE_THOUSANDS, FIVE_THOUSANDS, TEN_THOUSANDS }

class PayPage extends StatefulWidget {
  @override
  _PayPageState createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  Cost _selectedCost = null;

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
                          Text("Total Point of G-TEAM",
                              style:
                                  TextStyle(fontSize: 27, fontWeight: FontWeight.w700, color: Colors.white, fontFamily: 'Dosis')),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("50,000 P",
                                  style: TextStyle(
                                      fontSize: 55, fontWeight: FontWeight.w700, color: Colors.white, fontFamily: 'Dosis')),
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
                  top: MediaQuery.of(context).size.height * 0.32,
                  left: 30,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Radio(
                          activeColor: Colors.black,
                          value: Cost.ONE_THOUSANDS,
                          groupValue: _selectedCost,
                          onChanged: (Cost value) {
                            setState(() {
                              _selectedCost = value;
                            });
                          },
                        ),
                        Text("1,000원", style: TextStyle(fontSize: 20, fontFamily: 'Dosis', fontWeight: FontWeight.w500)),
                        Radio(
                          activeColor: Colors.black,
                          value: Cost.FIVE_THOUSANDS,
                          groupValue: _selectedCost,
                          onChanged: (Cost value) {
                            setState(() {
                              _selectedCost = value;
                            });
                          },
                        ),
                        Text("5,000원", style: TextStyle(fontSize: 20, fontFamily: 'Dosis', fontWeight: FontWeight.w500)),
                        Radio(
                          activeColor: Colors.black,
                          value: Cost.TEN_THOUSANDS,
                          groupValue: _selectedCost,
                          onChanged: (Cost value) {
                            setState(() {
                              _selectedCost = value;
                            });
                          },
                        ),
                        Text("10,000원", style: TextStyle(fontSize: 20, fontFamily: 'Dosis', fontWeight: FontWeight.w500)),
                      ],
                    ),
                  )),
              Positioned(
                  top: MediaQuery.of(context).size.height * 0.39,
                  left: 30,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("10% Discount event card", style: TextStyle(fontSize: 17, fontFamily: 'Dosis', fontWeight: FontWeight.w600))
                      ],
                    ),
                  )),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.43,
                bottom: 0,
                left: 0,
                right: 0,
                child: ListView(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        _showCardMethod(),
                        SizedBox(height: 15),
                        _showPayMethod(),
                      ],
                    ),
                    SizedBox(height: 5),
                    InkWell(
                      onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => IamPortPayment(chargeType:_selectedCost))); },
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
                              onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => IamPortPayment(chargeType:_selectedCost))); },
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Charge Point",
                                  style: TextStyle(fontSize: 15, fontFamily:'Dosis', color: Colors.white, fontWeight: FontWeight.w800),
                                ),
                                Text(
                                  "포인트 충전하기",
                                  style: TextStyle(fontSize: 23, fontFamily:'Dosis', color: Colors.white, fontWeight: FontWeight.w800),
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    )
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

Widget _showCardMethod() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      Container(
          width: 110,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            children: <Widget>[
              Image.asset("assets/image/pay/hyundai_card.png", height: 80),
              Text(
                  "Hyundai Card",
                  style: TextStyle(fontSize: 17, fontFamily: 'Dosis', fontWeight: FontWeight.w600)
              ),
            ],
          )
      ),
      Container(
          width: 110,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            children: <Widget>[
              Image.asset("assets/image/pay/KBbank_card.png", width: 250, height: 80),
              Text(
                  "KBbank Card",
                  style: TextStyle(fontSize: 17, fontFamily: 'Dosis', fontWeight: FontWeight.w600)
              ),
            ],
          )
      ),
      Container(
          width: 110,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            children: <Widget>[
              Image.asset("assets/image/pay/samsung_card.png", width: 200, height: 80),
              Text(
                  "Samsung Card",
                  style: TextStyle(fontSize: 17, fontFamily: 'Dosis', fontWeight: FontWeight.w600)
              ),
            ],
          )
      ),
    ],
  );
}
Widget _showPayMethod() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      Container(
        width: 110,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          children: <Widget>[
            Image.asset("assets/image/pay/kakaopay.png", width: 75, height: 86),
            Text(
              "Kakao Pay",
              style: TextStyle(fontSize: 17, fontFamily: 'Dosis', fontWeight: FontWeight.w600)
            ),
          ],
        )
      ),
      Container(
          width: 110,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            children: <Widget>[
              Image.asset("assets/image/pay/payco.png", width: 75, height: 86),
              Text(
                  "Payco",
                style: TextStyle(fontSize: 17, fontFamily: 'Dosis', fontWeight: FontWeight.w600)
              ),
            ],
          )
      ),
      Container(
          width: 110,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            children: <Widget>[
              Image.asset("assets/image/pay/samsung_pay2.png", width: 90, height: 86),
              Text(
                  "Samsung Pay",
                  style: TextStyle(fontSize: 17, fontFamily: 'Dosis', fontWeight: FontWeight.w600)
              ),
            ],
          )
      ),
    ],
  );
}

