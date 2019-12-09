import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gteams/menu/model/aliment.dart';
import 'package:gteams/game/game_join/game_join.dart';
import 'package:gteams/game/game_create/game_create.dart';
import 'package:gteams/util/alertUtil.dart';

class AlimentWidget extends StatelessWidget {
  final LinearGradient theme;
  final Aliment aliment;
  final VoidCallback increment;
  final VoidCallback decrement;

  // 생성자
  AlimentWidget({@required this.aliment, @required this.theme, this.increment, this.decrement});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SvgPicture.asset(
          aliment.image,
          width: 70.0,
          height: 70.0,
        ),
        Container(
          child: Column(
            children: <Widget>[
              Text(aliment.name, style: TextStyle(fontSize: 60.0, fontWeight: FontWeight.w700, fontFamily: 'Qwigley')),
              Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Text(
                  "• " + aliment.subtitle + " •",
                  style: TextStyle(color: Colors.black, fontSize: 17.0, fontFamily: 'Dosis', fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: theme.colors[0]),
              width: 70,
              height: 1.0,
            ),
            Container(
              child: OutlineButton(
                borderSide: BorderSide(color: theme.colors[0]),
                onPressed: () => null,
                shape: StadiumBorder(),
                child: SizedBox(
                  width: 80.0,
                  height: 45.0,
                  child: Center(
                      child: Text('Let\'s play',
                          style: TextStyle(color: theme.colors[0], fontSize: 14.0, fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center)),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(color: theme.colors[0]),
              width: 70,
              height: 1.0,
            ),
          ],
        ),
        Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            InkWell(
              onTap: () {
                aliment.name == "Futsal" ?
                Navigator.push(context, MaterialPageRoute(builder: (context) => GameCreatePage())):
                showAlertDialog("Not permitted yet", '아직 서비스를 하지 않습니다.', context);
              },
              child: Column(
                children: <Widget>[
                  SvgPicture.asset(
                    "assets/image/menu/calendar.svg",
                    width: 50.0,
                    height: 50.0,
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Create',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      )),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                aliment.name == "Futsal" ?
                Navigator.push(context, MaterialPageRoute(builder: (context) => GameJoinPage())) :
                showAlertDialog("Not permitted yet", '아직 서비스를 하지 않습니다.', context);
              },
              child: Column(
                children: <Widget>[
                  SvgPicture.asset(
                    "assets/image/menu/magnifying-glass.svg",
                    width: 50.0,
                    height: 50.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Join',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )),
      ],
    );
  }
}
