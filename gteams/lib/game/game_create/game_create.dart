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

class GameCreatePage extends StatefulWidget {
  @override
  _GameCreatePageState createState() => _GameCreatePageState();
}

enum Gender { MALE, FEMALE, ALL }

class _GameCreatePageState extends State<GameCreatePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  crudMedthods crudObj = new crudMedthods();
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

  void loadData() {
    _sportsList = [];
    _sportsList = _sports
        .map((val) => DropdownMenuItem<String>(
      child: Text(val),
      value: val,
    ))
        .toList();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime _pickedDate = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime.now().subtract(Duration(days: 1)),
        lastDate: _date.add(Duration(days: 100)));

    if (_pickedDate != null && _pickedDate != _date) {
      setState(() {
        _date = _pickedDate;
        _dateNumber=_date.millisecondsSinceEpoch;
        _dateText = _date.toString().split(" ")[0];
      });
    }
  }

  Future<Null> _selectStart(BuildContext context) async {
    final TimeOfDay _pickedStart = await showTimePicker(context: context, initialTime: _startTime);

    if (_pickedStart != null && _pickedStart != _startTime) {
      setState(() {
        _startTime = _pickedStart;
        _startTimeText = _startTime.toString().split("(")[1].split(")")[0];
      });
    }
  }

  Future<Null> _selectEnd(BuildContext context) async {
    final TimeOfDay _pickedEnd = await showTimePicker(context: context, initialTime: _endTime);

    if (_pickedEnd != null && _pickedEnd != _endTime) {
      setState(() {
        _endTime = _pickedEnd;
        _endTimeText = _endTime.toString().split("(")[1].split(")")[0];
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
              onPressed: () {
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
              onPressed: () {
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
                hintText: 'Game Level',
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
                    Text("게임 이름 : $_gameName"),
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
                    crudObj.addData('game3', {
                      'gameName' : _gameName,
                      'selectedSport':_selectedSports,
                      'dateText':_dateText,
                      'startTime':_startTimeText,
                      'endTime':_endTimeText,
                      'groupSize':_groupSize,
                      'gameLevel':_gameLevel,
                      'Gender':_selectedGender.toString(),
                      'loc_name':_loc_name,
                      'dateNumber':_dateNumber,
                      'sort' : FieldValue.serverTimestamp(),
                      'stadiumRef' : _stadiumRef,
                      'userList' : userList,
                    });


                    Navigator.pop(context);
                    Navigator.pop(context);
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
              crudObj.getDocumentByWhere('stadium', 'id', _stadium_id).then((document){
                _stadiumRef = document.documents[0].reference;
              });
              this.userList.add(RootPage.user_email);
              _showMaterialDialog();
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
