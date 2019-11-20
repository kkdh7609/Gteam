import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class crudMedthods {
  final Firestore _db = Firestore.instance;

  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> addData(String collection, addData) async {
    if (isLoggedIn()) {
      _db.collection(collection).add(addData).catchError((e) {
        print("error");
        print(e);
      });
    } else {
      print('You need to be logged in');
    }
  }

  Future<QuerySnapshot> getDataCollection(String collection) async {
    return await _db.collection(collection).getDocuments();
  }

  Future<DocumentSnapshot> getDocumentById(String collection, String docId) async {
    return await _db.collection(collection).document(docId).get();
  }

/*
  Future<DocumentSnapshot> getDocumentByWhere(String collection,String field,String where) async{
    var userQuery = _db.collection(collection).where(field,isEqualTo:where).limit(1);
    userQuery.getDocuments().then((data){
      return data.documents[0];
    });
  }

*/

  Future<QuerySnapshot> getDocumentByWhere(String collection, String field, dynamic where) async {
    return await _db.collection(collection).where(field, isEqualTo: where).limit(1).getDocuments();
  }

  Future<void> updateData(String collection, String docId, newValues) {
    _db.collection(collection).document(docId).updateData(newValues).catchError(
      (e) {
        print(e);
      },
    );
  }

  Future<dynamic> updateDataThen(String collection, String docId, newValues) async {
    return await _db.collection(collection).document(docId).updateData(newValues);
  }

  Future<void> deleteData(String collection, String docId) {
    _db.collection(collection).document(docId).delete().catchError(
      (e) {
        print(e);
      },
    );
  }
}
