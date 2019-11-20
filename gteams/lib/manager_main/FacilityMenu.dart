import 'package:flutter/material.dart';
import 'package:gteams/game/game_join/widgets/GameJoinTheme.dart';
import 'package:gteams/manager/managerSetTime.dart';
import 'package:gteams/manager/manageReserveList.dart';

class FacilityMenuPage extends StatefulWidget {
  FacilityMenuPage({Key key}) : super(key: key);

  @override
  _FacilityMenuPageState createState() => _FacilityMenuPageState();
}

class _FacilityMenuPageState extends State<FacilityMenuPage> {

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Center(
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(

                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [const Color(0xFF083663), const Color(0xFF82B1FF)],
                ),

              ),
              height: size.height,
              width: size.width,
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                children: <Widget>[
                  Container(
                    height: size.height,
                    width: size.width,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          /* Title */
                          Container(
                            height: size.height * 0.1,
                            width: size.width * 0.8,
                            child: FittedBox(
                              child: Center(
                                child: Text(
                                  "에스빌드 풋살장",
                                  style: TextStyle(
                                      color: Color(0xfff1e4d4),
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Dosis',
                                      fontSize: 2000),
                                ),
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
                                                  child: Icon(Icons.receipt, color: Colors.black),
                                                ),
                                                title: Text(
                                                  "시설 정보 관리",
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
                                                  child: Icon(Icons.receipt, color: Colors.black),
                                                ),
                                                title: Text(
                                                  "시설 예약 관리",
                                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20, fontFamily: 'Dosis'),
                                                ),
                                                subtitle: Row(
                                                  children: <Widget>[
                                                    Text("Facility Information Management", style: TextStyle(color: Colors.black))
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
                                                  child: Icon(Icons.receipt, color: Colors.black),
                                                ),
                                                title: Text(
                                                  "시설 예약 승인",
                                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20, fontFamily: 'Dosis'),
                                                ),
                                                subtitle: Row(
                                                  children: <Widget>[
                                                    Text("Facility Information Management", style: TextStyle(color: Colors.black))
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
                ],
              ),
            ),
          ],
        ),
      ),
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