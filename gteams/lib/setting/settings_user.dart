import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gteams/services/crud.dart';
import 'package:gteams/menu/main_menu.dart';
import 'package:gteams/setting/popularFilterList.dart';
import 'package:gteams/game/game_join/widgets/SliderView.dart';
import 'package:gteams/game/game_join/widgets/GameJoinTheme.dart';

class SettingUser extends StatefulWidget {
  SettingUser({Key key, this.onSignedOut, this.userDocID}) : super(key: key);

  final String userDocID;
  final VoidCallback onSignedOut;

  @override
  _SettingUserState createState() => _SettingUserState();
}

enum Gender { MALE, FEMALE, ALL }

class _SettingUserState extends State<SettingUser> {
  List<SettingListData> sportListData = SettingListData.sportList;

  RangeValues _values = RangeValues(0, 24);
  double distValue = 50.0;
  Gender _selectedGender = null;
  List<int> checNum;

  crudMedthods crudObj = new crudMedthods();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            getAppBarUI(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    //timeRangeBar(),
                    Divider(
                      height: 1,
                    ),
                    preferenceSport(),
                    Divider(
                      height: 1,
                    ),
                    distanceViewUI(),
                    Divider(
                      height: 1,
                    ),
                    _game_gender()
                  ],
                ),
              ),
            ),
            Divider(
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: GameJoinTheme.buildLightTheme().primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(24.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      blurRadius: 8,
                      offset: Offset(4, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(24.0)),
                    highlightColor: Colors.transparent,
                    onTap: () {
                      // When pressed apply button update Database about user
                      List<String> updateList = []; // List for get select sport list
                      for (var i = 0; i < sportListData.length; i++) {
                        if (sportListData[i].isSelected) {
                          updateList.add(sportListData[i].titleTxt);
                        }
                      }
                      crudObj.updateData(
                        'user',
                        widget.userDocID,
                        {
                          'fund' : 10000,
                          'info_status': true,
                          'prferenceTime': "1700~1800",
                          'prferenceLoc': "loc",
                          'gender': _selectedGender.toString(),
                          'sportList': FieldValue.arrayUnion(updateList),
                          // It can update array type field
                        },
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainMenuPage(
                            onSignedOut: widget.onSignedOut,
                          ),
                        ),
                      );
                    },
                    child: Center(
                      child: Text(
                        "Apply",
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _game_gender() {
    return Container(
      child: Row(
        children: <Widget>[
          new Padding(padding: const EdgeInsets.all(16.0), child: Icon(Icons.wc, color: Colors.grey)),
          Container(
            height: 30.0,
            width: 1.0,
            color: Colors.grey.withOpacity(0.5),
            margin: const EdgeInsets.only(right: 10.0),
          ),
          Radio(
            value: Gender.MALE,
            groupValue: _selectedGender,
            onChanged: (Gender value) {
              setState(
                    () {
                  _selectedGender = value;
                },
              );
            },
          ),
          Text("Male", style: TextStyle(color: Colors.grey, fontSize: 16)),
          Radio(
            value: Gender.FEMALE,
            groupValue: _selectedGender,
            onChanged: (Gender value) {
              setState(
                    () {
                  _selectedGender = value;
                },
              );
            },
          ),
          Text("Female", style: TextStyle(color: Colors.grey, fontSize: 16)),
          Radio(
            value: Gender.ALL,
            groupValue: _selectedGender,
            onChanged: (Gender value) {
              setState(
                    () {
                  _selectedGender = value;
                },
              );
            },
          ),
          Text("All", style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }

  Widget distanceViewUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            "Distance from city center",
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey, fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16, fontWeight: FontWeight.normal),
          ),
        ),
        SliderView(
          distValue: distValue,
          onChnagedistValue: (value) {
            distValue = value;
          },
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget preferenceSport() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            "선호 종목",
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey, fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16, fontWeight: FontWeight.normal),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Column(
            children: getPList(),
          ),
        ),
        SizedBox(
          height: 8,
        )
      ],
    );
  }

  List<Widget> getPList() {
    List<Widget> noList = List<Widget>();
    var cout = 0;
    final columCount = 2;
    for (var i = 0; i < sportListData.length / columCount; i++) {
      List<Widget> listUI = List<Widget>();
      for (var i = 0; i < columCount; i++) {
        try {
          final sport = sportListData[cout];
          listUI.add(
            Expanded(
              child: Row(
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      onTap: () {
                        setState(
                              () {
                            sport.isSelected = !sport.isSelected;
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              sport.isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                              color:
                              sport.isSelected ? GameJoinTheme.buildLightTheme().primaryColor : Colors.grey.withOpacity(0.6),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              sport.titleTxt,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
          cout += 1;
        } catch (e) {
          print(e);
        }
      }
      noList.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: listUI,
        ),
      );
    }
    return noList;
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: GameJoinTheme.buildLightTheme().primaryColor,
        boxShadow: <BoxShadow>[
          BoxShadow(color: Colors.grey.withOpacity(0.2), offset: Offset(0, 2), blurRadius: 4.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.close),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  "사용자 정보 설정",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
            )
          ],
        ),
      ),
    );
  }
}