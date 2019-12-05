import 'package:flutter/material.dart';
import 'package:gteams/util/timeUtil.dart';

typedef TimeFunc = void Function(List<int>, List<String>);

class SetTime extends StatefulWidget{
  SetTime({this.timeFunc, this.timeList});

  final TimeFunc timeFunc;
  final List<int> timeList;
  @override
  _SetTimeState createState() => _SetTimeState();
}

class _SetTimeState extends State<SetTime> with TickerProviderStateMixin {
  List<int> newTimeList;

  List<String> week;
  List<Color> colorArr;
  List<bool> borderArr;
  List<bool> isClicked;
  AnimationController _resizableController;
  int preNum;

  @override
  void initState() {
    week = ["월", "화", "수", "목", "금", "토", "일"];
    colorArr = List.generate(384, (index) {
      return Colors.white;
    });
    borderArr = List.generate(384, (index) {
      return false;
    });
    isClicked = List.generate(384, (index) {
      return false;
    });

    if(widget.timeList != null) {
      List<int> tempTimes = List.from(widget.timeList);
      for (int cnt = 0; cnt < 7; cnt++) {
        for (int idx = 0; idx < 48; idx++) {
          if(tempTimes[cnt] & 1 == 1){
            int newIndex = 8 * (47 - idx) + cnt + 1;
            colorArr[newIndex] = Colors.teal;
            isClicked[newIndex] = true;
          }
          tempTimes[cnt] = tempTimes[cnt] >> 1;
        }
      }
    }

    preNum = -1;

    newTimeList = [0, 0, 0, 0, 0, 0, 0];
    _resizableController = AnimationController(
      vsync: this,
      duration: new Duration(
        milliseconds: 1000,
      ),
    );
    _resizableController.addStatusListener((animationStatus) {
      switch (animationStatus) {
        case AnimationStatus.completed:
          _resizableController.reverse();
          break;
        case AnimationStatus.dismissed:
          _resizableController.forward();
          break;
        case AnimationStatus.forward:
          break;
        case AnimationStatus.reverse:
          break;
      }
    });
    _resizableController.forward();
    super.initState();
  }

  onConfirmClicked(){
    List<String> strTimes = [];
    for(int idx = 0; idx < 384; idx++){
      if(idx != 0 && idx % 8 == 0){
        for(int cnt=0; cnt < 7; cnt++){
          newTimeList[cnt] = newTimeList[cnt] << 1;
        }
        continue;
      }
      if(isClicked[idx]){
        newTimeList[(idx%8) - 1] += 1;
      }
    }
    for(int cnt=0; cnt<7; cnt++){
      strTimes.add(listTimeConverter(intTimeToStr(newTimeList[cnt])));
    }
    widget.timeFunc(newTimeList, strTimes);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _resizableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(title: Text("경기장 운영시간 관리", style: TextStyle(
            fontWeight: FontWeight.w600, fontSize: 22, color: Colors.white)),
          centerTitle: true,
          backgroundColor: Color(0xff20253d),
        ),
        body: Column(children: <Widget>[
          Expanded(
              child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: GridView.builder(
                          scrollDirection: Axis.horizontal,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 8,
                            childAspectRatio: MediaQuery
                                .of(context)
                                .size
                                .width /
                                (MediaQuery
                                    .of(context)
                                    .size
                                    .height / 2),
                          ),
                          itemCount: 8,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return GridTile(child: Text(""));
                            }
                            else {
                              return GridTile(child: Center(child: Text(
                                  week[index - 1], style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w400))));
                            }
                          }
                      ),
                    ),
                    Expanded(
                        flex: 5,
                        child: GridView.builder(
                            scrollDirection: Axis.horizontal,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 8,
                              childAspectRatio: MediaQuery
                                  .of(context)
                                  .size
                                  .width /
                                  (MediaQuery
                                      .of(context)
                                      .size
                                      .height / 2),
                            ),
                            itemCount: 384,
                            itemBuilder: (context, index) {
                              if (index % 8 == 0) {
                                return Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                          // top: BorderSide(color: Colors.grey),
                                          // left: BorderSide(color: Colors.grey),
                                          // right: BorderSide(color: Colors.grey),
                                          // bottom: BorderSide(color: Colors.grey)
                                        )
                                    ),
                                    child: Center(
                                        child: Text(
                                            "${(((index / 8)) ~/
                                                2)}:${(((index / 8) %
                                                2) == 0) ? '00' : '30'}",
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.w500
                                            )
                                        )
                                    )
                                );
                              }
                              return AnimatedBuilder(
                                  animation: _resizableController,
                                  builder: (context, child) {
                                    return InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (isClicked[index]) {
                                              if (preNum == -1) {
                                                preNum = index;
                                                borderArr[index] = true;
                                              }
                                              else if (!isClicked[preNum]) {
                                                borderArr[preNum] = false;
                                                preNum = index;
                                                borderArr[index] = true;
                                              }
                                              else {
                                                if ((preNum % 8) !=
                                                    (index % 8)) {
                                                  borderArr[preNum] = false;
                                                  preNum = index;
                                                  borderArr[index] = true;
                                                }
                                                else {
                                                  int remain = (preNum % 8);
                                                  var minNum = (preNum >= index)
                                                      ?
                                                  (index - remain) ~/ 8
                                                      : (preNum - remain) ~/ 8;
                                                  var maxNum = (preNum >= index)
                                                      ?
                                                  (preNum - remain) ~/ 8
                                                      : (index - remain) ~/ 8;

                                                  for (var loopIndex = minNum; loopIndex <=
                                                      maxNum; loopIndex ++) {
                                                    isClicked[8 * loopIndex +
                                                        remain] = false;
                                                    colorArr[8 * loopIndex +
                                                        remain] = Colors.white;
                                                  }
                                                  borderArr[preNum] = false;
                                                  preNum = -1;
                                                }
                                              }
                                            }
                                            else {
                                              if (preNum == -1) {
                                                preNum = index;
                                                borderArr[index] = true;
                                              }

                                              else if (isClicked[preNum]) {
                                                borderArr[preNum] = false;
                                                preNum = index;
                                                borderArr[index] = true;
                                              }
                                              else {
                                                if ((preNum % 8) !=
                                                    (index % 8)) {
                                                  borderArr[preNum] = false;
                                                  preNum = index;
                                                  borderArr[index] = true;
                                                }
                                                else {
                                                  int remain = (preNum % 8);
                                                  var minNum = (preNum >= index)
                                                      ?
                                                  (index - remain) ~/ 8
                                                      : (preNum - remain) ~/ 8;
                                                  var maxNum = (preNum >= index)
                                                      ?
                                                  (preNum - remain) ~/ 8
                                                      : (index - remain) ~/ 8;

                                                  for (var loopIndex = minNum; loopIndex <=
                                                      maxNum; loopIndex ++) {
                                                    isClicked[8 * loopIndex +
                                                        remain] = true;
                                                    colorArr[8 * loopIndex +
                                                        remain] = Colors.teal; //Color(0xff3B5998);
                                                  }
                                                  borderArr[preNum] = false;
                                                  preNum = -1;
                                                }
                                              }
                                            }
                                          });
                                        },
                                        child: GridTile(
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                      colors: [
                                                        Colors.white,
                                                        colorArr[index]
                                                      ],
                                                      stops: const[0.0, 1.0],
                                                      begin: Alignment.topRight,
                                                      end: Alignment.bottomLeft
                                                  ),
                                                  // color: colorArr[index],
                                                  borderRadius: BorderRadius
                                                      .all(
                                                      Radius.circular(12)),
                                                  border: borderArr[index]
                                                      ? Border.all(
                                                      color: (isClicked[index]
                                                          ? Colors.red
                                                          : Colors.blue),
                                                      width: _resizableController
                                                          .value * 3)
                                                      :
                                                  Border(),
                                                ),
                                                child: Center(
                                                    child: Text(""))
                                            )
                                        )
                                    );
                                  });
                            }
                        )
                    )
                  ]
              )),
          FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)
              ),
              child: SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 2 / 3,
                  child: Center(
                      child: Text("Confirm", style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.white)))),
              onPressed: onConfirmClicked,
              color: Color(0xff20253d)
          )
        ])
    );
  }
}