import 'package:flutter/material.dart';
import 'package:gteams/game_join/model/GameListData.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gteams/game_join/GameJoinTheme.dart';
import 'package:gteams/game_join/game_room/game_room.dart';

class GameListView extends StatelessWidget {

  final VoidCallback callback;
  final GameListData gameData;
  final AnimationController animationController;
  final Animation animation;

  GameListView({Key key, this.gameData, this.animationController, this.animation, this.callback}) : super(key: key);

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
                      padding: const EdgeInsets.only(left: 24, right: 24, top : 8, bottom: 16),
                      child: InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            callback();
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.6),
                                      offset: Offset(4, 4),
                                      blurRadius: 16,
                                    )
                                  ]
                              ),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                                  child: Stack(
                                    children: <Widget>[
                                      InkWell(
                                        child:Column(
                                          children: <Widget>[
                                            AspectRatio(
                                              aspectRatio: 2,
                                              child: Image.asset(gameData.imagePath, fit: BoxFit.cover),
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
                                                                          Text(
                                                                              gameData.gameName,
                                                                              textAlign: TextAlign.left,
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 20,
                                                                              )
                                                                          ),
                                                                          SizedBox(
                                                                            width: 15,
                                                                          ),
                                                                          Icon(
                                                                            FontAwesomeIcons.calendarTimes,
                                                                            size: 15,
                                                                            color: GameJoinTheme.buildLightTheme().primaryColor,
                                                                          ),
                                                                          Text(
                                                                              gameData.dateText+" : "+gameData.startTime+"~"+gameData.endTime,
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 13,
                                                                              )
                                                                          ),
                                                                          SizedBox(
                                                                            width: 23,
                                                                          ),
                                                                          Text(
                                                                            "10,000"+"원",
                                                                            textAlign: TextAlign.left,
                                                                            style: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 18,
                                                                            ),
                                                                          ),
                                                                        ]
                                                                    ),
                                                                    Row(
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      children: <Widget>[
                                                                        Icon(
                                                                          FontAwesomeIcons.mapMarkerAlt,
                                                                          size: 10,
                                                                          color: GameJoinTheme.buildLightTheme().primaryColor,
                                                                        ),
                                                                        Text(
                                                                            gameData.loc_name,
                                                                            style: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.8))
                                                                        ),
                                                                        SizedBox(
                                                                          width: 160,
                                                                        ),
                                                                        Text(
                                                                          "인당 참가비",
                                                                          style: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.8)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(top: 4),
                                                                      child: Row(
                                                                        children: <Widget>[
                                                                          Text(
                                                                              (gameData.groupSize/2).toInt().toString()+" VS "+(gameData.groupSize/2).toInt().toString(),
                                                                              style: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.8))
                                                                          ),
                                                                          SizedBox(
                                                                            width: 15,
                                                                          ),
                                                                          Text(
                                                                              "옷 신발 추가",
                                                                              style: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.8))
                                                                          ),
                                                                          SizedBox(
                                                                            width: 15,
                                                                          ),
                                                                          Text(
                                                                              "주차장 추가",
                                                                              style: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.8))
                                                                          ),
                                                                          SizedBox(
                                                                            width: 15,
                                                                          ),Text(
                                                                              "샤워시설 추가",
                                                                              style: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.8))
                                                                          ),
                                                                          SizedBox(
                                                                            width: 4,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                            )
                                                        )
                                                    ),
                                                  ],
                                                )
                                            )
                                          ],
                                        ),
                                        onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context)=>GameRoomPage())); } ,
                                      ),

                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(32.0),
                                            ),
                                            onTap: () {},
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.favorite_border,
                                                color: GameJoinTheme.buildLightTheme().primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                              )
                          )
                      )
                  )
              )
          );
        }
    );
  }
}

