import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gteams/manager/addStadium.dart';
import 'package:gteams/manager_main/FacilityMenu.dart';

typedef newFunc = Future<void> Function();

class CardItem extends StatelessWidget {
  final Widget child;
  final bool lastindex;
  final DocumentSnapshot staRef;
  final newFunc refreshData;
  final int index;

  CardItem({@required this.child, @required this.lastindex, this.staRef, this.index, @required this.refreshData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        lastindex == true ?
        Navigator.push(context, MaterialPageRoute(builder: (context) => StadiumCreatePage(refreshData: refreshData,))) :
        Navigator.push(context, MaterialPageRoute(builder: (context) => FacilityMenuPage(staRef: this.staRef, refreshData: this.refreshData, index: this.index)));},
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13.0),
        ),
        elevation: 25.0,
        child: Container(
          height: MediaQuery.of(context).size.height - 250,
          width: MediaQuery.of(context).size.width - 150,
          child: Container(
            margin: EdgeInsets.only(top: 30.0, bottom: 30.0),
            child: child,
          ),
        ),
      )
    );
  }
}
