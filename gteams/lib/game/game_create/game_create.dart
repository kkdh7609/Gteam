import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gteams/root_page.dart';
import 'package:gteams/services/crud.dart';
import 'package:gteams/map/google_map.dart';
import 'package:gteams/game/game_create/GameCreateTheme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gteams/map/StadiumListData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gteams/util/customTimePicker.dart';
import 'package:gteams/pay/payMethod.dart';

class GameCreatePage extends StatefulWidget {
  @override
  _GameCreatePageState createState() => _GameCreatePageState();
}

enum Gender { MALE, FEMALE, ALL }

class _GameCreatePageState extends State<GameCreatePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  crudMedthods crudObj = new crudMedthods();
  PayMethods payObj = new PayMethods();
  var stadiumList =StadiumListData.stadiumList;

  String _gameName;
  String _selectedSports = null;
  String _dateText = "Select Date";
  String _startTimeText = "Start Time";
  String _endTimeText = "End Time";
  String _loc_name = "Select Location";
  String _stadium_id = "temp Id";
  DocumentReference _stadiumRef ;
  var userList = [];

  int _groupSize;
  int _gameLevel;
  int _curStep = 0;
  int _dateNumber;

  Gender _selectedGender = null;

  List<DropdownMenuItem<String>> _sportsList = [];
  List<String> _sports = ["Football", "Table Tennis", "Bowling", "Basketball", "Baseball"];

  DateTime _date = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();

  TextEditingController _textEditingController = TextEditingController();

  bool _completeDate = false;
  bool _completeStartTime = false;
  bool _completeEndTime = false;

  @override
  void initState(){
    super.initState();
  }

  void loadData() {
    _sportsList = [];
    _sportsList = _sports
        .map((val) => DropdownMenuItem<String>(
      child: Text(val),
      value: val,
    ))
        .toList();
  }

  Widget _alertButton(){
    return FlatButton(
      child: Text("OK"),
      onPressed: (){
        Navigator.of(context).pop();
      },
    );
  }

  AlertDialog _alertDialog(title, text){
    return AlertDialog(
        title: Text(title),
        content: Text(text),
        actions: <Widget>[
          _alertButton(),
        ]
    );
  }

  _showAlertDialog(title, text){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return _alertDialog(title, text);
        }
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime _pickedDate = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime.now().subtract(Duration(days: 1)),
        lastDate: _date.add(Duration(days: 100)));

    if (_pickedDate != null && (_pickedDate != _date || !_completeDate)) {
      setState(() {
        _date = _pickedDate;
        _completeDate = true;
        _dateNumber=_date.millisecondsSinceEpoch;
        _dateText = _date.toString().split(" ")[0];
        _completeStartTime = false;
        _completeEndTime = false;
        if(_date.isAfter(DateTime.now())){
          _startTime = TimeOfDay(hour: 0, minute: 0);
          _endTime = TimeOfDay(hour: 0, minute: 0);
        }
        else{
          _startTime = TimeOfDay.now();
          _endTime = TimeOfDay.now();
        }
        _startTimeText = "Start Time";
        _endTimeText = "End Time";
      });
    }
  }

  Future<Null> _selectStart(BuildContext context) async {
    final TimeOfDay _pickedStart = await showCustomTimePicker(context: context, initialTime: _startTime);

    if (_pickedStart != null && (_pickedStart != _startTime || !_completeStartTime)) {
      setState(() {
        if(_completeEndTime){
          int intPickedStart = _pickedStart.hour * 100 + _pickedStart.minute;
          int intEndTime = _endTime.hour * 100 + _endTime.minute;

          if(intPickedStart >= intEndTime){
             _showAlertDialog("변경 실패", "시작 시간은 종료 시간보다 빨라야 합니다.");
          }
          else{
            _completeStartTime = true;
            _startTime = _pickedStart;
            _startTimeText = _startTime.toString().split("(")[1].split(")")[0];
          }
        }
        else {
          _completeStartTime = true;
          _startTime = _pickedStart;
          _startTimeText = _startTime.toString().split("(")[1].split(")")[0];
        }
      });
    }
  }

  Future<Null> _selectEnd(BuildContext context) async {
    final TimeOfDay _pickedEnd = await showCustomTimePicker(context: context, initialTime: _endTime);

    if (_pickedEnd != null && (_pickedEnd != _endTime || !_completeEndTime)) {
      setState(() {
        if(_completeStartTime){
          int intPickedStart = _pickedEnd.hour * 100 + _pickedEnd.minute;
          int intStartTime = _startTime.hour * 100 + _startTime.minute;

          if(intPickedStart <= intStartTime){
             _showAlertDialog("변경 실패", "종료 시간은 시작 시간보다 늦어야 합니다.");
          }
          else{
            _completeEndTime = true;
            _endTime = _pickedEnd;
            _endTimeText = _endTime.toString().split("(")[1].split(")")[0];
          }
        }
        else {
          _completeEndTime = true;
          _endTime = _pickedEnd;
          _endTimeText = _endTime.toString().split("(")[1].split(")")[0];
        }
      });
    }
  }

  void _change_loc_name(String new_name, String new_id) {
  _loc_name = new_name;
  _stadium_id = new_id;
  }

  @override
  Widget build(BuildContext context) {
    loadData();
    List<Step> steps = [
      Step(
        title: const Text(
          "What",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        isActive: true,
        state: StepState.indexed,
        content: _showGameType(),
      ),
      Step(
          title: const Text(
            "When",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          isActive: true,
          state: StepState.indexed,
          content: Column(
            children: <Widget>[_showGameDate(), _showGameTime()],
          )
      ),
      Step(
          title: const Text(
            "Where",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          isActive: true,
          state: StepState.indexed,
          content: _showGameLoc()),
      Step(
          title: const Text(
            "Extra",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          isActive: true,
          state: StepState.indexed,
          content: Column(
            children: <Widget>[_showGameGender(), _showGameMember(), _showGameLevel()],
          ))
    ];

    return Scaffold(
      appBar: AppBar(
          title: Text("Create the Game", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22, color: Colors.white)),
          centerTitle: true,
          backgroundColor: GameCreateTheme.buildLightTheme().primaryColor),
      body: Container(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _showGameTitle("게임 이름"),
                _showGameName(),
                Theme(
                  data: ThemeData(fontFamily: 'Dosis', primaryColor: GameCreateTheme.buildLightTheme().primaryColor),
                  child: Stepper(
                    steps: steps,
                    type: StepperType.vertical,
                    currentStep: this._curStep,
                    onStepContinue: () {
                      setState(() {
                        if (this._curStep < steps.length - 1) {
                          this._curStep = this._curStep + 1;
                        } else {
                          this._curStep = 0;
                        }
                      });
                    },
                    onStepCancel: () {
                      setState(() {
                        if (this._curStep > 0) {
                          this._curStep = this._curStep - 1;
                        } else {
                          this._curStep = 0;
                        }
                      });
                    },
                    onStepTapped: (step) {
                      setState(() {
                        this._curStep = step;
                      });
                    },
                  ),
                ),
                _game_create()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _showGameTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 20.0),
      child: Text(
        title,
        style: TextStyle(color: Colors.black, fontFamily: 'Dosis', fontWeight: FontWeight.w900, fontSize: 16.0),
      ),
    );
  }

  Widget _showGameName() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(24.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.transparent,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: _textEditingController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: '게임 이름 입력',
                      hintStyle: TextStyle(fontFamily: 'Dosis', fontWeight: FontWeight.w400, color: Colors.grey),
                    ),
                    validator: (value) {
                      return value.isEmpty ? "Game name can\'t be empty" : null;
                    },
                    onSaved: (value) {
                      _gameName = value;
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _showGameType() {
    return Container(
      child: Row(
        children: <Widget>[
          new Padding(padding: EdgeInsets.symmetric(horizontal: 15.0), child: Icon(Icons.check, color: Colors.black)),
          Container(
            height: 30.0,
            width: 1.0,
            color: GameCreateTheme.buildLightTheme().primaryColor.withOpacity(0.5),
            margin: const EdgeInsets.only(right: 10.0),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton(
              value: _selectedSports,
              items: _sportsList,
              hint: Text("Select sports"),
              iconSize: 40.0,
              onChanged: (value) {
                _selectedSports = value;
                setState(() {});
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _showGameDate() {
    return Container(
      child: Row(
        children: <Widget>[
          new Padding(padding: EdgeInsets.symmetric(horizontal: 15.0), child: Icon(Icons.date_range, color: Colors.black)),
          Container(
            height: 30.0,
            width: 1.0,
            color: GameCreateTheme.buildLightTheme().primaryColor.withOpacity(0.5),
            margin: const EdgeInsets.only(right: 10.0),
          ),
          SizedBox(
            width: (MediaQuery.of(context).size.width / 4) + 12,
            height: 40,
            child: FlatButton(
              color: GameCreateTheme.buildLightTheme().primaryColor.withOpacity(0.2),
              child: Text(_dateText, style: TextStyle(fontSize: 16, fontFamily: 'Dosis', fontWeight: FontWeight.w700)),
              onPressed: () {
                _selectDate(context);
              },
            ),
          ),
          SizedBox(height: 60)
        ],
      ),
    );
  }

  Widget _showGameTime() {
    return Container(
      child: Row(
        children: <Widget>[
          new Padding(padding: EdgeInsets.symmetric(horizontal: 15.0), child: Icon(Icons.access_time, color: Colors.black)),
          Container(
            height: 30.0,
            width: 1.0,
            color: GameCreateTheme.buildLightTheme().primaryColor.withOpacity(0.2),
            margin: const EdgeInsets.only(right: 10.0),
          ),
          SizedBox(
            width: (MediaQuery.of(context).size.width / 4) + 12,
            height: 40,
            child: FlatButton(
              color: GameCreateTheme.buildLightTheme().primaryColor.withOpacity(0.2),
              child: Text(_startTimeText, style: TextStyle(fontSize: 16, fontFamily: 'Dosis', fontWeight: FontWeight.w700)),
              onPressed: !_completeDate ? (){} : () {
                _selectStart(context);
              },
            ),
          ),
          SizedBox(width: 5),
          Text("~", style: TextStyle(fontSize: 16, fontFamily: 'Dosis', fontWeight: FontWeight.w400)),
          SizedBox(width: 5),
          SizedBox(
            width: (MediaQuery.of(context).size.width / 4) + 12,
            height: 40,
            child: FlatButton(
              color: GameCreateTheme.buildLightTheme().primaryColor.withOpacity(0.2),
              child: Text(_endTimeText, style: TextStyle(fontSize: 16, fontFamily: 'Dosis', fontWeight: FontWeight.w700)),
              onPressed: !_completeDate ? (){} : () {
                _selectEnd(context);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _showGameLoc(){
    return StreamBuilder<QuerySnapshot>(
        stream  : Firestore.instance.collection("stadium").snapshots(),
        builder : (context, snapshot ,){
          if(!snapshot.hasData) return LinearProgressIndicator();
          return Container(
            child: Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.symmetric(horizontal: 15.0), child: Icon(Icons.location_on, color: Colors.black)),
                Container(
                  height: 30.0,
                  width: 1.0,
                  color: GameCreateTheme.buildLightTheme().primaryColor.withOpacity(0.5),
                  margin: const EdgeInsets.only(right: 10.0),
                ),
                Expanded(
                  child: FlatButton(
                    child: Text(_loc_name),
                    onPressed: () {
                      this.stadiumList=snapshot.data.documents.map((data) => StadiumListData.fromJson(data.data)).toList();
                      //snapshot.data.documents[0].documentID
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MapTest(onSelected: _change_loc_name, nowReq: mapReq.findLocation,stadiumList: stadiumList,)));
                    },
                  ),
                ),
              ],
            ),
          );
        }
    );
  }


  Widget _showGameGender() {
    return Container(
      child: Row(
        children: <Widget>[
          new Padding(padding: EdgeInsets.symmetric(horizontal: 15.0), child: Icon(Icons.wc, color: Colors.black)),
          Container(
            height: 30.0,
            width: 1.0,
            color: GameCreateTheme.buildLightTheme().primaryColor.withOpacity(0.5),
            margin: const EdgeInsets.only(right: 10.0),
          ),
          Radio(
            value: Gender.MALE,
            groupValue: _selectedGender,
            activeColor: GameCreateTheme.buildLightTheme().primaryColor,
            onChanged: (Gender value) {
              setState(
                    () {
                  _selectedGender = value;
                },
              );
            },
          ),
          Text("Male", style: TextStyle(fontFamily: 'Dosis', fontWeight: FontWeight.w700, fontSize: 16)),
          Radio(
            value: Gender.FEMALE,
            groupValue: _selectedGender,
            activeColor: GameCreateTheme.buildLightTheme().primaryColor,
            onChanged: (Gender value) {
              setState(
                    () {
                  _selectedGender = value;
                },
              );
            },
          ),
          Text("Female", style: TextStyle(fontFamily: 'Dosis', fontWeight: FontWeight.w700, fontSize: 16)),
          Radio(
            value: Gender.ALL,
            groupValue: _selectedGender,
            activeColor: GameCreateTheme.buildLightTheme().primaryColor,
            onChanged: (Gender value) {
              setState(
                    () {
                  _selectedGender = value;
                },
              );
            },
          ),
          Text("All", style: TextStyle(fontFamily: 'Dosis', fontWeight: FontWeight.w700, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _showGameMember() {
    return Container(
      child: Row(
        children: <Widget>[
          new Padding(padding: EdgeInsets.symmetric(horizontal: 15.0), child: Icon(Icons.group, color: Colors.black)),
          Container(
            height: 30.0,
            width: 1.0,
            color: GameCreateTheme.buildLightTheme().primaryColor.withOpacity(0.5),
            margin: const EdgeInsets.only(right: 10.0),
          ),
          Flexible(
            child: TextFormField(
              inputFormatters: [LengthLimitingTextInputFormatter(2)],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Group Size',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              validator: (value) {
                return value.isEmpty ? "Group size can\'t be empty" : null;
              },
              onSaved: (value) {
                _groupSize = int.parse(value);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _showGameLevel() {
    return Container(
      child: Row(
        children: <Widget>[
          Padding(padding: EdgeInsets.symmetric(horizontal: 15.0), child: Icon(Icons.thumb_up, color: Colors.black)),
          Container(
            height: 30.0,
            width: 1.0,
            color: GameCreateTheme.buildLightTheme().primaryColor.withOpacity(0.5),
            margin: const EdgeInsets.only(right: 10.0),
          ),
          Flexible(
            child: TextFormField(
              inputFormatters: [LengthLimitingTextInputFormatter(2)],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Game Level (',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              validator: (value) {
                return value.isEmpty ? "Game level can\'t be empty" : null;
              },
              onSaved: (value) {
                _gameLevel = int.parse(value);
              },
            ),
          )
        ],
      ),
    );
  }

  void _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('확인'),
            content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text("게임 이름 : " + _textEditingController.text),
                    Text("게임 종목: $_selectedSports"),
                    Text("게임 날짜 : $_dateText"),
                    Text("게임 시간 : $_startTimeText ~ $_endTimeText"),
                    Text("게임을 만드시겠습니까?")
                  ],
                )),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('취소')),
              FlatButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    int startMinute = _startTime.minute;
                    int endMinute = _endTime.minute;
                    int startHour = _startTime.hour;
                    int endHour = _endTime.hour;

                    int usingMinute;
                    int usingHour;
                    int timeBlock; // 사용하는 시간을 30분 단위로 끊었을 때 나오는 블럭 수

                    int totalPrice;
                    int perPrice;

                    int tempPrice = 35000; // 경기장 정보 들어오면 그거 쓰기

                    if (endMinute == 00 && startMinute == 30) {
                      endHour -= 1;
                      usingMinute = 30;
                    }
                    else {
                      usingMinute = endMinute - startMinute;
                    }

                    usingHour = endHour - startHour;
                    timeBlock = usingHour * 2 + (usingMinute == 30 ? 1 : 0);

                    totalPrice = tempPrice * timeBlock; // 경기장 정보 들어오면 그거 쓰기
                    perPrice = totalPrice ~/ _groupSize;

                    payObj.getFund().then((fundData) {
                      if (fundData >= perPrice) {
                        crudObj.getDocumentByWhere('stadium', 'id', _stadium_id).then((document){
                          _stadiumRef = document.documents[0].reference;
                          this.userList.add(RootPage.user_email);
                          int newFund = fundData - perPrice;
                          payObj.updateFund(newFund).then((waitData1) {
                            crudObj.addData('game3', {
                              'gameName': _gameName,
                              'selectedSport': _selectedSports,
                              'dateText': _dateText,
                              'startTime': _startTimeText,
                              'endTime': _endTimeText,
                              'groupSize': _groupSize,
                              'gameLevel': _gameLevel,
                              'Gender': _selectedGender.toString(),
                              'loc_name': _loc_name,
                              'perPrice' : perPrice,
                              'totalPrice' : totalPrice,
                              'dateNumber': _dateNumber,
                              'sort' : FieldValue.serverTimestamp(),
                              'stadiumRef' : _stadiumRef,
                              'userList' : userList,
                            });
                            Navigator.pop(context);
                            Navigator.pop(context);
                          });
                        });
                      }
                      else{
                        _showAlertDialog("참가 실패", "포인트가 부족합니다");
                      }
                    });
                  }
                },
                child: Text('생성'),
              )
            ],
          );
        });
  }

  Widget _game_create() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: GameCreateTheme.buildLightTheme().primaryColor.withOpacity(0.2),
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: RaisedButton(
            color: GameCreateTheme.buildLightTheme().primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(24.0)),
            ),
            onPressed: () {
              if(_textEditingController.text.length == 0){
                _showAlertDialog("생성 실패", "경기장 이름을 입력해주세요.");
              }
              else if(_selectedSports == null){
                _showAlertDialog("생성 실패", "스포츠를 선택해주세요.");
              }
              else if(!_completeDate){
                _showAlertDialog("생성 실패", "날짜를 선택해주세요.");
              }
              else if(!_completeStartTime){
                _showAlertDialog("생성 실패", "시작 시간을 선택해주세요.");
              }
              else if(!_completeEndTime){
                _showAlertDialog("생성 실패", "종료 시간을 선택해주세요.");
              }
              // Todo 위의 내용 이외의 내용들 예외처리 필요
              else{
                _showMaterialDialog();
              }
            },
            child: Center(
              child: Text(
                "Create Game",
                style: TextStyle(fontFamily: 'Dosis', fontWeight: FontWeight.w500, fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
