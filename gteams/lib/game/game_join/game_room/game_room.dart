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

class GameRoomPage extends StatefulWidget {
  final String docId;
  List<dynamic> currentUserList;
  StadiumListData stadiumData;
  GameListData gameData;

  GameRoomPage({Key key,this.docId,this.currentUserList,this.stadiumData,this.gameData}) : super(key: key);

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

  crudMedthods crudObj = new crudMedthods();
  PayMethods payObj = new PayMethods();

  @override
  void initState() {
    animationController = AnimationController(duration: Duration(milliseconds: 1000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: animationController, curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();
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

  void _changeState(String tempStr,String tempStr2) {
    print(tempStr);
  }

  Widget _alertButton(){
    return FlatButton(
      child: Text("OK"),
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
                  aspectRatio: 1.2,
                  child: Image.asset('assets/image/game/room/footsal_club.jpg'),
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
                                  "총 비용 :"+widget.stadiumData.price.toString()+" 원 / 인당 :" + widget.gameData.perPrice.toString()+" 원" ,
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
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MapTest(onSelected: _changeState, nowReq: mapReq.mapCheck,stadiumData: widget.stadiumData,)));
                                          })
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      getTimeBoxUI("공 대여", "Ball", Icon(FontAwesomeIcons.volleyballBall),widget.stadiumData.isBall),
                                      getTimeBoxUI("주차장 ", "Skill", Icon(FontAwesomeIcons.parking),widget.stadiumData.isParking),
                                      getTimeBoxUI("샤워장", "Clothes", Icon(FontAwesomeIcons.shower),widget.stadiumData.isClothes),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      getTimeBoxUI("팀 조끼", "Ball", Icon(FontAwesomeIcons.tshirt),widget.stadiumData.isClothes),
                                      getTimeBoxUI("풋살화 ", "Shoes", Icon(FontAwesomeIcons.shoePrints),widget.stadiumData.isShoes),
                                      getTimeBoxUI("실력", "Level"+widget.gameData.gameLevel.toString(), Icon(FontAwesomeIcons.users),1),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: AnimatedOpacity(
                              duration: Duration(milliseconds: 500),
                              opacity: opacity2,
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
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).padding.bottom,
                          )
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
                      color: GameRoomTheme.nearlyBlack,
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
                  widget.currentUserList.contains(RootPage.user_email) ?
                  InkWell(
                    onTap:(){
                      bool isFull = widget.gameData.groupSize == widget.currentUserList.length ? true : false;
                      Navigator.push(context, MaterialPageRoute(builder: (context) => currentRoomPage(currentUserList: widget.currentUserList,gameData: widget.gameData,isFull: isFull,), fullscreenDialog: true),
                      );
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
                  ) : InkWell(
                    onTap:(){
                      List<dynamic> newList = widget.currentUserList.toList();
                      newList.add(RootPage.user_email);
                      //crudObj.getDocumentById('game3', widget.docId).then((data){
                        int price =  widget.gameData.perPrice;
                        payObj.getFund().then((fundData){
                          if(fundData >= price){
                            int newFund = fundData - price;
                            payObj.updateFund(newFund).then((waitData1){
                              crudObj.updateDataThen('game3', widget.docId, {'userList' : newList}).then((waitData2){
                                bool isFull = widget.gameData.groupSize == newList.length ? true : false;
                                Navigator.push(context, MaterialPageRoute(builder: (context) => currentRoomPage(currentUserList: newList,gameData: widget.gameData,isFull: isFull,), fullscreenDialog: true));
                              });
                            });
                          }
                          else{
                            showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return _alertDialog("참가 실패", "포인트가 부족합니다");
                              }
                            );
                          }
                        });
                      //});
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
                  )
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
      height: 110,
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
            padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 12.0, bottom: 12.0),
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
                  color: Colors.red,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}