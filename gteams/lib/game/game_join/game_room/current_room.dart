import 'package:flutter/material.dart';
import 'package:gteams/menu/drawer/DrawerTheme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gteams/game/game_join/model/MemberListData.dart';
import 'package:gteams/game/game_join/game_room/GameRoomTheme.dart';
import 'package:gteams/map/StadiumListData.dart';
import 'package:gteams/map/google_map.dart';
import 'package:gteams/services/crud.dart';
import 'package:gteams/game/game_join/model/GameListData.dart';

class currentRoomPage extends StatefulWidget {
  currentRoomPage({Key key, this.currentUserList, this.gameData, this.stadiumData, this.reserve_status}) : super(key: key);

  List<dynamic> currentUserList;
  final StadiumListData stadiumData;
  GameListData gameData;
  int reserve_status;

  @override
  _currentRoomPageState createState() => _currentRoomPageState();
}

class _currentRoomPageState extends State<currentRoomPage> with SingleTickerProviderStateMixin {
  crudMedthods crudObj = new crudMedthods();
  var memberlist = MemberListData.memberList;

  final infoHeight = 100.0;
  final infoHeight2 = 800.0;
  var opacity1 = 0.0;
  var opacity2 = 0.0;
  var opacity3 = 0.0;
  bool isAvailable = true;

  var gameDocId;
  List<dynamic> gameDocIdList = [];
  List<dynamic> gameDocIdList2 = [];
  bool flag = false;

  @override
  void initState() {
    super.initState();
    this.isAvailable = true;
    this.memberlist = MemberListData.memberList;
    for (var i = 0; i < widget.currentUserList.length; i++) {
      var userQuery = crudObj.getDocumentByWhere('user', 'email', widget.currentUserList[i]);
      userQuery.then((data) {
        setState(() {
          if (data.documents.length >= 1) {
            var name = data.documents[0].data['name'];
            var address = data.documents[0].data['prferenceLoc'];
            var imagePath = data.documents[0].data['imagePath'];

            this.memberlist.add(MemberListData(name: name, address: address, imagePath: imagePath));
          }
        });
      });
    }
    if (widget.reserve_status == 1) registGame();
  }

  void registGame() { // 경기장에 게임을 등록하는 과정
    crudObj.getDocumentByWhere('game3', 'sort', widget.gameData.sort).then((document) {
      // game의 DocId를 찾기 위함..
      gameDocId = document.documents[0].documentID;
      widget.gameData.stadiumRef.get().then((document) {
        //경기장의 document 접근
        if (!flag && document.data['gameList'] == null) {
          //경기장에 데이터가 없을때
          flag = true;
          gameDocIdList.add(gameDocId);
          crudObj.updateDataThen('stadium', document.documentID, {
            'gameList': gameDocIdList,
          });
        } else if(!flag){             // flag 왜 있는지 몰라서 일단 넣어둔거, 이상하면 이 부분 확인 필요
          flag = true;
          // 경기장에 데이터 있을때
          gameDocIdList2 = new List<dynamic>.from(document.data['gameList']);
          if (gameDocIdList2.contains(gameDocId)) {
            print("이미 있는 데이터임");
          } else {
            gameDocIdList2.add(gameDocId);
            crudObj.updateDataThen('stadium', document.documentID, {
              'gameList': gameDocIdList2,
            });
          }
        }
      });
    });
  }

  @override
  void dispose() {
    this.memberlist.clear();
    super.dispose();
  }

  List<Widget> _tabTwoParameters() => [
        Tab(
          text: "Member",
          icon: Icon(Icons.group),
        ),
        Tab(text: "Chatting", icon: Icon(Icons.chat)),
        Tab(
          text: "details",
          icon: Icon(Icons.details),
        ),
      ];

  TabBar _tabBarLabel() => TabBar(
        tabs: _tabTwoParameters(),
        labelColor: Colors.redAccent,
        labelStyle: TextStyle(fontSize: 12),
        unselectedLabelColor: Color(0xff20253d),
        unselectedLabelStyle: TextStyle(fontSize: 12),
        onTap: (index) {
          var content = "";
          switch (index) {
            case 0:
              content = "Member";
              break;
            case 1:
              content = "Chatting";
              break;
            case 2:
              content = "details";
              break;
            default:
              content = "Other";
              break;
          }
        },
      );

  @override
  Widget build(BuildContext context) {
    final tempHeight = (MediaQuery.of(context).size.height - (MediaQuery.of(context).size.width / 1.2) + 24.0);
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: <Widget>[
            _main_info(),
            Container(
//              constraints: BoxConstraints.expand(height: 50),
              child: _tabBarLabel(),
            ),
            Divider(color: Colors.black, thickness: 1.0),
            Expanded(
              child: Container(
                child: TabBarView(children: [
                  ListView.builder(
                    itemCount: this.memberlist.length,
                    itemBuilder: (BuildContext context, int index) {
                      return this.memberlist.length != 0 ? _member_info(this.memberlist[index].name, this.memberlist[index].address, this.memberlist[index].imagePath, index) : LinearProgressIndicator();
                    },
                  ),
                  Container(
                    child: Text("Chatting ui"),
                  ),
                  _detail_tab()
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _member_info(String name, String address, String imagePath, int idx) {
    return Card(
      key: ValueKey(name),
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
          leading: Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: <BoxShadow>[
                BoxShadow(color: DrawerTheme.grey.withOpacity(0.6), offset: Offset(2.0, 4.0), blurRadius: 8),
              ],
            ),
            child: CircleAvatar(
                minRadius: 10,
                backgroundColor: Colors.transparent,
                backgroundImage: imagePath == null ?
                AssetImage("assets/image/profile_pic.png"): NetworkImage(
                    imagePath
                )
            ),
          ),
          title: Text(
            name,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          subtitle: Row(
            children: <Widget>[
              new Flexible(
                  child: new Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                RichText(
                  text: TextSpan(
                    text: address,
                    style: TextStyle(color: Colors.black),
                  ),
                  maxLines: 3,
                  softWrap: true,
                )
              ]))
            ],
          ),
        ),
      ),
    );
  }

  Widget _main_info() {
    return Container(
        child: Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 10.0),
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/image/game/room/footsal_club.jpg"),
                fit: BoxFit.fill,
              ),
            )),
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, .9)),
          child: Center(
            child: _main_info_text(),
          ),
        ),
        Positioned(
          left: 8.0,
          top: 50.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        )
      ],
    ));
  }

  Widget _main_info_text() {
    return Padding(
        padding: EdgeInsets.only(left: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 8.0),
            Text(
              widget.gameData.gameName,
              style: TextStyle(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      "시작: " + widget.gameData.startTime,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    )),
                Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      "/",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    )),
                Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      "종료: " + widget.gameData.endTime,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    flex: 7,
                    child: Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          "희망 수준: " + widget.gameData.gameLevel.toString(),
                          style: TextStyle(color: Colors.white),
                        ))),
                Expanded(
                  flex: 3,
                  child: widget.reserve_status >= 1
                      ? Container(
                          padding: const EdgeInsets.all(7.0),
                          decoration: new BoxDecoration(border: new Border.all(color: Colors.white), borderRadius: BorderRadius.circular(5.0)),
                          child: widget.reserve_status == 2 ?
                          Text("예약 완료", style: TextStyle(color: Colors.amberAccent, fontSize: 15.0, fontWeight: FontWeight.w600)) :
                          Text("예약 접수중", style: TextStyle(color: Colors.amberAccent, fontSize: 15.0, fontWeight: FontWeight.w600)),
                  )
                      : Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: new BoxDecoration(border: new Border.all(color: Colors.white), borderRadius: BorderRadius.circular(5.0)),
                          child: Center(
                            child: Row(
                              children: <Widget>[
                                InkWell(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(32.0),
                                  ),
                                  onTap: () {},
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Icon(
                                      Icons.people,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 3),
                                Text(
                                  widget.currentUserList.length.toString() + " / " + widget.gameData.groupSize.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          )),
                )
              ],
            ),
          ],
        ));
  }

  Widget getTimeBoxUI(String text1, String text2, Icon icon1, int isProvide) {
    text1 = isProvide == 2 ? text1 + "(유료)" : text1;
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.28,
      height: 115,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: GameRoomTheme.nearlyWhite,
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(color: GameRoomTheme.grey.withOpacity(0.2), offset: Offset(1.1, 1.1), blurRadius: 8.0),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 11.0, right: 11.0, top: 12.0, bottom: 12.0),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    icon1,
                    Text(
                      text1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Dosis',
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        letterSpacing: 0.27,
                        color: GameRoomTheme.nearlyBlue,
                      ),
                    ),
                    Text(
                      text2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Dosis',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        letterSpacing: 0.27,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                isProvide >= 1
                    ? Text("") // 제공할경우
                    : Icon(
                        // 제공하지 않을경우 X 표시 출력
                        Icons.clear,
                        size: 70,
                        color: Colors.red,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _changeState(String tempStr, String tempStr2, String temp) {
    print(tempStr);
  }

  Widget _detail_tab() {
    final tempHeight = (MediaQuery.of(context).size.height - (MediaQuery.of(context).size.width / 1.2) + 24.0);
    return SingleChildScrollView(
        child: Container(
      constraints: BoxConstraints(minHeight: infoHeight2, maxHeight: tempHeight > infoHeight2 ? tempHeight : infoHeight2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 32.0, left: 18, right: 16),
            child: Text(
              widget.stadiumData.location,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                letterSpacing: 0.27,
                color: GameRoomTheme.darkerText,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "총 비용 :" + widget.gameData.totalPrice.toString() + " 원 / 인당 :" + widget.gameData.perPrice.toString() + " 원",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w200,
                    fontSize: 22,
                    letterSpacing: 0.27,
                    color: GameRoomTheme.nearlyBlue,
                  ),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Text(
                        "4.3",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w200,
                          fontSize: 22,
                          letterSpacing: 0.27,
                          color: GameRoomTheme.grey,
                        ),
                      ),
                      Icon(
                        Icons.star,
                        color: GameRoomTheme.nearlyBlue,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    getTimeBoxUI((widget.gameData.groupSize / 2).toInt().toString() + " vs " + (widget.gameData.groupSize / 2).toInt().toString(), "Match", Icon(FontAwesomeIcons.peopleCarry), 1),
                    getTimeBoxUI(widget.gameData.startTime + "-" + widget.gameData.endTime, "Time", Icon(FontAwesomeIcons.clock), 1),
                    InkWell(
                        child: getTimeBoxUI("위치", "Location", Icon(FontAwesomeIcons.mapMarkedAlt), 1),
                        onTap: () {
                          if (isAvailable) {
                            isAvailable = false;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MapTest(
                                          onSelected: _changeState,
                                          nowReq: mapReq.mapCheck,
                                          stadiumData: widget.stadiumData,
                                        )));
                          }
                        })
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    getTimeBoxUI("공 대여", "Ball", Icon(FontAwesomeIcons.volleyballBall), widget.stadiumData.isBall),
                    getTimeBoxUI("주차장 ", "Skill", Icon(FontAwesomeIcons.parking), widget.stadiumData.isParking),
                    getTimeBoxUI("샤워장", "Shower", Icon(FontAwesomeIcons.shower), widget.stadiumData.isShower),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    getTimeBoxUI("팀 조끼", "Clothes", Icon(FontAwesomeIcons.tshirt), widget.stadiumData.isClothes),
                    getTimeBoxUI("풋살화 ", "Shoes", Icon(FontAwesomeIcons.shoePrints), widget.stadiumData.isShoes),
                    getTimeBoxUI("실력", "Level" + widget.gameData.gameLevel.toString(), Icon(FontAwesomeIcons.users), 1),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
              child: Text(
                "초보자분들 환영합니다. 풋살을 즐기시는 누구나 참가 신청 가능합니다.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'Dosis',
                  fontWeight: FontWeight.w200,
                  fontSize: 14,
                  letterSpacing: 0.27,
                  color: GameRoomTheme.grey,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom,
          )
        ],
      ),
    ));
  }
}
