import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:gteams/game_join/game_room/GameRoomTheme.dart';

class GameRoomPage extends StatefulWidget {
  @override
  _GameRoomPageState createState() => _GameRoomPageState();
}

class _GameRoomPageState extends State<GameRoomPage>
    with TickerProviderStateMixin {
  final infoHeight = 500.0;
  AnimationController animationController;
  Animation<double> animation;
  var opacity1 = 0.0;
  var opacity2 = 0.0;
  var opacity3 = 0.0;

  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
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
  }

  @override
  Widget build(BuildContext context) {
    final tempHeight = (MediaQuery.of(context).size.height -
        (MediaQuery.of(context).size.width / 1.2) +
        24.0);
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
                    child: Image.asset('assets/game/room/footsal_club.jpg'),
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
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32.0),
                        topRight: Radius.circular(32.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: GameRoomTheme.grey.withOpacity(0.2),
                          offset: Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: SingleChildScrollView(
                      child: Container(
                        constraints: BoxConstraints(
                            minHeight: infoHeight,
                            maxHeight: tempHeight > infoHeight
                                ? tempHeight
                                : infoHeight),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 32.0, left: 18, right: 16),
                              child: Text(
                                "Suwon-World Cup Stadium, Suwon, Gyeonggi-do",
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
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, bottom: 8, top: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "10,000 원",
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          getTimeBoxUI("5 vs 5", "Match", Icon(FontAwesomeIcons.mapMarkedAlt)),
                                          getTimeBoxUI("2시간", "Time", Icon(FontAwesomeIcons.mapMarkedAlt)),
                                          getTimeBoxUI("신발 대여", "Shoe", Icon(FontAwesomeIcons.mapMarkedAlt)),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          getTimeBoxUI("위치", "Location", Icon(FontAwesomeIcons.mapMarkedAlt)),
                                          getTimeBoxUI("초보", "Skill", Icon(FontAwesomeIcons.mapMarkedAlt)),
                                          getTimeBoxUI("옷 대여", "Clothes", Icon(FontAwesomeIcons.mapMarkedAlt)),
                                        ],
                                      ),
                                    ],
                                  )),
                            ),
                            Expanded(
                              child: AnimatedOpacity(
                                duration: Duration(milliseconds: 500),
                                opacity: opacity2,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16, top: 8, bottom: 8),
                                  child: Text(
                                    "초보자분들 환영합니다. 풋살을 즐기시는 누구나 참가 신청 가능합니다.",
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
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
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: SizedBox(
                  width: AppBar().preferredSize.height,
                  height: AppBar().preferredSize.height,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: new BorderRadius.circular(
                          AppBar().preferredSize.height),
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
                  padding:
                      const EdgeInsets.only(left: 16, bottom: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 48,
                        height: 48,
                        child: Container(
                          decoration: BoxDecoration(
                            color: GameRoomTheme.nearlyWhite,
                            borderRadius: BorderRadius.all(
                              Radius.circular(16.0),
                            ),
                            border: new Border.all(
                                color: GameRoomTheme.grey.withOpacity(0.2)),
                          ),
                          child: Icon(
                            Icons.add,
                            color: GameRoomTheme.nearlyBlue,
                            size: 28,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: GameRoomTheme.nearlyBlue,
                            borderRadius: BorderRadius.all(
                              Radius.circular(16.0),
                            ),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color:
                                      GameRoomTheme.nearlyBlue.withOpacity(0.5),
                                  offset: Offset(1.1, 1.1),
                                  blurRadius: 10.0),
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
                        ),
                      )
                    ],
                  ),
                ),
              ))),
    );
  }

  Widget getTimeBoxUI(String text1, String text2, Icon icon1) {
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
                BoxShadow(
                    color: GameRoomTheme.grey.withOpacity(0.2),
                    offset: Offset(1.1, 1.1),
                    blurRadius: 8.0),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 18.0, right: 18.0, top: 12.0, bottom: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  icon1,
                  Text(
                    text1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      letterSpacing: 0.27,
                      color: GameRoomTheme.nearlyBlue,
                    ),
                  ),
                  Text(
                    text2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 14,
                      letterSpacing: 0.27,
                      color: GameRoomTheme.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
