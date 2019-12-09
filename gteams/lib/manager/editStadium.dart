import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gteams/manager/usePhoto.dart';
import 'package:gteams/manager/stadiumWidget.dart';
import 'package:gteams/manager/managerSetTime.dart';
import 'package:gteams/util/timeUtil.dart';

class StadiumEditPage extends StatefulWidget{
  StadiumEditPage({@required this.refreshData, @required this.stdRef});

  final VoidCallback refreshData;
  final DocumentSnapshot stdRef;
  @override
  _StadiumEditPageState createState() => _StadiumEditPageState();
}

class _StadiumEditPageState extends State<StadiumEditPage>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File _photo;
  ImageProvider _image;

  String _stadiumName;
  String _stadiumDescription;
  String _selectedSports = null;
  String _locName = null;
  String _call;

  int _maxPeople;
  int _price;        // 전체 가격(원 단위), 1인당 가격은 _price / 플레이어수

  int _clothes;
  int _shoes;
  int _parking;
  int _shower;
  int _ball;

  List<int> _times;
  List<String> _strTimes;
  String _viewTimes;
  bool _checkTimes;

  List<String> _sports = ["Football", "Table Tennis", "Bowling", "Basketball", "Baseball"];

  TextEditingController _nameController;
  TextEditingController _descriptionController;
  TextEditingController _priceController;
  TextEditingController _callController;

  bool _isAvailable;
  bool _pictureChanged;

  String _address;
  String _locId;
  double _lat;
  double _lng;

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

  final Map<int, Widget> ballSeg = const <int, Widget>{
    0: Text('제공 안함'),
    1: Text('무료 제공'),
    2: Text('유료 제공')
  };


  void onPhotoPressed(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => ImageCapture(photo: _photo, onPressed: changePhoto, image: _image,)));
  }

  void onTimePressed(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => SetTime(timeFunc: timeFunc, timeList: _times)));
  }

  void timeFunc(List<int> times, List<String> strTimes){
    setState((){
      _checkTimes = true;
      _times = times;
      _strTimes = strTimes;
      _viewTimes = listTimeToStr(_strTimes);
    });
  }

  void changePhoto(File image){
    setState((){
      _photo = image;
      if(_photo != null) {
        _image = FileImage(_photo);
      }
      else{
        _image = null;
      }
      _pictureChanged = true;
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

  void onBallChanged(int val){
    setState((){
      _ball = val;
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
    _clothes = widget.stdRef["isClothes"];
    _shoes = widget.stdRef["isShoes"];
    _parking = widget.stdRef["isParking"];
    _shower = widget.stdRef["isShower"];
    _ball = widget.stdRef["isBall"];
    _nameController = TextEditingController();
    _stadiumName = widget.stdRef["stadiumName"];
    _descriptionController = TextEditingController();
    _stadiumDescription = widget.stdRef["stadiumDescription"];
    _priceController = TextEditingController();
    _price = widget.stdRef["price"];
    _callController = TextEditingController();
    _call = widget.stdRef["telephone"];
    _nameController.text = _stadiumName;
    _descriptionController.text = _stadiumDescription;
    _priceController.text = _price != null ? _price.toString() : null;
    _callController.text = _call;

    _nameController.addListener((){
      setState(() {
        _stadiumName = _nameController.text;
      });
    });

    _descriptionController.addListener((){
      setState(() {
        _stadiumDescription = _descriptionController.text;
      });
    });

    _priceController.addListener((){
      setState(() {
        if(_priceController.text.length != 0) {
          try {
            _price = int.parse(_priceController.text);
          }
          catch(e){
            if(_price != null) {
              _priceController.text = _price.toString();
              TextSelection cursorPos = TextSelection.fromPosition(
                  TextPosition(offset: _priceController.text.length)
              );
              _priceController.selection = cursorPos;
            }
            else{
              TextSelection cursorPos = TextSelection.fromPosition(
                  TextPosition(offset: 0)
              );
              _priceController.selection = cursorPos;
              _priceController.text = "";
            }
          }
        }
        else{
          _price = null;
        }
      });
    });

    _callController.addListener((){
      setState(() {
        _call = _callController.text;
      });
    });

    _times = List.from(widget.stdRef["intTimes"]);
    _strTimes = List.from(widget.stdRef["strTimes"]);
    _viewTimes = listTimeToStr(_strTimes);
    _locId = widget.stdRef["locId"];
    _lat = widget.stdRef["lat"];
    _lng = widget.stdRef["lng"];
    _checkTimes = true;
    _locName = widget.stdRef["location"];
    _isAvailable = true;
    _pictureChanged = false;
    _image = CachedNetworkImageProvider(widget.stdRef["imagePath"]);

    // Todo   수정 때는 위치는 수정 안되게, 그리고 보낼때 update로 보내게, 사진 바뀐거 확인, 그리고 문자 있는지 확인
  }

  void _getLocateData(address, locId, lat, lng){
    _locName = address;
    _locId = locId;
    _lat = lat;
    _lng = lng;
  }

  void locationPress(){
    // 수정시에는 위치 변경 불가
  }

  void setAvailable(bool state){
    setState(() {
      this._isAvailable = state;
    });
  }

  void _popThisContext(){
    Navigator.pop(context);
  }

  List<Widget> actWidget(){
    if(_isAvailable){
      print(_nameController.text);
      return [EditButton(formKey: _formKey, photo: _photo, stadiumName: _stadiumName, stadiumDescription: _stadiumDescription,
          price : _price.toString(), telephone : _call, isParking : _parking, isClothes :_clothes, isShower :_shower,isShoes : _shoes,isBall : _ball,
          refreshData: widget.refreshData, intTimes: _times, strTimes: _strTimes, setAvailable: setAvailable, popFunc: _popThisContext, isPhotoChanged: _pictureChanged, docId: widget.stdRef["stdId"],
      )];
    }
    else{
      return null;
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Color(0xff20253d),
            title: Center(child: Text('경기장 정보 수정')),
            actions: actWidget()
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
                                              PhotoWidget(image: _image, onPressed: onPhotoPressed,),
                                              SizedBox(height: 4.0),
                                              TextWidget(controller: _nameController, header: "경기장 이름", hint: "경기장 이름을 입력하시오", type: 0),
                                              SizedBox(height: 4.0),
                                              TextWidget(controller: _descriptionController, header: "경기장 소개", hint: "간단한 경기장 소개를 입력하시오", type: 0),
                                              SizedBox(height: 4.0),
                                              TextWidget(controller: _priceController, header: "30분당 사용 요금 (단위: 원)", hint: "30분당 사용 요금을 입력하시오", type: 1),
                                              SizedBox(height: 4.0),
                                              LocationWidget(location: _locName, onPressed: locationPress,),
                                              SizedBox(height: 4.0),
                                              TimeWidget(checkTimes: _checkTimes, strTimes: _viewTimes, onPressed: onTimePressed,),
                                              SizedBox(height: 4.0),
                                              PhoneWidget(controller: _callController),
                                              SizedBox(height: 4.0),
                                              SegmentedControl(header: "유니폼 제공 여부", value: _clothes, children: clothesSeg, onValueChanged: onClothesChanged),
                                              SizedBox(height: 4.0),
                                              SegmentedControl(header: "축구화 제공 여부", value: _shoes, children: shoesSeg, onValueChanged: onShoesChanged),
                                              SizedBox(height: 4.0),
                                              SegmentedControl(header: "주차장 제공 여부", value: _parking, children: parkSeg, onValueChanged: onParkChanged),
                                              SizedBox(height: 4.0),
                                              SegmentedControl(header: "축구공 제공 여부", value: _ball, children: ballSeg, onValueChanged: onBallChanged),
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