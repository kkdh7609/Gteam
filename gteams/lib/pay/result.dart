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
    return Scaffold(
      body: Center(
        child:
            Text(widget.payResult.toString() + "원 결제 완료되었습니다."),
      )
    );
  }
}
