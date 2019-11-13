//To add manager account to firestore 'user' collection
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManagerManagement {
  // Modify Please
  storeNewManager(email, context, name, businessNum, isUser) {
    Firestore.instance.collection('/user').add({
      'email': email,
      'name': name,
      'businessNum': businessNum,
      'isUser': isUser,
      'info_status': false,
      // To check basic information about user[ True=> setting complete] ex) gender , age etc..
    }).then((value) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/login');
    }).catchError((e) {
      print(e);
    });
  }
}
