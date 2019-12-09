import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';

typedef selectFunc = void Function(int);
final GlobalKey<FormState> formKey = GlobalKey<FormState>();

class PhotoWidget extends StatelessWidget{
  PhotoWidget({this.photo});

  final ImageProvider photo;

  @override
  Widget build(BuildContext context){
    return InkWell(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
                width: MediaQuery.of(context).size.width * 1 / 3,
                height: MediaQuery.of(context).size.height * 1 / 6,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: photo != null? photo : AssetImage("assets/image/camera.png")
                    )
                )
            )
        )
    );
  }
}

class TextWidget extends StatelessWidget{
  TextWidget({this.text, this.header});

  String text;
  final String header;

  @override
  Widget build(BuildContext context){
    if(text == null){
      text = "작성된 내용이 없습니다.";
    }

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: Row(
            children: <Widget>[
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(header, style: TextStyle(
                            color: Colors.blueGrey, fontFamily: 'Dosis', fontWeight: FontWeight.w900, fontSize: 13
                        )),
                        Text(
                          text,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14
                          ),
                        ),
                        Divider(height: 1.0, color: Colors.black)
                      ]
                  )),]
        ));
  }
}

class PhoneWidget extends StatelessWidget{
  PhoneWidget({this.text});

  final String text;

  @override
  Widget build(BuildContext context){
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: Row(
            children: <Widget>[
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text("전화번호", style: TextStyle(
                                color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 13
                            )),
                            SizedBox(width: 8.0),
                            Icon(FontAwesomeIcons.phone, size: 15),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          text,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          ),
                        ),
                        Divider(height: 1.0, color: Colors.black)
                      ]
                  )),]
        )
    );
  }
}

class LocationWidget extends StatelessWidget{
  LocationWidget({this.location});

  final String location;


  @override
  Widget build(BuildContext context){
    return InkWell(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text("주소", style: TextStyle(
                                    color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 13
                                )),
                                SizedBox(width: 8.0),
                                Icon(FontAwesomeIcons.mapMarkedAlt, size: 15),
                              ],
                            ),
                            SizedBox(height: 4.0),
                            AutoSizeText(
                              location,
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              minFontSize: 13,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Divider(height: 1.0, color: Colors.black)
                          ]
                      )
                  )
                ]
            )
        )
    );
  }
}

class TimeWidget extends StatelessWidget{
  TimeWidget({this.checkTimes, this.strTimes});

  final String checkTimes;
  final String strTimes;

  @override
  Widget build(BuildContext context){
    return InkWell(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text("운영시간", style: TextStyle(
                                    color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 13
                                )),
                                SizedBox(width: 8.0),
                                Icon(FontAwesomeIcons.clock, size: 15),
                              ],
                            ),
                            SizedBox(height: 4.0),
                            AutoSizeText(
                                strTimes,
                                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                                minFontSize: 13.0,
                                maxLines: 100,
                                overflow: TextOverflow.ellipsis
                            ),
                            Divider(height: 1.0, color: Colors.black)
                          ]
                      )
                  )
                ]
            )
        )
    );
  }
}

class SegmentedControl extends StatelessWidget{
  SegmentedControl({this.header, this.value, this.children});

  final String header;
  final int value;
  final Map<int, Widget> children;

  @override
  Widget build(BuildContext context){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(header, style:TextStyle(
                  color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 13
              ))
          ),
          SizedBox(
              width: double.infinity,
              child: CupertinoSegmentedControl<int>(
                children: children,
                groupValue: value,
                borderColor: Color(0xff20253d),
                selectedColor: Color(0xff20253d),
                pressedColor: Color(0x0000253d),
                onValueChanged: (result){},
              )
          )
        ]
    );
  }
}
