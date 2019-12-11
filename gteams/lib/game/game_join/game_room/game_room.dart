import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gteams/game/game_join/game_room/current_room.dart';
import 'package:gteams/game/game_join/model/GameListData.dart';
import 'package:gteams/map/StadiumListData.dart';
import 'package:gteams/map/google_map.dart';
import 'package:gteams/game/game_join/game_room/GameRoomTheme.dart';
import 'package:gteams/root_page.dart';
import 'package:gteams/services/crud.dart';
import 'package:gteams/pay/payMethod.dart';
import 'package:gteams/util/alertUtil.dart';

class GameRoomPage extends StatefulWidget {
  final String docId;
  List<dynamic> initialUserList;
  StadiumListData stadiumData;
  GameListData gameData;

  GameRoomPage({Key key, this.docId, this.initialUserList, this.stadiumData, this.gameData}) : super(key: key);

  @override
  _GameRoomPageState createState() => _GameRoomPageState();
}

class _GameRoomPageState extends State<GameRoomPage> with TickerProviderStateMixin {
  final infoHeight = 800.0;
  AnimationController animationController;
  Animation<double> animation;
  var opacity1 = 0.0;
  var opacity2 = 0.0;
  var opacity3 = 0.0;
  var isServiceNum = 0;
  bool isEnter = false; // 참여가능 true , 참여불가능 false
  bool isAvailable = true;
  List<dynamic> currentUserList = [];
  List<dynamic> userGameList = [];
  crudMedthods crudObj = new crudMedthods();
  PayMethods payObj = new PayMethods();

  int reserve_status =0;
  @override
  void initState() {
    animationController = AnimationController(duration: Duration(milliseconds: 1000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: animationController, curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();
    if(this.mounted){
      setState(() {
        isEnter = widget.initialUserList.contains(RootPage.user_email) ? false : true;
        isAvailable = true;
        currentUserList = widget.initialUserList.toList();
      });
    }
    super.initState();
  }

  void setData() async {
    animationController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity1 = 1.0;
    });
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity2 = 1.0;
    });
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity3 = 1.0;
    });
    await Future.delayed(const Duration(milliseconds: 200));
  }

  void _changeState(String tempStr,String tempStr2, String temp) {
    //print(tempStr);
  }

  Widget _alertButton(){
    return FlatButton(
      color: Color(0xff20253d),
      child: Text("OK", style: TextStyle(color:Colors.white)),
      onPressed: (){
        Navigator.of(context).pop();
      },
    );
  }

  AlertDialog _alertDialog(title, text){
    return AlertDialog(
        title: Text(title),
      content: Text(text),
      actions: <Widget>[
        _alertButton(),
      ]
    );
  }

  joinGame(fundData, price) async {
    if (isAvailable) {
      isAvailable = false;
      // 여기에 한번 다시 받아야 함( 방 들어와 있는 동안 새로운 인원 들어갔을 때 문제 )
      if (widget.gameData.groupSize >= currentUserList.length) {

        int newFund = fundData - price;
        //reserve_status = widget.gameData.groupSize == currentUserList.length ? 1 : 0; // 1 => 방이 가득찼을때 0 방 가득 안찼을때

        await payObj.updateFund(newFund);
        await crudObj.updateDataThen('game3', widget.docId, { 'userList': currentUserList, 'reserve_status': widget.gameData.groupSize == currentUserList.length ? 1 : 0, 'chamyeyul' : (currentUserList.length / widget.gameData.groupSize).toDouble()});

        DocumentSnapshot gameDocumentary = await crudObj.getDocumentById('game3', widget.docId);
        reserve_status = gameDocumentary.data['reserve_status'];
        DocumentSnapshot userDoc = await crudObj.getDocumentById('user', RootPage.userDocID);

        userGameList = List.from(userDoc.data['gameList']);
        userGameList.add(widget.docId);
        await crudObj.updateDataThen('user', RootPage.userDocID, {'gameList': userGameList});

        Navigator.push(context, MaterialPageRoute(builder: (context) =>
            currentRoomPage(currentUserList: currentUserList, gameData: widget.gameData, stadiumData: widget.stadiumData, reserve_status: reserve_status, docId: widget.docId),
            fullscreenDialog: true)).then((data) {});
        //Navigator.push(context, MaterialPageRoute(builder: (context) => currentRoomPage(currentUserList: currentUserList,gameData: widget.gameData,stadiumData: widget.stadiumData,reserve_status: reserve_status,), fullscreenDialog: true)).then((data){
        if (this.mounted) {
          setState(() {
            isEnter = false;
            isAvailable = true;
          });
        }
      }
      else {
        isAvailable = true;
        showAlertDialog("참가 실패", "방이 이미 가득찼습니다.", context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tempHeight = (MediaQuery.of(context).size.height - (MediaQuery.of(context).size.width / 1.2) + 24.0);
    return Container(
      color: GameRoomTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            /* Image Box */
            Column(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1,
                  child: Image(
                    fit: BoxFit.fill,
                    image: NetworkImage(widget.stadiumData.imagePath),
                  )
                ),
              ],
            ),
            Positioned(
              top: (MediaQuery.of(context).size.width / 1.2) - 24.0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: GameRoomTheme.nearlyWhite,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(32.0), topRight: Radius.circular(32.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(color: GameRoomTheme.grey.withOpacity(0.2), offset: Offset(1.1, 1.1), blurRadius: 10.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: SingleChildScrollView(
                    child: Container(
                      constraints:
                      BoxConstraints(minHeight: infoHeight, maxHeight: tempHeight  > infoHeight ? tempHeight : infoHeight),
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
                                  "총 비용 :"+widget.gameData.totalPrice.toString()+" 원 / 인당 :" + widget.gameData.perPrice.toString()+" 원" ,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w200,
                                    fontSize: 18,
                                    letterSpacing: 0.27,
                                    color: GameRoomTheme.nearlyBlue,
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                widget.stadiumData.rating.toString(),
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w200,
                                                  fontSize: 20,
                                                  letterSpacing: 0.5,
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
                                          Text(
                                            "/" + widget.stadiumData.rater.toString() + "명",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w200,
                                              fontSize: 15,
                                              letterSpacing: 0.27,
                                              color: GameRoomTheme.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          AnimatedOpacity(
                            duration: Duration(milliseconds: 500),
                            opacity: opacity1,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      getTimeBoxUI((widget.gameData.groupSize / 2).toInt().toString() +
                                          " vs " +
                                          (widget.gameData.groupSize / 2).toInt().toString(), "Match", Icon(FontAwesomeIcons.peopleCarry),1),
                                      getTimeBoxUI( widget.gameData.startTime+"-"+widget.gameData.endTime, "Time" , Icon(FontAwesomeIcons.clock),1),
                                      InkWell(
                                          child: getTimeBoxUI("위치", "Location", Icon(FontAwesomeIcons.mapMarkedAlt),1),
                                          onTap: () {
                                            if(isAvailable){
                                              isAvailable = false;
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MapTest(onSelected: _changeState, nowReq: mapReq.mapCheck,stadiumData: widget.stadiumData,)));
                                              isAvailable = true;
                                            }
                                          })
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      getTimeBoxUI("공 대여", "Ball", Icon(FontAwesomeIcons.volleyballBall),widget.stadiumData.isBall),
                                      getTimeBoxUI("주차장 ", "Skill", Icon(FontAwesomeIcons.parking),widget.stadiumData.isParking),
                                      getTimeBoxUI("샤워장", "Shower", Icon(FontAwesomeIcons.shower),widget.stadiumData.isShower),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      getTimeBoxUI("팀 조끼", "Clothes", Icon(FontAwesomeIcons.tshirt),widget.stadiumData.isClothes),
                                      getTimeBoxUI("풋살화 ", "Shoes", Icon(FontAwesomeIcons.shoePrints),widget.stadiumData.isShoes),
                                      getTimeBoxUI("실력", "Level"+widget.gameData.gameLevel.toString(), Icon(FontAwesomeIcons.users),1),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: AnimatedOpacity(
                              duration: Duration(milliseconds: 500),
                              opacity: opacity2,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                                child: Text(
                                  widget.gameData.Description.toString() == null ? "No Description" : widget.gameData.Description.toString(),
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            /* 뒤로가기 버튼 */
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: SizedBox(
                width: AppBar().preferredSize.height,
                height: AppBar().preferredSize.height,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: new BorderRadius.circular(AppBar().preferredSize.height),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(top: 15),
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 500),
            opacity: opacity3,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  isEnter ?
                    InkWell( //현재 참여중 아닐때
                      onTap: () async {
                          currentUserList = widget.initialUserList.toList();
                          currentUserList.add(RootPage.user_email);
                          //crudObj.getDocumentById('game3', widget.docId).then((data){
                          int price = widget.gameData.perPrice;
                          int fundData = await payObj.getFund();
                          if (fundData >= price) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  title: Text("알림"),
                                  content: Text("$price 포인트가 소모됩니다. 방에 참여하시겠습니까?"),
                                  actions: <Widget>[
                                    FlatButton(
                                      color: Color(0xff20253d),
                                      child: Text('OK', style: TextStyle(color: Colors.white)),
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                        joinGame(fundData, price);
                                      },
                                    ),
                                    FlatButton(
                                      color: Color(0xff20253d),
                                      child: Text("Cancel", style: TextStyle(color: Colors.white)),
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ]
                                );
                              }
                            );
                          }
                          else {
                            showAlertDialog("참가 실패", "포인트가 부족합니다.", context);
                          }
                        },
                    child: Container(
                      height: 48,
                      width: 350,
                      decoration: BoxDecoration(
                        color: GameRoomTheme.nearlyBlue,
                        borderRadius: BorderRadius.all(
                          Radius.circular(16.0),
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(color: GameRoomTheme.nearlyBlue.withOpacity(0.5), offset: Offset(1.1, 1.1), blurRadius: 10.0),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "모임 참여 신청하기",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            letterSpacing: 0.0,
                            color: GameRoomTheme.nearlyWhite,
                          ),
                        ),
                      ),
                    ) ,
                  ) : InkWell( // 현재 참여중일경우
                    onTap:(){
                      //int reserve_status = widget.gameData.groupSize == currentUserList.length ? 1 : 0; // 1 => 방이 가득찼을때 0 방 가득 안찼을때
                      crudObj.getDocumentById('game3', widget.docId).then((gameDocument1) {
                        reserve_status = gameDocument1.data['reserve_status'];
                        Navigator.push(context, MaterialPageRoute(builder: (context) => currentRoomPage(currentUserList: currentUserList, gameData: widget.gameData, stadiumData: widget.stadiumData, reserve_status: reserve_status, docId: gameDocument1.documentID), fullscreenDialog: true)).then((data) {
                        });
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => currentRoomPage(currentUserList: currentUserList,gameData: widget.gameData,stadiumData: widget.stadiumData,reserve_status: reserve_status,), fullscreenDialog: true)).then((data){
                        if(this.mounted){
                          setState(() {
                            isEnter = false;
                            isAvailable =true;
                          });
                        }
                      });
                    },
                    child: Container(
                      height: 48,
                      width: 350,
                      decoration: BoxDecoration(
                        color: GameRoomTheme.dark_grey,
                        borderRadius: BorderRadius.all(
                          Radius.circular(16.0),
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(color: GameRoomTheme.nearlyBlue.withOpacity(0.5), offset: Offset(1.1, 1.1), blurRadius: 10.0),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "이미 참여중인 모임입니다",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            letterSpacing: 0.0,
                            color: GameRoomTheme.nearlyWhite,
                          ),
                        ),
                      ),
                    ) ,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getTimeBoxUI(String text1, String text2, Icon icon1,int isProvide) {
    text1 = isProvide == 2 ? text1+"(유료)" : text1;
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
                isProvide >= 1 ?
                Text("")  // 제공할경우
                    :
                Icon( // 제공하지 않을경우 X 표시 출력
                  Icons.clear,
                  size: 70,
                  color: Color(0xFF880E4F),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}