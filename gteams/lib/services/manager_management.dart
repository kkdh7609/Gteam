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
      'permission': false,
      'MyStadium': [],
      'fund': 0
      // To check basic information about user[ True=> setting complete] ex) gender , age etc..
    }).then((value) {
      Firestore.instance.collection('/managerReg').add({
        'email': email,
        'name': name,
        'businessNum': businessNum,
        'key': value.path.substring(6),
      }).then((newVal){
        Navigator.of(context).pop();
      });
    }).catchError((e) {
      print(e);
    });
  }
}
