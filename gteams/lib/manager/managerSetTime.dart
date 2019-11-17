import 'package:flutter/material.dart';

typedef TimeFunc = void Function(List<List<int>>);

class SetTime extends StatefulWidget{
  SetTime({this.timeFunc});

  final TimeFunc timeFunc;
  @override
  _SetTimeState createState() => _SetTimeState();
}

class _SetTimeState extends State<SetTime> with TickerProviderStateMixin {
  List<String> week = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  List<Color> colorArr = List.generate(384, (index) {
    return Colors.white;
  });
  List<bool> borderArr = List.generate(384, (index) {
    return false;
  });
  List<bool> isClicked = List.generate(384, (index) {
    return false;
  });
  AnimationController _resizableController;
  int preNum = -1;

  @override
  void initState() {
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

  @override
  void dispose() {
    _resizableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(title: Text("Available Times", style: TextStyle(
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
                                  fontSize: 22, fontWeight: FontWeight.bold))));
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
                                                fontWeight: FontWeight.w600
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
                                                        remain] = Colors
                                                        .teal; //Color(0xff3B5998);
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
              onPressed: () {},
              color: Color(0xff20253d)
          )
        ])
    );
  }
}
