import 'package:flutter/material.dart';

class UnPermitPage extends StatefulWidget {
  UnPermitPage({Key key, this.onSignedOut}) : super(key: key);

  final VoidCallback onSignedOut;

  @override
  _UnPermitPageState createState() => _UnPermitPageState();
}

class _UnPermitPageState extends State<UnPermitPage> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("아직 인증되지 않은 사용자 입니다."),
                  FlatButton(
                    onPressed: widget.onSignedOut,
                    color: Color(0xff20253d),
                    child: Text("돌아가기", style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    )),
                  )
                ]
            ),
          ),
        ),
      ),
    );
  }
}