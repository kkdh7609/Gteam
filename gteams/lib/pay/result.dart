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
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(widget.payResult.toString() + "원 결제 완료되었습니다.",
                        style: TextStyle(fontFamily: 'Dosis', fontWeight: FontWeight.w600, color: Colors.black, fontSize: 45)),
                    Text("Make your team with G-TEAM",
                        style: TextStyle(fontFamily: 'Dosis', fontWeight: FontWeight.w400, color: Colors.black, fontSize: 25)),
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
