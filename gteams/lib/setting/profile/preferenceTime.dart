import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gteams/setting/popularFilterList.dart';
import 'package:gteams/setting/profile/PreferListView.dart';
import 'package:gteams/menu/drawer/UserData.dart';
import 'package:gteams/game/game_create/GameCreateTheme.dart';

class PreferenceTime extends StatefulWidget {
  PreferenceTime({this.userData, this.userDocID});

  final UserData userData;
  final String userDocID;

  @override
  _PreferenceTimeState createState() => _PreferenceTimeState();
}

class _PreferenceTimeState extends State<PreferenceTime> with TickerProviderStateMixin {
  String _startTimeText = "Start Time";
  String _endTimeText = "End Time";

  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();

  List<SettingListData> dayListData = SettingListData.dayList;
  bool _isExpanded = false;

  AnimationController _expandAnimationController;
  AnimationController animationController;
  Animation<Size> _bottomSize;

  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _expandAnimationController = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _bottomSize = new SizeTween(
      begin: new Size.fromHeight(kTextTabBarHeight),
      end: new Size.fromHeight(kTextTabBarHeight + 220),
    ).animate(new CurvedAnimation(
      parent: _expandAnimationController,
      curve: Curves.ease,
    ));

    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _showMaterialDialog(String show) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(show,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w900),
                    )
                  ],
                )
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('확인')),
            ],
          );
        });
  }

  Widget _button(day, idx) {
    return Expanded(
        flex: 1,
        child: Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 3, color: Colors.blueGrey),
            color: dayListData[idx].isSelected
                ? Color(0xff3B5998)
                : Colors.white12,
          ),
          child: new FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            child: Text("$day",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w900),
                textAlign: TextAlign.center),
            onPressed: () {
              setState(() {
                dayListData[idx].isSelected = !(dayListData[idx].isSelected);
              });
            },
          ),
        ));
  }

  List<Widget> _buildButtons() {
    List<Widget> listButtons = List.generate(dayListData.length, (i) {
      return _button(dayListData[i].titleTxt, i);
    });
    return listButtons;
  }

  Widget _addButton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: RaisedButton(
        color: Color(0xff3B5998),
        child: Text("추가",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w900),
            textAlign: TextAlign.center),
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        onPressed: () {
          PreferListData newpreferdata = new PreferListData();
          List<String> newDayList = [];

          for (var idx = 0; idx < dayListData.length; idx++) {
            if (dayListData[idx].isSelected == true) {
              newDayList.add(dayListData[idx].titleTxt);

              setState(() {
                dayListData[idx].isSelected = !(dayListData[idx].isSelected);
              });
            }
          }
          newpreferdata.startTime = _startTimeText;
          newpreferdata.endTime = _endTimeText;

          if(newDayList.length!=0&&newpreferdata.startTime!="Start Time"&&newpreferdata.endTime!="End Time") {
            // add new list to firebase
            Firestore.instance.collection('user').document(widget.userDocID).collection("preferenceTime").add({
              'startTime': newpreferdata.startTime,
              'endTime': newpreferdata.endTime,
              'dayList': newDayList,
            });
            // add complete message dialog
            _showMaterialDialog("추가 되었습니다");
            setState(() {
              _startTimeText = "Start Time";
              _endTimeText = "End Time";
            });
          }else{
            _showMaterialDialog("값을 입력하세요");
          }
        },
      ),
    );
  }

  Future<Null> _selectStart(BuildContext context) async {
    final TimeOfDay _pickedStart =
    await showTimePicker(context: context, initialTime: _startTime);

    if (_pickedStart != null && _pickedStart != _startTime) {
      setState(() {
        _startTime = _pickedStart;
        _startTimeText = _startTime.toString().split("(")[1].split(")")[0];
      });
    }
  }

  Future<Null> _selectEnd(BuildContext context) async {
    final TimeOfDay _pickedEnd =
    await showTimePicker(context: context, initialTime: _endTime);

    if (_pickedEnd != null && _pickedEnd != _endTime) {
      setState(() {
        _endTime = _pickedEnd;
        _endTimeText = _endTime.toString().split("(")[1].split(")")[0];
      });
    }
  }

  Widget _showGameTime() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
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
              onPressed: () {
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
                  .withOpacity(0.1),
              child: Text(_endTimeText,
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Dosis',
                      fontWeight: FontWeight.w700)),
              onPressed: () {
                _selectEnd(context);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _addList() {
    return Container(
        padding: EdgeInsets.all(10),
        child: Card(
          elevation: 5,
          child: Column(
            children: <Widget>[
              Row(children: _buildButtons()),
              _showGameTime(),
              _addButton(),
            ],
          ),
        ));
  }

  Widget _buildBottom() {
    return PreferredSize(
      child: Container(
        color: Colors.white,
        height: _bottomSize.value.height,
        child: Column(
          children: <Widget>[
            FilterBar(
                onExpandedChanged: (bool value) async {
                  if (value && _expandAnimationController.isDismissed) {
                    await _expandAnimationController.forward();
                    setState(() {
                      _isExpanded = true;
                    });
                  } else if (!value && _expandAnimationController.isCompleted) {
                    await _expandAnimationController.reverse();
                    setState(() {
                      _isExpanded = false;
                    });
                  }
                },
                isExpanded: _isExpanded
            ),
            Flexible(
                child: Stack(
                  overflow: Overflow.clip,
                  children: <Widget>[
                    Positioned(
                      top: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: _addList(),
                    )
                  ],
                )),
          ],
        ),
      ),
      preferredSize: _bottomSize.value,
    );
  }

  Widget _buildBody(){
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('user').document(widget.userDocID).collection("preferenceTime").snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData) return LinearProgressIndicator();
          return _showPreferList(context,snapshot.data.documents);
        }
    );
  }

  Widget _showPreferList(BuildContext context, List<DocumentSnapshot> snapshot){
    return Container(
      child:  ListView.builder(
        itemCount: snapshot.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          var count = snapshot.length > 10 ? 10 : snapshot.length;
          var animation = Tween(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                  parent: animationController,
                  curve: Interval((1 / count) * index, 1.0, curve: Curves.fastOutSlowIn)));
          animationController.forward();

          return PreferListView(
            callback: () {},
            preferData: snapshot.map((data) => PreferListData.fromJson(data.data)).toList()[index],
            animation: animation,
            animationController: animationController,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                AnimatedBuilder(
                  animation: _bottomSize,
                  builder: (BuildContext context, Widget child) {
                    return SliverAppBar(
                      backgroundColor: Color(0xff3B5998),
                      pinned: true,
                      floating: true,
                      title: Text('선호 시간 목록',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w900),
                          textAlign: TextAlign.center),
                      bottom: _buildBottom(),
                    );
                  },
                ),
              ];
            },
            body: _buildBody()
        )
    );
  }
}

class FilterBar extends StatelessWidget {
  FilterBar({this.isExpanded, this.onExpandedChanged});

  final bool isExpanded;
  final ValueChanged<bool> onExpandedChanged;

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Theme.of(context).canvasColor,
      child: new Row(
        children: <Widget>[
          new FlatButton(
            onPressed: () {
              onExpandedChanged(!isExpanded);
            },
            child: new Row(
              children: <Widget>[
                new Text('추가',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w900),
                    textAlign: TextAlign.center),
                new Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
