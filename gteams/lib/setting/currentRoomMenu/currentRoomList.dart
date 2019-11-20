import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gteams/game/game_join/game_room/current_room.dart';
import 'package:gteams/game/game_join/model/GameListData.dart';
import 'package:gteams/root_page.dart';
import 'package:gteams/services/crud.dart';


class CurrentRoomListPage extends StatefulWidget {
  @override
  _CurrentRoomListPageState createState() => _CurrentRoomListPageState();
}

class _CurrentRoomListPageState extends State<CurrentRoomListPage> {

  List<dynamic> gameList;
  GameListData gameData;
  crudMedthods crudObj = new crudMedthods();
  var flag = 0;

  @override
  void initState(){
    super.initState();
    var userQuery = crudObj.getDocumentByWhere('user','email',RootPage.user_email);
      userQuery.then((document){
        setState(() {
          this.gameList=document.documents[0].data['gameList'];
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget makeCard(int index,GameListData gameData){
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
                  gameData.gameName,
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              subtitle: Row(
                children: <Widget>[
                  Text("detail", style: TextStyle(color: Colors.black))
                ],
              ),
              trailing: Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30.0),
              onTap: (){
                bool isFull = gameData.groupSize == gameData.userList.length ? true : false;
                Navigator.push(context, MaterialPageRoute(builder: (context) => currentRoomPage(currentUserList: gameData.userList,gameData: gameData,isFull: isFull,), fullscreenDialog: true));
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
            title: Text("현재  목록")
        ),
        body: Container(
          child: gameList != null ? ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: gameList.length,
            itemBuilder: (BuildContext context, int index) {
              crudObj.getDocumentById('game3', gameList[index]).then((document){
                if (this.mounted) {
                  setState(() {
                    gameData = GameListData.fromJson(document.data);
                  });
                }
              });
              return this.gameData != null ? makeCard(index,gameData) : LinearProgressIndicator();
            },
          ) : LinearProgressIndicator(),
        )
    );
  }
}
