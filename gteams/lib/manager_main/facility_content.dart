import 'package:flutter/material.dart';
import 'package:gteams/manager/usePhoto.dart';
import 'package:gteams/manager/addStadium.dart';
import 'package:gteams/manager_main/FacilityMenu.dart';

class CardItem extends StatelessWidget {
  final Widget child;
  final bool lastindex;

  CardItem({@required this.child, @required this.lastindex});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        lastindex == true ?
        Navigator.push(context, MaterialPageRoute(builder: (context) => StadiumCreatePage())) :
        Navigator.push(context, MaterialPageRoute(builder: (context) => FacilityMenuPage()));},
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
