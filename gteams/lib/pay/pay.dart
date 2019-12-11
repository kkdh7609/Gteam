import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gteams/pay/iamport_payment.dart';
import 'package:gteams/pay/payMethod.dart';
import 'package:gteams/util/alertUtil.dart';

enum Cost { ONE_THOUSANDS, FIVE_THOUSANDS, TEN_THOUSANDS }
enum PayMethod {
  CARD,
  PHONE,
  TRANS,
}

class PayPage extends StatefulWidget {
  @override
  _PayPageState createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  Cost _selectedCost = null;
  PayMethod _selectedPayMethod = null;
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
                              Text("Total Point of G-TEAM",
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
                        Text("10,000원", style: TextStyle(fontSize: 20, fontFamily: 'Dosis', fontWeight: FontWeight.w500)),
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
                        Text("50,000원", style: TextStyle(fontSize: 20, fontFamily: 'Dosis', fontWeight: FontWeight.w500)),
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
                        Text("100,000원", style: TextStyle(fontSize: 20, fontFamily: 'Dosis', fontWeight: FontWeight.w500)),
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
                        Text("Choose Your Pay Method",
                            style: TextStyle(fontSize: 17, fontFamily: 'Dosis', fontWeight: FontWeight.w600))
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
                  /*
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        _showCardMethod(),
                        SizedBox(height: 15),
                        _showPayMethod(),
                      ],
                    ),
                    SizedBox(height: 5),
                    */
                    InkWell(
                        onTap: () {
                          setState(() {
                            if (_selectedPayMethod != PayMethod.CARD)
                              _selectedPayMethod = PayMethod.CARD;
                            else
                              _selectedPayMethod = null;
                          });
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.13,
                          margin: EdgeInsets.symmetric(vertical: 9.0, horizontal: 21.0),
                          decoration: BoxDecoration(
                            color: _selectedPayMethod == PayMethod.CARD ? Color(0xff20242b).withOpacity(0.85) : Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          padding: EdgeInsets.all(15),
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                color: _selectedPayMethod == PayMethod.CARD ? Colors.white : Color(0xff20253d),
                                icon: Icon(Icons.card_giftcard, size: 40),
                                onPressed: () {
                                  setState(() {
                                    if (_selectedPayMethod != PayMethod.CARD)
                                      _selectedPayMethod = PayMethod.CARD;
                                    else
                                      _selectedPayMethod = null;
                                  });
                                },
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Card & Pay",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Dosis',
                                        color: _selectedPayMethod == PayMethod.CARD ? Colors.white : Color(0xff20253d),
                                        fontWeight: FontWeight.w800),
                                  ),
                                  Text(
                                    "카드 & 페이",
                                    style: TextStyle(
                                        fontSize: 23,
                                        fontFamily: 'Dosis',
                                        color: _selectedPayMethod == PayMethod.CARD ? Colors.white : Color(0xff20253d),
                                        fontWeight: FontWeight.w800),
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                    InkWell(
                        onTap: () {
                          setState(() {
                            if (_selectedPayMethod != PayMethod.PHONE)
                              _selectedPayMethod = PayMethod.PHONE;
                            else
                              _selectedPayMethod = null;
                          });
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.13,
                          margin: EdgeInsets.symmetric(vertical: 9.0, horizontal: 21.0),
                          decoration: BoxDecoration(
                            color: _selectedPayMethod == PayMethod.PHONE ? Color(0xff20242b).withOpacity(0.85) : Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          padding: EdgeInsets.all(15),
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                color: _selectedPayMethod == PayMethod.PHONE ? Colors.white : Color(0xff20253d),
                                icon: Icon(Icons.phone_android, size: 40),
                                onPressed: () {
                                  setState(() {
                                    if (_selectedPayMethod != PayMethod.PHONE)
                                      _selectedPayMethod = PayMethod.PHONE;
                                    else
                                      _selectedPayMethod = null;
                                  });
                                },
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Mobile Phone Payment",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Dosis',
                                        color: _selectedPayMethod == PayMethod.PHONE ? Colors.white : Color(0xff20253d),
                                        fontWeight: FontWeight.w800),
                                  ),
                                  Text(
                                    "휴대폰 소액 결제",
                                    style: TextStyle(
                                        fontSize: 23,
                                        fontFamily: 'Dosis',
                                        color: _selectedPayMethod == PayMethod.PHONE ? Colors.white : Color(0xff20253d),
                                        fontWeight: FontWeight.w800),
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                    InkWell(
                        onTap: () async {
                          _selectedCost == null || _selectedPayMethod == null ?
                          await showAlertDialog("오류 발생", "결제 금액이나 방법을 모두 선택해주세요.", context) :
                          await Navigator.push(
                              context, MaterialPageRoute(builder: (context) => IamPortPayment(chargeType: _selectedCost, PayMethodType: _selectedPayMethod)));
                          setState(() {
                            PayMethods().getFund().then((data){
                              setState(() {
                                fund = data;
                              });
                            });
                          });
                        },
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
                                onPressed: () async {
                                  await Navigator.push(
                                      context, MaterialPageRoute(builder: (context) => IamPortPayment(chargeType: _selectedCost, PayMethodType: _selectedPayMethod)));
                                  setState(() {
                                    PayMethods().getFund().then((data){
                                      setState(() {
                                        fund = data;
                                      });
                                    });
                                  });
                                },
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Charge Point",
                                    style: TextStyle(
                                        fontSize: 15, fontFamily: 'Dosis', color: Colors.white, fontWeight: FontWeight.w800),
                                  ),
                                  Text(
                                    "포인트 충전하기",
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