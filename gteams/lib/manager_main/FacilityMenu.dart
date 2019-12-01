import 'package:flutter/material.dart';
import 'package:gteams/manager/managerSetTime.dart';
import 'package:gteams/manager/manageReserveList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FacilityMenuPage extends StatefulWidget {
  FacilityMenuPage({Key key, this.staRef}) : super(key: key);
  final DocumentSnapshot staRef;

  @override
  _FacilityMenuPageState createState() => _FacilityMenuPageState();
}

class _FacilityMenuPageState extends State<FacilityMenuPage> {
  String title;
  @override
  void initState(){
    title = widget.staRef.data["stadiumName"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
            title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22, color: Colors.white)),
            centerTitle: true,
            backgroundColor: Color(0xff20253d)),
        body: SafeArea(
          child: Center(
            child: Container(
              height: size.height,
              width: size.width,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    /* Title */
                    InkWell(
                      onTap: () { },
                      child: Container(
                        height: size.height * 0.25,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Card(
                                elevation: 10,
                                margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                child: Container(
                                  height: size.height * 0.2,
                                  decoration: BoxDecoration(color: Colors.white,
                                    borderRadius: new BorderRadius.all(
                                      Radius.circular(50.0),
                                    ),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Divider(color: Colors.black, thickness: 1.0),
                                      ListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: size.height*0.02),
                                          leading: Container(
                                            padding: EdgeInsets.only(right: 12.0),
                                            decoration: new BoxDecoration(
                                                border: new Border(
                                                    right: new BorderSide(width: 1.0, color: Colors.black))),
                                            child: Image.asset('assets/image/manager/information.png'),//Icon(Icons.receipt, color: Colors.black),
                                          ),
                                          title: Text(
                                            "경기장 정보 관리",
                                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20, fontFamily: 'Dosis'),
                                          ),
                                          subtitle: Row(
                                            children: <Widget>[
                                              Text("Facility Information Management", style: TextStyle(color: Colors.black))
                                            ],
                                          ),
                                          trailing: Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30.0),
                                          onTap: (){}
                                      ),
                                      Divider(color: Colors.black, thickness: 0.5),
                                    ],
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () { },
                      child: Container(
                        height: size.height * 0.25,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Card(
                                elevation: 8.0,
                                margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                child: Container(
                                  height: size.height * 0.2,
                                  decoration: BoxDecoration(color: Colors.white,
                                    borderRadius: new BorderRadius.all(
                                      Radius.circular(50.0),
                                    ),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Divider(color: Colors.black, thickness: 1.0),
                                      ListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: size.height*0.02),
                                          leading: Container(
                                            padding: EdgeInsets.only(right: 12.0),
                                            decoration: new BoxDecoration(
                                                border: new Border(
                                                    right: new BorderSide(width: 1.0, color: Colors.black))),
                                            child: Image.asset('assets/image/manager/reservation.png'),//Icon(Icons.receipt, color: Colors.black),
                                          ),
                                          title: Text(
                                            "경기장 예약 관리",
                                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20, fontFamily: 'Dosis'),
                                          ),
                                          subtitle: Row(
                                            children: <Widget>[
                                              Text("Facility Reservation Management", style: TextStyle(color: Colors.black))
                                            ],
                                          ),
                                          trailing: Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30.0),
                                          onTap: (){
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (context) => SetTime()));
                                          }
                                      ),
                                      Divider(color: Colors.black, thickness: 0.5),
                                    ],
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () { },
                      child: Container(
                        height: size.height * 0.25,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Card(
                                elevation: 8.0,
                                margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                child: Container(
                                  height: size.height * 0.2,
                                  decoration: BoxDecoration(color: Colors.white,
                                    borderRadius: new BorderRadius.all(
                                      Radius.circular(50.0),
                                    ),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Divider(color: Colors.black, thickness: 1.0),
                                      ListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: size.height*0.02),
                                          leading: Container(
                                            padding: EdgeInsets.only(right: 12.0),
                                            decoration: new BoxDecoration(
                                                border: new Border(
                                                    right: new BorderSide(width: 1.0, color: Colors.black))),
                                            child: Image.asset('assets/image/manager/approval.png'),//Icon(Icons.receipt, color: Colors.black),
                                          ),
                                          title: Text(
                                            "경기장 예약 승인",
                                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20, fontFamily: 'Dosis'),
                                          ),
                                          subtitle: Row(
                                            children: <Widget>[
                                              Text("Facility Reservation Approval", style: TextStyle(color: Colors.black))
                                            ],
                                          ),
                                          trailing: Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30.0),
                                          onTap: (){
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (context) => ReserveList()));
                                          }
                                      ),
                                      Divider(color: Colors.black, thickness: 0.5),
                                    ],
                                  ),
                                )
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }

  Widget makeCard(){
    return Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: new BoxDecoration(
                    border: new Border(
                        right: new BorderSide(width: 1.0, color: Colors.black))),
                child: Icon(Icons.receipt, color: Colors.black),
              ),
              title: Text(
                "Room Title",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              subtitle: Row(
                children: <Widget>[
                  Text("detail", style: TextStyle(color: Colors.black))
                ],
              ),
              trailing: Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30.0),
              onTap: (){}
          ),
        )
    );
  }
}