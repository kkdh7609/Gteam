import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gteams/manager/calendar/calendarView.dart';
import "package:intl/intl.dart";
import 'package:gteams/util/timeUtil.dart';

class CalendarViewApp extends StatefulWidget {
  CalendarViewApp({this.stdRef});

  final DocumentSnapshot stdRef;
  @override
  _CalendarViewAppState createState() => _CalendarViewAppState();
}

class _CalendarViewAppState extends State<CalendarViewApp> {
  DateTime _selectedDay;
  List<int> _stateArr;                      //   1 영업 안하는 시간, 2 예약 완료된 것, 3 예약 승인필요, 4 직접 블럭 설정
  List<String> _stateName;

  @override
  void initState(){
    super.initState();
    _selectedDay = DateTime.now();
    getDateInformation();
  }

  void changeState(newState, times, val, newName, strVal){
    List<int> timeList = totalTimeToOrder(times);
    for(int i = 0; i < timeList.length; i++){
      newState[timeList[i]] = val;
      newName[timeList[i]] = strVal;
    }
  }

  void getDateInformation() async {
    setState(() {
      _stateArr = [];                // 변경전에는 로딩 창 보여줄 수 있도록
      _stateName = [];
    });

    List<int> newState = List<int>(48);
    List<String> newName = List<String>(48);
    DateFormat dateFormat = DateFormat("yy-MM-dd");
    String pickDate = dateFormat.format(_selectedDay);

    var dateVal = await widget.stdRef.reference.collection("date").document(pickDate).get();

    if(dateVal.data == null){
      int blockTime = 281474976710655 - widget.stdRef["intTimes"][_selectedDay.weekday - 1];
      changeState(newState, blockTime, 1, newName, "Block");
    }
    else{
      int blockTime = dateVal.data["blockTime"];
      changeState(newState, blockTime, 1, newName, "Block");

      List<dynamic> reserveFin = dateVal.data["reserveFin"];
      for(int idx = 0; idx < reserveFin.length; idx++){
        int oneTime = reserveFin[idx];
        var gameRef = await Firestore.instance.collection("game3").document(dateVal.data["reserveFinId"][idx]).get();
        String gameName = gameRef["gameName"];
        changeState(newState, oneTime, 2, newName, gameName);
      }

      List<dynamic> reserveYet = dateVal.data["reserveYet"];
      for(int idx = 0; idx < reserveYet.length; idx++){
        int oneTime = reserveYet[idx];
        var gameRef = await Firestore.instance.collection("game3").document(dateVal.data["reserveYetId"][idx]).get();
        String gameName = gameRef["gameName"];
        changeState(newState, oneTime, 3, newName, gameName);
      }

      List<dynamic> setTimes = dateVal.data["setTimes"];           // 매니저가 직접 블럭하는 시간대
      for(int idx = 0; idx < setTimes.length; idx++){
        int oneTime = setTimes[idx];
        changeState(newState, oneTime, 4, newName, "Setted Block");
      }
    }
    setState(() {
      _stateArr = List.from(newState);
      _stateName = List.from(newName);
    });
  }

  Widget calendar() {
    return Calendar(
      onDateSelected: (day) {
        _selectedDay = day;
        getDateInformation();
        print(day);
      },
      onSelectedRangeChange: (range) =>
          print("Range is ${range.item1}, ${range.item2}"),
      isExpandable: true,
    );
  }

  Widget scheduleWidget(int index){
    if(_stateArr[index] == null){
      return Center(
        child: Container(
          color: Colors.white
        )
      );
    }

    else{
      int state = _stateArr[index];
      if(state == 1) {
        return Container(
            decoration: BoxDecoration(
              color: Colors.black,
              boxShadow: [
                new BoxShadow(
                  offset: Offset(3.0, -1.0),
                  color: Color(0xffEDEDED),
                  blurRadius: 3.0,
                ),
              ],
            ),
          child: Center(
                child: Text(
                    _stateName[index],
                    style: TextStyle(
                      fontFamily: 'Dosis',
                      fontWeight: FontWeight.w900,
                      color: Colors.white
                    )
                )
            )
        );
      }
      else if(state == 2){
        return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
               colors: [Color(0xff20253d), Colors.blue],
              ),
              boxShadow: [
                new BoxShadow(
                  offset: Offset(3.0, -1.0),
                  color: Color(0xffEDEDED),
                  blurRadius: 3.0,
                ),
              ],
            ),
          child: Center(
            child: Text(
              _stateName[index],
              style: TextStyle(
                  fontFamily: 'Dosis',
                  fontWeight: FontWeight.w900,
                  color: Colors.white
              )
            )
          )
        );
      }
      else if(state == 3){
        return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff004D40), Color(0xFF1B5E20)],
              ),
              boxShadow: [
                new BoxShadow(
                  offset: Offset(3.0, -1.0),
                  color: Color(0xffEDEDED),
                  blurRadius: 3.0,
                ),
              ],
            ),
          child: Center(
                child: Text(
                    _stateName[index],
                    style: TextStyle(
                        fontFamily: 'Dosis',
                        fontWeight: FontWeight.w900,
                        color: Colors.white
                    )
                )
            )
        );
      }
      else{
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.redAccent[700], Colors.red[300]],
            ),
            boxShadow: [
              new BoxShadow(
                offset: Offset(3.0, -1.0),
                color: Color(0xffEDEDED),
                blurRadius: 3.0,
              ),
            ],
          ),
          child: Center(
              child: Text(
                  _stateName[index],
                  style: TextStyle(
                      fontFamily: 'Dosis',
                      fontWeight: FontWeight.w900,
                      color: Colors.white
                  )
              )
          )
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
            title: Text("시설 관리자 예약 관리",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    color: Colors.white)),
            centerTitle: true,
            backgroundColor: Color(0xff20253d)),
        body: Column(
          children: <Widget>[
            Expanded(
                flex: 3,
                child: GridView.builder(
                    scrollDirection: Axis.vertical,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 2),
                    ),
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return calendar();
                    })),
            Expanded(flex: 1, child: Divider(height: 10, color: Colors.black)),
            Expanded(
              flex: 7,
              child: ListView.builder(
                  itemExtent: 48,
                  itemCount: 48,
                  itemBuilder: (context, index) {
                    return Row(children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: Center(
                              child: Text(
                                  "${(index ~/ 2)}:${((index % 2) == 0) ? '00' : '30'}",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500)))),
                      Expanded(
                          flex: 7,
                          child: Container(
                              child: _stateArr.length == 0 ? Center(child: Text("Loading")) :
                                  scheduleWidget(index)
                          )
                      )
                    ]);
                  }),
            )
          ],
        ));
  }
}
