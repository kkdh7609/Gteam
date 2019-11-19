import 'package:flutter/material.dart';
import 'package:gteams/map/mapWidget.dart';
import 'package:gteams/map/StadiumListData.dart';

typedef selectFunc = void Function(String,String);

class CustomDialog extends StatelessWidget{
  CustomDialog({this.stadiumData, this.onSelected, this.onPop});

  final StadiumListData stadiumData;
  final selectFunc onSelected;
  final VoidCallback onPop;

  String stadiumName = "Gteam 경기장";
  String price = "70000";
  String callNum = "010-1234-5678";
  String times = "Temp";


  int clothesVal = 0;
  int shoesVal = 0;
  int parkVal = 0;
  int showerVal = 0;

  final Map<int, Widget> clothesSeg = const <int, Widget>{
    0: Text('제공 안함'),
    1: Text('무료 제공'),
    2: Text('유료 제공')
  };

  final Map<int, Widget> shoesSeg = const <int, Widget>{
    0: Text('제공 안함'),
    1: Text('무료 제공'),
    2: Text('유료 제공')
  };

  final Map<int, Widget> parkSeg = const <int, Widget>{
    0: Text('제공 안함'),
    1: Text('무료 제공'),
    2: Text('유료 제공')
  };

  final Map<int, Widget> showerSeg = const <int, Widget>{
    0: Text('제공 안함'),
    1: Text('무료 제공'),
    2: Text('유료 제공')
  };

  _onConfirmPressed(){
    onSelected(stadiumData.stadiumName,stadiumData.id);
    onPop();
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
        child: SafeArea(
            child: Column(
          children: <Widget>[
            Card(
                elevation: 4.0,
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(height: 16.0),
                          PhotoWidget(),
                          SizedBox(height: 4.0),
                          TextWidget(header: "경기장 이름", text: stadiumData.stadiumName),
                          SizedBox(height: 4.0),
                          TextWidget(header: "30분당 이용 요금(단위: 원)", text: stadiumData.price.toString()),
                          SizedBox(height: 4.0),
                          LocationWidget(location: stadiumData.location),
                          SizedBox(height: 4.0),
                          TimeWidget(checkTimes: times,),
                          SizedBox(height: 4.0),
                          PhoneWidget(text: stadiumData.telephone),
                          SizedBox(height: 4.0),
                          SegmentedControl(header: "유니폼 제공 여부", value: clothesVal, children: clothesSeg),
                          SizedBox(height: 4.0),
                          SegmentedControl(header: "축구화 제공 여부", value: shoesVal, children: shoesSeg),
                          SizedBox(height: 4.0),
                          SegmentedControl(header: "주차장 제공 여부", value: parkVal, children: parkSeg),
                          SizedBox(height: 4.0),
                          SegmentedControl(header: "샤워 시설 제공 여부", value: showerVal, children: showerSeg),
                          SizedBox(height: 48.0)
                        ]
                    )
                )
            )
          ]
        ))),
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color:Color(0xff20253d)
              ),
                child: FlatButton(
                  onPressed: () => _onConfirmPressed(),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[Text("Confirm" , style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                          color: Colors.white)
                      )]),
              ),
            ))
            )
        ]);
  }

  @override
  Widget build(BuildContext context){
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      child: dialogContent(context),
    );
  }
}
