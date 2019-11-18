//To add user account to firestore 'user' collection
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserManagement {
  storeNewUser(email, context, name, isUser) {
    Firestore.instance.collection('/user').add({
      'email': email,
      'name': name,
      'isUser': isUser,
      'info_status': false,
      'balance' : 0,

      // To check basic information about user[ True=> setting complete] ex) gender , age etc..
    }).then((value) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/login');
    }).catchError((e) {
      print(e);
    });
  }
}
