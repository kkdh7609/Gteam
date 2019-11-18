import 'package:flutter/material.dart';
import 'package:gteams/menu/drawer/UserData.dart';
import 'package:gteams/game/game_join/widgets/GameJoinTheme.dart';

class PreferListView extends StatelessWidget {

  final VoidCallback callback;
  final PreferListData preferData;
  final AnimationController animationController;
  final Animation animation;

  PreferListView({Key key, this.preferData, this.animationController, this.animation, this.callback}) : super(key: key);

  Widget _dayText(idx){
    return Container(
        child: Text(idx)
    );
  }

  List<Widget> _dayList() {
    List<Widget> listDay = List.generate(preferData.dayList.length, (i) {
      return _dayText(preferData.dayList[i]);
    });
    return listDay;
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
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: <Widget>[
                                                                    Row(
                                                                      children: <Widget>[
                                                                        Text(
                                                                            preferData.startTime,
                                                                            style: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 22,
                                                                            )
                                                                        ),
                                                                        Text(
                                                                            " ~ ",
                                                                            style: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 22,
                                                                            )
                                                                        ),
                                                                        Text(
                                                                            preferData.endTime,
                                                                            style: TextStyle(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 22,
                                                                            )
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: _dayList()
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
                                        onLongPress: (){
                                          // 삭제 ?
                                        },
                                      ),
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

