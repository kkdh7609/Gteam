import 'package:flutter/material.dart';
import 'package:gteams/game/game_join/game_room/current_room.dart';

class CurrentRoomListPage extends StatefulWidget {
  @override
  _CurrentRoomListPageState createState() => _CurrentRoomListPageState();
}

class _CurrentRoomListPageState extends State<CurrentRoomListPage> {
  Widget makeCard(){
    return Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.4)),
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
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => currentRoomPage(), fullscreenDialog: true));
              }
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            elevation: 0.1,
            title: Text("현재 방 목록")
        ),
        body: Container(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            // snapshot으러
            itemCount: 3,
            itemBuilder: (BuildContext context, int index) {
              return makeCard();
            },
          ),
        )
    );
  }
}
