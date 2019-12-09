import 'package:flutter/material.dart';
import 'package:gteams/game/game_join/model/GameListData.dart';
import 'package:gteams/manager/custon_expansion_tile.dart' as custom;
import 'package:gteams/game/game_create/GameCreateTheme.dart';
import 'package:gteams/services/crud.dart';
import 'package:gteams/root_page.dart';
import 'package:gteams/pay/payMethod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:gteams/util/pushPostUtil.dart';

typedef newFunc = Future<void> Function();

class ReserveList extends StatefulWidget {
  ReserveList({Key key, this.stdRef, this.refreshData, this.index}) : super(key: key);

  final DocumentSnapshot stdRef;
  final newFunc refreshData;
  final int index;

  @override
  _ReserveListState createState() => _ReserveListState();
}

class _ReserveListState extends State<ReserveList> {
  crudMedthods crudObj = new crudMedthods();
  PayMethods payObj = new PayMethods();
  List<GameListData> gameDataList;

  bool flag = false;
  bool isAvailable = true;
  bool isDialogAvailable = true;

  DocumentSnapshot _nowStdRef;

  List<dynamic> stadiumList;
  List<dynamic> gameList;
  List<dynamic> reserveList;

  String temp;

  @override
  void initState() {
    super.initState();
    flag = false;
    isDialogAvailable = true;
    isAvailable = true;
    _nowStdRef = widget.stdRef;
    this.gameDataList = [];
    this.gameList = widget.stdRef.data["gameList"];
    this.reserveList = List<dynamic>.of(widget.stdRef.data["notPermitList"]);
    this.gameDataList = List<GameListData>(this.reserveList.length);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void newRefreshData() async {
    if(isAvailable) {
      isAvailable = false;
      await widget.refreshData();
      if(this.mounted) {
        setState(() {
          this._nowStdRef = RootPage.facilityData[widget.index];
        });
      }
      print("Refresh");
      isAvailable = true;
    }
  }

  Widget _alertButton() {
    return FlatButton(
      child: Text("OK"),
      onPressed: () {
        if (isAvailable) {
          isAvailable = false;
          Navigator.of(context).pop();
          isAvailable = true;
        }
      },
    );
  }

  Widget makeCard(String title, String Date, String startTime, String endTime, int groupSize,
                  int totalPrice, int index) {
    return Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            custom.ExpansionTile(
              trailing: Icon(Icons.keyboard_arrow_right,
                  color: Colors.black, size: 30.0),
              headerBackgroundColor: Colors.white,
              title: Container(
                child: Column(
                  children: <Widget>[
                    Text(
                      "Game Title ",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 18),
                    ),
                    Text(
                      title,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              children: <Widget>[
                Card(
                  elevation: 500,
                  child: Column(
                    children: <Widget>[
                      _showGameInfo(
                          Date, startTime, endTime, groupSize, totalPrice, index),
                    ],
                  ),
                )
              ],
            ),
          ],
        ));
  }

  Widget _showGameInfo(String date, String startTime, String endTime, int groupSize,
                       int totalPrice, int index) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _rowItem("요일", date),
          _rowItem("시작시간", startTime),
          _rowItem("종료시간", endTime),
          _rowItem("총원", groupSize.toString()),
          _rowItem("금액", totalPrice.toString()),
          _acceptButton(index)
        ],
      ),
    );
  }

  Widget _rowItem(String title, String info) {
    return Row(
      children: <Widget>[
        Expanded(
            flex: 2,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(title,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Dosis',
                        fontWeight: FontWeight.w700)))),
        Expanded(
            flex: 0,
            child: Container(
              height: 30.0,
              width: 1.0,
              color: GameCreateTheme.buildLightTheme()
                  .primaryColor
                  .withOpacity(0.5),
              margin: const EdgeInsets.only(right: 10.0),
            )),
        Expanded(
            flex: 5,
            child: SizedBox(
                width: (MediaQuery.of(context).size.width / 4) + 12,
                height: 40,
                child: Center(
                  child: Text(info,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Dosis',
                          fontWeight: FontWeight.w700)),
                )))
      ],
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

  Widget _acceptButton(int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
      child: Container(
        height: 40,
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
              _showMaterialDialog(index);
              // 승인 이후 처리할 부분
            },
            child: Center(
              child: Text(
                "승인",
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

  Future<void> changeGameInfo(String gameDoc) async {
    DocumentSnapshot gameDocumentary =
    await crudObj.getDocumentById('game3', gameDoc);
    var pickDate = gameDocumentary.data['dateText'];
    var dateVal = await this._nowStdRef.reference
        .collection("date")
        .document(pickDate)
        .get();

    var reserveYetId = List<dynamic>.of(dateVal.data["reserveYetId"]);
    var reserveYet = List<dynamic>.of(dateVal.data["reserveYet"]);

    var reserveFinId = List<dynamic>.of(dateVal.data["reserveFinId"]);
    var reserveFin = List<dynamic>.of(dateVal.data["reserveFin"]);

    for (var idx = 0; idx < reserveYetId.length; idx++) {
      if (reserveYetId[idx] == gameDoc) {
        reserveFin.add(reserveYet[idx]);
        reserveFinId.add(reserveYetId[idx]);

        reserveYet.removeAt(idx);
        reserveYetId.removeAt(idx);

        await Firestore.instance
            .collection("stadium")
            .document(_nowStdRef.documentID)
            .collection("date")
            .document(pickDate)
            .updateData(
            { "reserveYetId": reserveYetId,
              "reserveFinId": reserveFinId,
              "reserveYet": reserveYet,
              "reserveFin": reserveFin
            }).then((onValue) {

        });
      }
    }

  }

  void _showMaterialDialog(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('확인'),
            content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[Text("예약 신청을 승인하시겠습니까?")],
                )),
            actions: <Widget>[
              FlatButton(
                  color: Color(0xff20253d),
                  onPressed: () {
                    if (isAvailable) {
                      isAvailable = false;
                      Navigator.pop(context);
                      isAvailable = true;
                    }
                  },
                  child: Text('취소', style: TextStyle(color: Colors.white))),
              FlatButton(
                color: Color(0xff20253d),
                onPressed: () {
                  if (isAvailable) {
                    isAvailable = false;
                    payObj.getFund().then((fund) {
                      int newFund = this.gameDataList[index].totalPrice + (fund * 0.95).toInt();
                      changeGameInfo(this.reserveList[index]).then((tempData){
                        payObj.updateFund(newFund).then((tempVal) {
                          crudObj.updateDataThen('game3', this.reserveList[index], {"reserve_status": 2}).then((tempVal){
                            var tempKey = this.reserveList[index];
                            setState((){
                              this.reserveList.removeAt(index);
                              this.gameDataList = List<GameListData>(this.reserveList.length);
                              _nowStdRef.data["notPermitList"] = List<dynamic>.of(this.reserveList);
                            });
                            crudObj.updateDataThen('stadium', widget.stdRef.documentID, {"notPermitList": this.reserveList}).then((tempval2){
                              Navigator.pop(context);
                              isAvailable = true;
                              pushPost("3", tempKey);
                              _showAlertDialog("성공", "승인에 성공하였습니다.");
                            });
                          });
                        });
                      });
                    });
                  }
                },
                child: Text('승인', style: TextStyle(color: Colors.white)),
              )
            ],
          );
        });
  }

  Widget refreshWidget(){
    return IconButton(
      icon: Icon(Icons.refresh),
      onPressed: (){
        newRefreshData();
      },
    );
  }

  Widget _buildbody() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: reserveList.length,
        itemBuilder: (BuildContext context, int index) {
          crudObj.getDocumentById('game3', reserveList[index]).then((document) {
            if (this.mounted) {
              if (gameDataList.length >= index + 1) {
                setState(() {
                  gameDataList[index] = GameListData.fromJson(document.data);
                });
              }
            }
          });

          return gameDataList.length > index
                 ? ((gameDataList[index] != null &&
              gameDataList[index].groupSize ==
                  gameDataList[index].userList.length)
                    ? makeCard(
              gameDataList[index].gameName,
              gameDataList[index].dateText,
              gameDataList[index].startTime,
              gameDataList[index].endTime,
              gameDataList[index].groupSize,
              gameDataList[index].totalPrice,
              index)
                    : LinearProgressIndicator())
                 : LinearProgressIndicator();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.1,
          title: Text("경기장 예약 승인",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                  color: Colors.white)),
          actions: <Widget>[
            refreshWidget()
          ]
      ),
      body: reserveList.length == 0 ? Center(child: Text("예약 목록이 없습니다.", style: TextStyle(fontFamily: 'Dosis', fontWeight: FontWeight.w500, fontSize: 20.0))) : Container(child: _buildbody()),
    );
  }
}