import 'package:flutter/material.dart';
import 'package:gteams/game/game_join/game_room/current_room.dart';
import 'package:gteams/game/game_join/model/GameListData.dart';
import 'package:gteams/map/StadiumListData.dart';
import 'package:gteams/root_page.dart';
import 'package:gteams/services/crud.dart';


class CurrentRoomListPage extends StatefulWidget {
  @override
  _CurrentRoomListPageState createState() => _CurrentRoomListPageState();
}

class _CurrentRoomListPageState extends State<CurrentRoomListPage> {

  List<dynamic> gameList;
  List<GameListData> gameDataList;

  crudMedthods crudObj = new crudMedthods();
  StadiumListData stadiumData;
  bool isAvailable =true ;
  var flag = 0;
  int reserve_status ;

  @override
  void initState(){
    super.initState();
    var userQuery = crudObj.getDocumentByWhere('user','email',RootPage.user_email);
    userQuery.then((document){
      setState(() {
        this.gameList=document.documents[0].data['gameList'];
        isAvailable =true ;

        gameDataList = List<GameListData>(this.gameList.length);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget makeCard(int index, GameListData gameData){
    return Card(
        elevation: 10.0,
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
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontFamily: 'Dosis'),
              ),
              subtitle: Row(
                children: <Widget>[
                  Text("detail", style: TextStyle(color: Colors.black))
                ],
              ),
              trailing: Icon(Icons.keyboard_arrow_right, color: Colors.black, size: 30.0),
              onTap: (){
                if (isAvailable) {
                  isAvailable = false;
                  //int reserve_status = gameData.groupSize == gameData.userList.length ? 1 : 0; // 1 => 방이 가득찼을때 0 방 가득 안찼을때
                  gameData.stadiumRef.get().then((document) {
                    stadiumData = StadiumListData.fromJson(document.data);
                    crudObj.getDocumentById('game3', gameList[index]).then((gameDocument1) {
                      reserve_status = gameDocument1.data['reserve_status'];
                      Navigator.push(context, MaterialPageRoute(builder: (context) => currentRoomPage(currentUserList: gameData.userList, gameData: gameData, stadiumData: stadiumData, reserve_status: reserve_status, docId: gameList[index]), fullscreenDialog: true)).then((data) {
                      });
                      isAvailable = true;
                    });
                    });
                  }
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
                    gameDataList[index] = GameListData.fromJson(document.data);
                  });
                }
              });
              return this.gameDataList[index] != null ? makeCard(index, gameDataList[index]) : LinearProgressIndicator();
            },
          ) : LinearProgressIndicator(),
        )
    );
  }
}