import 'package:flutter/material.dart';
import 'package:gteams/manager/manageReserveList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gteams/manager/calendar/managerCalendar.dart';
import 'package:gteams/manager/editStadium.dart';
import 'package:gteams/root_page.dart';

typedef newFunc = Future<void> Function();
class FacilityMenuPage extends StatefulWidget {
  FacilityMenuPage({Key key, this.staRef, this.refreshData, this.index}) : super(key: key);
  final DocumentSnapshot staRef;
  final newFunc refreshData;
  final int index;

  @override
  _FacilityMenuPageState createState() => _FacilityMenuPageState();
}

class _FacilityMenuPageState extends State<FacilityMenuPage> {
  String title;
  DocumentSnapshot nowStaRef;
  bool isAvailable = true;
  @override
  void initState(){
    isAvailable = true;
    title = widget.staRef.data["stadiumName"];
    nowStaRef = widget.staRef;
    super.initState();
  }

  Future<void> newRefreshData() async {
    if(isAvailable) {
      setState((){
      nowStaRef = null;
      });
      isAvailable = false;
      await widget.refreshData();
      if(this.mounted) {
        setState(() {
          this.nowStaRef = RootPage.facilityData[widget.index];
          title = nowStaRef.data["stadiumName"];
        });
      }
      isAvailable = true;
    }
  }

  Widget refreshWidget(){
    return IconButton(
      icon: Icon(Icons.refresh),
      onPressed: (){
        newRefreshData();
      },
    );
  }
  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
            title: Text(this.nowStaRef != null ? title : "", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22, color: Colors.white)),
            centerTitle: true,
            backgroundColor: Color(0xff20253d),
          actions: <Widget>[
            refreshWidget()
          ]
        ),
        body: SafeArea(
          child: Center(
            child: this.nowStaRef != null ? Container(
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
                                          onTap: (){
                                            if(isAvailable) {
                                              Navigator.push(context,
                                                  MaterialPageRoute(builder: (context) => StadiumEditPage(refreshData: newRefreshData, stdRef: this.nowStaRef,)));
                                            }
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
                                            if(isAvailable) {
                                              Navigator.push(context,
                                                  MaterialPageRoute(builder: (context) => CalendarViewApp(stdRef: this.nowStaRef)));
                                            }
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
                                            if(isAvailable) {
                                              Navigator.push(context,
                                                  MaterialPageRoute(builder: (context) => ReserveList(stdRef: this.nowStaRef, refreshData: newRefreshData, index: widget.index,)));
                                            }
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
            ) : CircularProgressIndicator(),
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