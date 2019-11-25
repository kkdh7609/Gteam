import 'package:flutter/material.dart';


Widget _alertButton(context) {
  return FlatButton(
    color: Color(0xff20253d),
    child: Text("OK", style: TextStyle(color: Colors.white)),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
}

AlertDialog _alertDialog(title, text, context) {
  return AlertDialog(title: Text(title), content: Text(text), actions: <Widget>[
    _alertButton(context),
  ]);
}

showAlertDialog(title, text, context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return _alertDialog(title, text, context);
      });
}
