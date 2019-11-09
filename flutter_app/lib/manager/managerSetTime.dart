import 'package:flutter/material.dart';

class SetTime extends StatefulWidget {
  @override
  _SetTimeState createState() => _SetTimeState();
}

class _SetTimeState extends State<SetTime> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Available Times", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22, color: Colors.white)),
          centerTitle: true,
          backgroundColor: Color(0xff3B5998),
        ),
        body: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          GridView.count(
              crossAxisCount: 2,
              children: List.generate(100, (index) {
                return Center(
                  child: Text(
                    'Itme $index',
                    style: Theme.of(context).textTheme.headline,
                  ),
                );
              }))
        ])));
  }
}
