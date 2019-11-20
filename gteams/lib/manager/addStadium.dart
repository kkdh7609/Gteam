import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gteams/map/google_map.dart';
import 'package:gteams/manager/usePhoto.dart';
import 'package:gteams/manager/stadiumWidget.dart';
import 'package:gteams/manager/managerSetTime.dart';

class StadiumCreatePage extends StatefulWidget{
  @override
  _StadiumCreatePageState createState() => _StadiumCreatePageState();
}

class _StadiumCreatePageState extends State<StadiumCreatePage>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ImageProvider _photo;

  String _stadiumName;
  String _selectedSports = null;
  String _locName = null;
  String _call;

  int _maxPeople;
  int _price;        // 전체 가격(원 단위), 1인당 가격은 _price / 플레이어수

  int _clothes = 0;
  int _shoes = 0;
  int _parking = 0;
  int _shower = 0;

  List<int> _times;
  bool _checkTimes = false;

  List<String> _sports = ["Football", "Table Tennis", "Bowling", "Basketball", "Baseball"];

  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _callController = TextEditingController();

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

  void onPhotoPressed(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => ImageCapture(photo: _photo, onPressed: changePhoto)));
  }

  void onTimePressed(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => SetTime(timeFunc: timeFunc)));
  }

  void timeFunc(List<List<int>> times){

  }

  void changePhoto(ImageProvider image){
    setState((){
      _photo = image;
    });
  }

  void onClothesChanged(int val){
    setState((){
      _clothes = val;
    });
  }

  void onShoesChanged(int val){
    setState((){
      _shoes = val;
    });
  }

  void onParkChanged(int val){
    setState((){
      _parking = val;
    });
  }

  void onShowerChanged(int val){
    setState((){
      _shower = val;
    });
  }

  String _phoneValidator(String value){
    Pattern pattern = r'[0-9]{2-4}-[0-9]{3-4}-[0-9]{3-4}';
    RegExp regex = new RegExp(pattern);
    if(!regex.hasMatch(value))
      return '잘못된 입력입니다. (123-456-789 형태로 입력해 주십시오)';
    else
      return null;
  }

  @override
  void initState(){
    super.initState();
    _nameController.text = _stadiumName;
    _priceController.text = _price != null ? _price.toString() : null;
    _callController.text = _call;
  }

  void locationPress(){
    setState(() {
      _stadiumName = 'hi';
      _stadiumName = "tt";
      _nameController.text = "tkt";
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff20253d),
        title: Text('Add new stadium'),
        actions: <Widget>[
          CheckButton(formKey: _formKey,)
        ]
      ),
      body: Form(
          key: _formKey,
          child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff20253d),
              Colors.white
            ]
          )
        ),

        padding: const EdgeInsets.all(8.0),
        child: Stack(
            children: <Widget>[
              Container(
                // 배경색 변화 문제 해결을 위해 사용
              ),
              SingleChildScrollView(
                  child: SafeArea(
                      child: Column(children: <Widget>[
                        Card(
                            elevation: 4.0,
                            child: Container(
                                color: Colors.white,
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      SizedBox(height: 16.0),
                                      PhotoWidget(photo: _photo, onPressed: onPhotoPressed,),
                                      SizedBox(height: 4.0),
                                      TextWidget(controller: _nameController, header: "경기장 이름", hint: "경기장 이름을 입력하시오", type: 0),
                                      SizedBox(height: 4.0),
                                      TextWidget(controller: _priceController, header: "요  금 (단위: 원)", hint: "30분당 사용 요금을 입력하시오", type: 1),
                                      SizedBox(height: 4.0),
                                      LocationWidget(location: _locName, onPressed: locationPress,),
                                      SizedBox(height: 4.0),
                                      TimeWidget(checkTimes: _checkTimes, onPressed: onTimePressed,),
                                      SizedBox(height: 4.0),
                                      PhoneWidget(controller: _callController),
                                      SizedBox(height: 4.0),
                                      SegmentedControl(header: "유니폼 제공 여부", value: _clothes, children: clothesSeg, onValueChanged: onClothesChanged),
                                      SizedBox(height: 4.0),
                                      SegmentedControl(header: "축구화 제공 여부", value: _shoes, children: shoesSeg, onValueChanged: onShoesChanged),
                                      SizedBox(height: 4.0),
                                      SegmentedControl(header: "주차장 제공 여부", value: _parking, children: parkSeg, onValueChanged: onParkChanged),
                                      SizedBox(height: 4.0),
                                      SegmentedControl(header: "샤워 시설 제공 여부", value: _shower, children: showerSeg, onValueChanged: onShowerChanged),
                                      SizedBox(height: 16.0)
                                    ]
                                )
                            )
                        ),
                        Card(
                            elevation: 4.0,
                            child: Container(
                                color: Color(0xff20253d)
                              // Todo add child
                            )
                        ),
                      ])
                  )
              ),
            ]
        )
      )
    ));
  }
}
