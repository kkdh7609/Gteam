import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gteams/game/game_join/widgets/GameJoinTheme.dart';
import 'package:gteams/game/game_join/model/GameListData.dart';
import 'package:gteams/game/game_join/game_room/game_room.dart';
import 'package:gteams/map/StadiumListData.dart';

class GameListView extends StatelessWidget {
  final VoidCallback callback;
  final GameListData gameData;
  final AnimationController animationController;
  final Animation animation;
  final String docId;
  final StadiumListData stadiumData;

  GameListView({Key key, this.gameData,this.docId,this.stadiumData,this.animationController, this.animation, this.callback}) : super(key: key);

  Widget clearIcon(int isProvide){
    return isProvide >= 1 ?
    SizedBox(width: 60)  // 제공할경우
        :
    Icon( // 제공하지 않을경우 X 표시 출력
      Icons.clear,
      size: 70,
      color: Color(0xFF880E4F),
    );
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(0.0, 50 * (1.0 - animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  callback();
                },
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(16.0)), boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      offset: Offset(4, 4),
                      blurRadius: 16,
                    )
                  ]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    child: Stack(
                      children: <Widget>[
                        InkWell(
                          child: Column(
                            children: <Widget>[
                              AspectRatio(
                                  aspectRatio: 2,
                                  child: Image(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(stadiumData.imagePath),
                                  )
                              ),
                              Container(
                                color: GameJoinTheme.buildLightTheme().backgroundColor,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Text(
                                                      gameData.gameName,
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontFamily: 'Dosis',
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 65),
                                                  Text(
                                                    "인당 "+gameData.perPrice.toString() + "원",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontFamily: 'Dosis',
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Icon(
                                                    FontAwesomeIcons.calendar,
                                                    size: 15,
                                                    color: GameJoinTheme.buildLightTheme().primaryColor,
                                                  ),
                                                  Text(
                                                    gameData.dateText + " : " + gameData.startTime + "~" + gameData.endTime,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: 'Dosis',
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 175,
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Icon(
                                                    FontAwesomeIcons.mapMarkerAlt,
                                                    size: 10,
                                                    color: GameJoinTheme.buildLightTheme().primaryColor,
                                                  ),
                                                  Text(
                                                    stadiumData.location.substring(0,stadiumData.location.lastIndexOf("구")+1),
                                                      style: TextStyle(
                                                        fontFamily: 'Dosis',
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 13,
                                                      ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 25),
                                                child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: <Widget>[
                                                        //Padding(
                                                        // padding: const EdgeInsets.only(left: 17),
                                                        //child: Column(
                                                        SizedBox(width: 10),
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: <Widget>[
                                                            stadiumData.isClothes != 0 ?
                                                                Stack(
                                                                  children: <Widget>[
                                                                    Icon(FontAwesomeIcons.tshirt, color: GameJoinTheme.buildLightTheme().primaryColor, size: 35),
//                                                                    child: Icon( Icons.clear, size: 70, color: Color(0xFF880E4F))
                                                                  ]
                                                                ) :
                                                            Icon(FontAwesomeIcons.tshirt, color: Colors.grey.withOpacity(0.6), size: 35),
//                                                            Icon(FontAwesomeIcons.tshirt, color: Colors.grey, size: 28),
                                                            SizedBox(height: 5),
                                                            Text(
                                                              "팀 조끼",
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.w700,
                                                                  fontSize: 14,
                                                                  color: Colors.black.withOpacity(0.5),
                                                                  fontFamily: 'Dosis'),
                                                            ),
                                                          ],
                                                        ),
                                                        //),
                                                        SizedBox(width: 20),
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: <Widget>[
                                                            stadiumData.isBall != 0 ?
                                                            Stack(children: <Widget>[
                                                              Icon(FontAwesomeIcons.volleyballBall, color: GameJoinTheme.buildLightTheme().primaryColor, size: 35),

                                                            ],):
                                                            //Icon(FontAwesomeIcons.volleyballBall, color: GameJoinTheme.buildLightTheme().primaryColor, size: 35,) :
                                                            Icon(FontAwesomeIcons.volleyballBall, color: Colors.grey.withOpacity(0.6), size: 28),
                                                            SizedBox(height: 5),
                                                            Text(
                                                              "공 대여",
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.w700,
                                                                  fontSize: 14,
                                                                  color: Colors.black.withOpacity(0.5),
                                                                  fontFamily: 'Dosis'),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(width: 20),
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: <Widget>[
                                                            stadiumData.isParking != 0 ?
                                                            Icon(FontAwesomeIcons.parking, color: GameJoinTheme.buildLightTheme().primaryColor, size: 35) :
                                                            Icon(FontAwesomeIcons.parking, color: Colors.grey.withOpacity(0.6), size: 28),
                                                            SizedBox(height: 5),
                                                            Text("주차장",
                                                                style: TextStyle(
                                                                    fontWeight: FontWeight.w700,
                                                                    fontSize: 14,
                                                                    color: Colors.black.withOpacity(0.5),
                                                                    fontFamily: 'Dosis')),
                                                          ],
                                                        ),
                                                        SizedBox(width: 20),
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: <Widget>[
                                                            stadiumData.isShower != 0 ?
                                                            Icon(FontAwesomeIcons.shower, color: GameJoinTheme.buildLightTheme().primaryColor, size: 35) :
                                                            Icon(FontAwesomeIcons.shower, color: Colors.grey.withOpacity(0.6), size: 28),
                                                            SizedBox(height: 5),
                                                            Text(
                                                              "샤워장",
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.w700,
                                                                  fontSize: 14,
                                                                  color: Colors.black.withOpacity(0.5),
                                                                  fontFamily: 'Dosis'),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(width: 20),
                                                      ],
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GameRoomPage(docId: docId,initialUserList: gameData.userList,stadiumData: stadiumData ,gameData: gameData,)
                              ),
                            );
                          },
                        ),
                        Positioned(
                          top: 6,
                          right: 10,
                          child: Material(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              color: Colors.white,
                              child: Row(
                                children: <Widget>[
                                  InkWell(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(32.0),
                                    ),
                                    onTap: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Icon(
                                        Icons.people,
                                        color: GameJoinTheme.buildLightTheme().primaryColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    gameData.userList.length.toString()+" / "+gameData.groupSize.toString(),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: 'Dosis',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: GameJoinTheme.buildLightTheme().primaryColor,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                ],
                              )
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
