import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gteams/manager_main/model/FacilitySchema.dart';

class FacilityWidget extends StatelessWidget {
  final LinearGradient theme;
  final Facility facility;

  // 생성자
  FacilityWidget({@required this.facility, @required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SvgPicture.asset(
          facility.image,
          width: 70.0,
          height: 70.0,
        ),
        Container(
          child: Column(
            children: <Widget>[
              Text(facility.name, style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w800, fontFamily: 'Dosis')),
             Align(
               alignment: Alignment.center,
               child:  Padding(
                 padding: EdgeInsets.only(top: 15.0),
                 child: facility.subtitle == null ? SizedBox(height: 17.0) :
                        Text( "• " + facility.subtitle + " •",
                          style: TextStyle(color: Colors.black, fontSize: 13.0, fontFamily: 'Dosis', fontWeight: FontWeight.w400),
                        ),
               ),
             )
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
              decoration: BoxDecoration(color: theme.colors[0]),
              width: 70,
              height: 1.0,
            ),
          ],
        ),
      ],
    );
  }
}
