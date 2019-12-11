import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:gteams/root_page.dart';
import 'package:gteams/services/crud.dart';
import 'package:gteams/map/google_map.dart';
import 'package:gteams/game/game_create/GameCreateTheme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gteams/map/StadiumListData.dart';
import 'package:gteams/util/customTimePicker.dart';
import 'package:gteams/util/timeUtil.dart';
import 'package:gteams/pay/payMethod.dart';

class GameCreatePage extends StatefulWidget {
  @override
  _GameCreatePageState createState() => _GameCreatePageState();
}

enum Gender { MALE, FEMALE, ALL }

class _GameCreatePageState extends State<GameCreatePage> {
  List<dynamic> userGameList = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  crudMedthods crudObj;
  PayMethods payObj;
  List<StadiumListData> stadiumList;

  String _gameName;
  String _selectedSports;
  String _dateText;
  String _startTimeText;
  String _endTimeText;
  String _loc_name;
  String _stadium_id;
  String _stadiumId;
  String _stdId;
  String _gameDescription;
  DocumentReference _stadiumRef;

  var userList;

  int _groupSize;
  int _gameLevel;
  int _curStep;
  int _dateNumber;

  Gender _selectedGender;

  List<DropdownMenuItem<String>> _sportsList;
  List<String> _sports;

  DateTime _date;
  TimeOfDay _startTime;
  TimeOfDay _endTime;

  TextEditingController _textEditingController;
  TextEditingController _textEditingController_size;
  TextEditingController _textEditingController_level;
  TextEditingController _textEditingController_description;

  bool _completeDate;
  bool _completeStartTime;
  bool _completeEndTime;

  bool isAvailable;

  @override
  void initState() {
    userGameList = [];
    crudObj = crudMedthods();
    payObj = PayMethods();
    stadiumList = StadiumListData.stadiumList;

    _stadiumId = null;
    _gameName = null;
    _selectedSports = null;
    _groupSize = null;
    _gameLevel = null;
    _dateNumber = null;
    _dateText = "날짜 선택";
    _startTimeText = "시작 시간";
    _endTimeText = "종료 시간";
    _loc_name = "장소 선택";
    _stadium_id = "temp Id";
    _stdId = "temp Id";
    userList = [];
    _curStep = 0;
    _selectedGender = null;
    _sportsList = [];
    _sports = ["풋살"];
    _date = DateTime.now();
    _startTime = TimeOfDay.now();
    _endTime = TimeOfDay.now();

    _textEditingController = TextEditingController();
    _textEditingController_size = TextEditingController();
    _textEditingController_level = TextEditingController();
    _textEditingController_description = TextEditingController();

    _completeDate = false;
    _completeStartTime = false;
    _completeEndTime = false;

    isAvailable = true;

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

  Widget _alertButton() {
    return FlatButton(
      color: Color(0xff20253d),
      child: Text("OK", style: TextStyle(color: Colors.white)),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  AlertDialog _alertDialog(title, text) {
    return AlertDialog(
        title: Text(title),
        content: Text(text),
        actions: <Widget>[
          _alertButton(),
        ]);
  }

  _showAlertDialog(title, text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return _alertDialog(title, text);
        });
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime _pickedDate = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime.now().subtract(Duration(days: 1)),
        lastDate: _date.add(Duration(days: 100)));
    DateFormat dateFormat = DateFormat("yy-MM-dd");

    if (_pickedDate != null && (_pickedDate != _date || !_completeDate)) {
      setState(() {
        _date = _pickedDate;
        _completeDate = true;
        _dateNumber = _date.millisecondsSinceEpoch;
        _dateText = dateFormat.format(_date);
        _completeStartTime = false;
        _completeEndTime = false;
        if (_date.isAfter(DateTime.now())) {
          _startTime = TimeOfDay(hour: 0, minute: 0);
          _endTime = TimeOfDay(hour: 0, minute: 0);
        } else {
          _startTime = TimeOfDay.now();
          _endTime = TimeOfDay.now();
        }
        _startTimeText = "Start Time";
        _endTimeText = "End Time";
      });
    }
  }

  Future<Null> _selectStart(BuildContext context) async {
    final TimeOfDay _pickedStart =
    await showCustomTimePicker(context: context, initialTime: _startTime);

    if (_pickedStart != null &&
        (_pickedStart != _startTime || !_completeStartTime)) {
      setState(() {
        if (_completeEndTime) {
          int intPickedStart = _pickedStart.hour * 100 + _pickedStart.minute;
          int intEndTime = _endTime.hour * 100 + _endTime.minute;

          if (intPickedStart >= intEndTime) {
            _showAlertDialog("변경 실패", "시작 시간은 종료 시간보다 빨라야 합니다.");
          } else {
            _completeStartTime = true;
            _startTime = _pickedStart;
            _startTimeText = _startTime.toString().split("(")[1].split(")")[0];
          }
        } else {
          _completeStartTime = true;
          _startTime = _pickedStart;
          _startTimeText = _startTime.toString().split("(")[1].split(")")[0];
        }
      });
    }
  }

  Future<Null> _selectEnd(BuildContext context) async {
    TimeOfDay _pickedEnd =
    await showCustomTimePicker(context: context, initialTime: _endTime);

    if (_pickedEnd != null && (_pickedEnd != _endTime || !_completeEndTime)) {
      setState(() {
        if (_pickedEnd.hour == 0 && _pickedEnd.minute == 0) {
          _pickedEnd = TimeOfDay(hour: 24, minute: 0);
        }
        if (_completeStartTime) {
          int intPickedStart = _pickedEnd.hour * 100 + _pickedEnd.minute;
          int intStartTime = _startTime.hour * 100 + _startTime.minute;

          if (intPickedStart <= intStartTime) {
            _showAlertDialog("변경 실패", "종료 시간은 시작 시간보다 늦어야 합니다.");
          } else {
            _completeEndTime = true;
            _endTime = _pickedEnd;
            _endTimeText = _endTime.toString().split("(")[1].split(")")[0];
          }
        } else {
          _completeEndTime = true;
          _endTime = _pickedEnd;
          _endTimeText = _endTime.toString().split("(")[1].split(")")[0];
        }
      });
    }
  }

  void _change_loc_name(
      String new_name, String new_id, String new_stdId) async {
    _loc_name = new_name;
    _stadium_id = new_id;
    _stdId = new_stdId;
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
          )),
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
            children: <Widget>[_showGameGender(), _showGameMember(), _showGameLevel(), _showDescription()],
          ))
    ];

    return Scaffold(
      appBar: AppBar(
          title: Text("게임 생성",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                  color: Colors.white)),
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
                  data: ThemeData(
                      fontFamily: 'Dosis',
                      primaryColor:
                      GameCreateTheme.buildLightTheme().primaryColor),
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
        style: TextStyle(
            color: Colors.black,
            fontFamily: 'Dosis',
            fontWeight: FontWeight.w900,
            fontSize: 16.0),
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
                    inputFormatters: [LengthLimitingTextInputFormatter(15)],
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: '게임 이름 입력',
                      hintStyle: TextStyle(
                          fontFamily: 'Dosis',
                          fontWeight: FontWeight.w400,
                          color: Colors.grey),
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
          new Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Icon(Icons.check, color: Colors.black)),
          Container(
            height: 30.0,
            width: 1.0,
            color:
            GameCreateTheme.buildLightTheme().primaryColor.withOpacity(0.5),
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
          new Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Icon(Icons.date_range, color: Colors.black)),
          Container(
            height: 30.0,
            width: 1.0,
            color:
            GameCreateTheme.buildLightTheme().primaryColor.withOpacity(0.5),
            margin: const EdgeInsets.only(right: 10.0),
          ),
          SizedBox(
            width: (MediaQuery.of(context).size.width / 4) + 12,
            height: 40,
            child: FlatButton(
              color: GameCreateTheme.buildLightTheme()
                  .primaryColor
                  .withOpacity(0.2),
              child: Text(_dateText,
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Dosis',
                      fontWeight: FontWeight.w700)),
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
          new Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Icon(Icons.access_time, color: Colors.black)),
          Container(
            height: 30.0,
            width: 1.0,
            color:
            GameCreateTheme.buildLightTheme().primaryColor.withOpacity(0.2),
            margin: const EdgeInsets.only(right: 10.0),
          ),
          SizedBox(
            width: (MediaQuery.of(context).size.width / 4) + 12,
            height: 40,
            child: FlatButton(
              color: GameCreateTheme.buildLightTheme()
                  .primaryColor
                  .withOpacity(0.2),
              child: Text(_startTimeText,
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Dosis',
                      fontWeight: FontWeight.w700)),
              onPressed: !_completeDate
                  ? () {}
                  : () {
                _selectStart(context);
              },
            ),
          ),
          SizedBox(width: 5),
          Text("~",
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Dosis',
                  fontWeight: FontWeight.w400)),
          SizedBox(width: 5),
          SizedBox(
            width: (MediaQuery.of(context).size.width / 4) + 12,
            height: 40,
            child: FlatButton(
              color: GameCreateTheme.buildLightTheme()
                  .primaryColor
                  .withOpacity(0.2),
              child: Text(_endTimeText,
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Dosis',
                      fontWeight: FontWeight.w700)),
              onPressed: !_completeDate
                  ? () {}
                  : () {
                _selectEnd(context);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _showGameLoc() {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("stadium").snapshots(),
        builder: (
            context,
            snapshot,
            ) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          return Container(
            child: Row(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Icon(Icons.location_on, color: Colors.black)),
                Container(
                  height: 30.0,
                  width: 1.0,
                  color: GameCreateTheme.buildLightTheme()
                      .primaryColor
                      .withOpacity(0.5),
                  margin: const EdgeInsets.only(right: 10.0),
                ),
                Expanded(
                  child: FlatButton(
                    child: Text(_loc_name),
                    onPressed: () async {
                      if (!this._completeEndTime || !this._completeStartTime) {
                        _showAlertDialog("에러", "경기 시간을 먼저 선택해주세요.");
                      } else {
                        if (isAvailable) {
                          isAvailable = false;
                          this.stadiumList = snapshot.data.documents
                              .map(
                                  (data) => StadiumListData.fromJson(data.data))
                              .toList();
                          List<StadiumListData> usingList = [];
                          DateFormat dateFormat = DateFormat("yy-MM-dd");
                          String pickDate = dateFormat.format(_date);
                          int usingTime = partTimeToTotalTime(
                              _startTime.hour,
                              _startTime.minute,
                              _endTime.hour,
                              _endTime.minute);
                          for (int index = 0;
                          index < this.stadiumList.length;
                          index++) {
                            var dateRef = await snapshot
                                .data.documents[index].reference
                                .collection("date")
                                .document(pickDate)
                                .get();
                            if (dateRef.data == null) {
                              int totalTime = 281474976710655 -
                                  this
                                      .stadiumList[index]
                                      .intTimes[_date.weekday - 1];
                              if (totalTime & usingTime == 0) {
                                usingList.add(this.stadiumList[index]);
                              }
                            } else {
                              if (dateRef.data['totalTime'] & usingTime == 0) {
                                usingList.add(this.stadiumList[index]);
                              }
                            }
                          }
                          //snapshot.data.documents[0].documentID
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MapTest(
                                      onSelected: _change_loc_name,
                                      nowReq: mapReq.findLocation,
                                      stadiumList: usingList //stadiumList,
                                  )));
                          isAvailable = true;
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _showGameGender() {
    return Container(
      child: Row(
        children: <Widget>[
          new Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Icon(Icons.wc, color: Colors.black)),
          Container(
            height: 30.0,
            width: 1.0,
            color:
            GameCreateTheme.buildLightTheme().primaryColor.withOpacity(0.5),
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
          Text("남성",
              style: TextStyle(
                  fontFamily: 'Dosis',
                  fontWeight: FontWeight.w700,
                  fontSize: 16)),
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
          Text("여성", style: TextStyle(fontFamily: 'Dosis', fontWeight: FontWeight.w700, fontSize: 16)),
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
          Text("모두", style: TextStyle(fontFamily: 'Dosis', fontWeight: FontWeight.w700, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _showGameMember() {
    return Container(
      child: Row(
        children: <Widget>[
          new Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Icon(Icons.group, color: Colors.black)),
          Container(
            height: 30.0,
            width: 1.0,
            color:
            GameCreateTheme.buildLightTheme().primaryColor.withOpacity(0.5),
            margin: const EdgeInsets.only(right: 10.0),
          ),
          Flexible(
            child: TextFormField(
              controller: _textEditingController_size,
              inputFormatters: [LengthLimitingTextInputFormatter(2)],
              enableInteractiveSelection: false,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '모집 인원 입력(1 ~ 30)',
                hintStyle: TextStyle(color: Colors.grey),
              ),
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
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Icon(Icons.thumb_up, color: Colors.black)),
          Container(
            height: 30.0,
            width: 1.0,
            color:
            GameCreateTheme.buildLightTheme().primaryColor.withOpacity(0.5),
            margin: const EdgeInsets.only(right: 10.0),
          ),
          Flexible(
            child: TextFormField(
              controller: _textEditingController_level,
              inputFormatters: [LengthLimitingTextInputFormatter(2)],
              enableInteractiveSelection: false,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '희망 수준 입력(1 ~ 10)',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              onSaved: (value) {
                _gameLevel = int.parse(value);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _showDescription() {
    return Container(
      child: Row(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Icon(Icons.description, color: Colors.black)),
          Container(
            height: 30.0,
            width: 1.0,
            color:
            GameCreateTheme.buildLightTheme().primaryColor.withOpacity(0.5),
            margin: const EdgeInsets.only(right: 10.0),
          ),
          Flexible(
            child: TextFormField(
              controller: _textEditingController_description,
              inputFormatters: [LengthLimitingTextInputFormatter(150)],
              enableInteractiveSelection: false,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: '게임에 대한 간단한 소개(150자 이내)',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              onSaved: (value) {
                _gameDescription = value.toString();
              },
            ),
          )
        ],
      ),
    );
  }

  Future<DocumentReference> updateGame(int perPrice, int totalPrice) async {
    DocumentReference docRef =
    await Firestore.instance.collection('game3').add({
      'creator': RootPage.user_email,
      'gameName': _gameName,
      'selectedSport': _selectedSports,
      'dateText': _dateText,
      'startTime': _startTimeText,
      'endTime': _endTimeText,
      'groupSize': _groupSize,
      'gameLevel': _gameLevel,
      'Gender': _selectedGender.toString(),
      'loc_name': _loc_name,
      'perPrice': perPrice,
      'totalPrice': totalPrice,
      'dateNumber': _dateNumber,
      'sort': FieldValue.serverTimestamp(),
      'stadiumRef': _stadiumRef,
      'userList': userList,
      'reserve_status': 0, // 예약상태를 관리하는 부분 [0 : 모집중 , 1 : 접수중 , 2 접수 완료]
      'Description' : _gameDescription,
      'chamyeyul' : (1 / _groupSize).toDouble(),
      'stadiumId': _stadiumId
    });
    return docRef;
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
                  color: Color(0xff20253d),
                  child: Text('취소', style: TextStyle(color: Colors.white))),
              FlatButton(
                  color: Color(0xff20253d),
                  onPressed: () async {
                    if (isAvailable) {
                      isAvailable = false;
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

                      QuerySnapshot document = await crudObj.getDocumentByWhere(
                          'stadium', 'stdId', _stdId);
                      int stadiumPrice = document.documents[0].data['price'];

                      if (endMinute == 00 && startMinute == 30) {
                        endHour -= 1;
                        usingMinute = 30;
                      } else {
                        usingMinute = endMinute - startMinute;
                      }

                      usingHour = endHour - startHour;
                      timeBlock = usingHour * 2 + (usingMinute == 30 ? 1 : 0);

                      totalPrice = stadiumPrice * timeBlock;
                      perPrice = totalPrice ~/ _groupSize;

                      int fundData = await payObj.getFund();
                      if (fundData >= perPrice) {
                        _stadiumRef = document.documents[0].reference;
                        _stadiumId = document.documents[0].documentID;
                        this.userList.add(RootPage.user_email);
                        int newFund = fundData - perPrice;
                        int usingTime = partTimeToTotalTime(_startTime.hour,
                            _startTime.minute, _endTime.hour, _endTime.minute);
                        DateFormat dateFormat = DateFormat("yy-MM-dd");
                        String pickDate = dateFormat.format(_date);
                        int weekDay =
                            _date.weekday - 1; // weekday는 월요일 1 ~ 일요일 7의 값이 나옴
                        var stdRef = Firestore.instance
                            .collection("stadium")
                            .document(_stdId);
                        var stdDate = await stdRef
                            .collection("date")
                            .document(pickDate)
                            .get();
                        DocumentReference gameDoc;
                        if (stdDate.data == null) {
                          var stdData = await stdRef.get();
                          gameDoc = await updateGame(perPrice, totalPrice);
                          String docId = gameDoc.documentID;
                          await payObj.updateFund(newFund);
                          int availTime = stdData["intTimes"][weekDay];
                          int blockTime = 281474976710655 - availTime;
                          int totalTime = blockTime + usingTime;
                          await stdRef
                              .collection("date")
                              .document(pickDate)
                              .setData({
                            "totalTime": totalTime,
                            "blockTime": blockTime,
                            "reserveFin": [],
                            "reserveFinId": [],
                            "reserveYet": [usingTime],
                            "reserveYetId": [docId],
                            "setTimes": []
                          });
                        } else {
                          if (stdDate["totalTime"] & usingTime > 0) {
                            _showAlertDialog("참가 실패", "예약 불가능한 경기장 입니다.");
                            return;
                          }
                          gameDoc = await updateGame(perPrice, totalPrice);
                          String docId = gameDoc.documentID;
                          await payObj.updateFund(newFund);
                          int totalTime = stdDate["totalTime"] + usingTime;
                          List<int> reserveYet =
                          List.from(stdDate["reserveYet"]);
                          List<String> reserveYetId =
                          List.from(stdDate["reserveYetId"]);
                          reserveYet.add(usingTime);
                          reserveYetId.add(docId);
                          await stdRef
                              .collection("date")
                              .document(pickDate)
                              .updateData({
                            "totalTime": totalTime,
                            "reserveYet": reserveYet,
                            "reserveYetId": reserveYetId
                          });
                        }

                        DocumentSnapshot userDoc = await crudObj
                            .getDocumentById('user', RootPage.userDocID);
                        userGameList = List.from(userDoc.data["gameList"]);
                        userGameList.add(gameDoc.documentID);
                        await crudObj.updateData('user', RootPage.userDocID,
                            {'gameList': userGameList});
                        isAvailable = true;
                        Navigator.pop(context);
                        Navigator.pop(context);
                      } else {
                        _showAlertDialog("참가 실패", "포인트가 부족합니다");
                        isAvailable = true;
                      }
                      /*crudObj.getDocumentByWhere('stadium', 'stdId', _stdId).then((document) {
                        int stadiumPrice = document.documents[0].data['price'];
                        if (endMinute == 00 && startMinute == 30) {
                          endHour -= 1;
                          usingMinute = 30;
                        } else {
                          usingMinute = endMinute - startMinute;
                        }
                        usingHour = endHour - startHour;
                        timeBlock = usingHour * 2 + (usingMinute == 30 ? 1 : 0);
                        totalPrice = stadiumPrice * timeBlock; // 경기장 정보 들어오면 그거 쓰기
                        perPrice = totalPrice ~/ _groupSize;
                        payObj.getFund().then((fundData) {
                          if (fundData >= perPrice) {
                            _stadiumRef = document.documents[0].reference;
                            this.userList.add(RootPage.user_email);
                            int newFund = fundData - perPrice;
                            payObj.updateFund(newFund).then((waitData1) {
                              Firestore.instance.collection('game3').add({
                                'gameName': _gameName,
                                'selectedSport': _selectedSports,
                                'dateText': _dateText,
                                'startTime': _startTimeText,
                                'endTime': _endTimeText,
                                'groupSize': _groupSize,
                                'gameLevel': _gameLevel,
                                'Gender': _selectedGender.toString(),
                                'loc_name': _loc_name,
                                'perPrice': perPrice,
                                'totalPrice': totalPrice,
                                'dateNumber': _dateNumber,
                                'sort': FieldValue.serverTimestamp(),
                                'stadiumRef': _stadiumRef,
                                'userList': userList,
                                'reserve_status': 0, // 예약상태를 관리하는 부분 [0 : 모집중 , 1 : 접수중 , 2 접수 완료]
                              }).then((gameDoc) {
                                crudObj.getDocumentById('user', RootPage.userDocID).then((userDoc) {
                                  userGameList = List.from(userDoc.data['gameList']);
                                  userGameList.add(gameDoc.documentID);
                                  print(userGameList.length);
                                  crudObj.updateDataThen('user', RootPage.userDocID, {
                                    'gameList': userGameList,
                                  }).then((data) {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  });
                                });
                              });
                            });
                          } else {
                            _showAlertDialog("참가 실패", "포인트가 부족합니다");
                          }
                        });
                      });*/ // 경기장 정보 들어오면 그거 쓰기
                    }
                  },
                  child: Text('생성', style: TextStyle(color: Colors.white)))
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
              color: GameCreateTheme.buildLightTheme()
                  .primaryColor
                  .withOpacity(0.2),
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
              if (_textEditingController.text.length == 0) {
                _showAlertDialog("생성 실패", "경기장 이름을 입력해주세요.");
              } else if (_selectedSports == null) {
                _showAlertDialog("생성 실패", "스포츠를 선택해주세요.");
              } else if (!_completeDate) {
                _showAlertDialog("생성 실패", "날짜를 선택해주세요.");
              } else if (!_completeStartTime) {
                _showAlertDialog("생성 실패", "시작 시간을 선택해주세요.");
              } else if (!_completeEndTime) {
                _showAlertDialog("생성 실패", "종료 시간을 선택해주세요.");
              } else if (_textEditingController_size.text.length == 0) {
                _showAlertDialog("생성 실패", "총 인원을 입력해주세요.");
              } else if (int.parse(_textEditingController_size.text) < 2 ||
                  int.parse(_textEditingController_size.text) > 30) {
                _showAlertDialog("생성 실패", "모집 인원: 10 ~ 30 사이의 값을 입력하세요");
              } else if (_textEditingController_level.text.length == 0) {
                _showAlertDialog("생성 실패", "희망 수준을 선택해주세요.");
              } else if (int.parse(_textEditingController_level.text) < 1 ||
                  int.parse(_textEditingController_level.text) > 10) {
                _showAlertDialog("생성 실패", "희망 수준: 1 ~ 10 사이의 값을 입력하세요");
              } else if (_loc_name == "장소 선택") {
                _showAlertDialog("생성 실패", "장소를 선택해주세요.");
              } else {
                _showMaterialDialog();
              }
            },
            child: Center(
              child: Text(
                "게임 생성 완료",
                style: TextStyle(
                    fontFamily: 'Dosis',
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}