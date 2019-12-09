import 'package:flutter/material.dart';
import 'package:gteams/game/game_join/game_room/current_room.dart';
import 'package:gteams/game/game_join/model/GameListData.dart';
import 'package:gteams/map/StadiumListData.dart';
import 'package:gteams/root_page.dart';
import 'package:gteams/services/crud.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

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

              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 5,),
                  Text(DateFormat('MM월-dd일(EE)').format(DateTime.fromMillisecondsSinceEpoch(gameData.dateNumber))+" : 시작 "+gameData.startTime+" ~ " + " 종료 "+ gameData.endTime, style: TextStyle(color: Colors.black)),
                  SizedBox(height: 5,),
                  new LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width - 170,
                    animation: true,
                    lineHeight: 20.0,
                    animationDuration: 2000,
                    percent: gameData.chamyeyul,
                    linearGradient: LinearGradient(colors: [Colors.indigo, const Color(0xFF083663)]),
                    center: Text("현재 참여율"+(gameData.chamyeyul*100).toStringAsFixed(0)+"%" ,style: TextStyle(color: Colors.white),),
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    //progressColor: GameJoinTheme.buildLightTheme().accentColor,
                  ),
                  gameData.reserve_status == 4 ? Text("게임을 잘 즐기셨나요? 게임 평가 부탁드립니다", style: TextStyle(color : Colors.redAccent ,fontSize: 13, fontWeight: FontWeight.bold),) : SizedBox(),
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