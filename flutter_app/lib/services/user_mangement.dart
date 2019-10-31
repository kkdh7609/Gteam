//To add user account to firestore 'user' collection
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/widgets.dart';

class UserManagement {
  storeNewUser(email,context,name,isUser) {
    Firestore.instance.collection('/user').add({
      'email': email,
      'name': name,
      'isUser':isUser,
    }).then((value) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/login');
    }).catchError((e) {
      print(e);
    });
  }
}