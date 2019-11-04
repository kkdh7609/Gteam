import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gteams/root_page.dart';

class crudMedthods {
  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> addData(gameData) async {

    if (isLoggedIn()) {
      Firestore.instance.collection('game').add(gameData).catchError((e) {
        print(e);
      });
    } else {
      print('You need to be logged in');
    }
  }

  getData(String collection) async {
    return await Firestore.instance.collection(collection);
        //.getDocuments();
  }
}