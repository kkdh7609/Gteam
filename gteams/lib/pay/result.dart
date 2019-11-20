import 'package:flutter/material.dart';

class PayResultPage extends StatefulWidget{
  PayResultPage({this.payResult});

  final int payResult;

  @override
  _SetResultState createState() => _SetResultState();
}

class _SetResultState extends State<PayResultPage>{
  @override
  Widget build(BuildContext context){


    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: Color(0xff20253d),
          title: new Text('G-TEAM Point Chrage'),
        ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: new BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(widget.payResult.toString() + "원 결제 완료",
                        style: TextStyle(fontFamily: 'Dosis', fontWeight: FontWeight.w500, color: Colors.black, fontSize: 40)),
                    Text("Make your team with G-TEAM",
                        style: TextStyle(fontFamily: 'Dosis', fontWeight: FontWeight.w300, color: Colors.black, fontSize: 25)),
                    SizedBox(height: 20),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.12,
                          margin: EdgeInsets.symmetric(vertical: 9.0, horizontal: 21.0),
                          decoration: BoxDecoration(
                            color: Color(0xff20253d),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                color: Colors.white,
                                icon: Icon(Icons.keyboard_backspace, size: 40),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Back to the Point Charge Page",
                                    style: TextStyle(
                                        fontSize: 15, fontFamily: 'Dosis', color: Colors.white, fontWeight: FontWeight.w800),
                                  ),
                                  Text(
                                    "충전 페이지로 되돌아가기",
                                    style: TextStyle(
                                        fontSize: 23, fontFamily: 'Dosis', color: Colors.white, fontWeight: FontWeight.w800),
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ))
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
