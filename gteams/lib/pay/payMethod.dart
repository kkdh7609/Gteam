import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gteams/root_page.dart';
import 'package:gteams/services/crud.dart';


class PayMethods{
  crudMedthods _useCrudMethods = crudMedthods();

  Future<int> getFund() async{
    DocumentSnapshot data = await _useCrudMethods.getDocumentById("user", RootPage.userDocID);
    return data.data["fund"];
  }

  Future<dynamic> updateFund(fund) async{
    return await _useCrudMethods.updateDataThen("user", RootPage.userDocID, {"fund" : fund});
  }
}
