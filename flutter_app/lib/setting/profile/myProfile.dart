import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gteams/game/game_join/widgets/GameJoinTheme.dart';
import 'package:gteams/map/google_map.dart';
import 'package:gteams/setting/popularFilterList.dart';
import 'package:gteams/setting/profile/preferenceTime.dart';
import 'package:gteams/setting/profile/PreferListData.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

enum Gender { MALE, FEMALE }

class _UserProfileState extends State<UserProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var preferList = PreferListData.preferList;

  String _userName = "My name"; // 기존 이름으로
  Gender _selectedGender = null;
  List<SettingListData> sportListData = SettingListData.sportList;

  // 시간 데이터 //
  String _loc_name = "주소";

  void _change_loc_name(String new_name) {
    _loc_name = new_name;
  }

  Widget _my_gender() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Radio(
            value: Gender.MALE,
            groupValue: _selectedGender,
            onChanged: (Gender value) {
              setState(() {
                _selectedGender = value;
              });
            },
          ),
          Text("남성", style: TextStyle(fontSize: 16)),
          SizedBox(
            width: 20,
          ),
          Radio(
            value: Gender.FEMALE,
            groupValue: _selectedGender,
            onChanged: (Gender value) {
              setState(() {
                _selectedGender = value;
              });
            },
          ),
          Text("여성", style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _preferenceTime(idx) {
    return Container(
      child: Row(
        children: <Widget>[
          new Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Icon(Icons.date_range, color: Color(0xFF364A54))),
          Container(
            height: 30.0,
            width: 1.0,
            color: Colors.grey.withOpacity(0.5),
            margin: const EdgeInsets.only(right: 10.0),
          ),
          FlatButton(
              child: Text(
                "현재 $idx개의 목록이 있습니다.",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PreferenceTime()));
              }),
        ],
      ),
    );
  }

  Widget _my_location() {
    return Container(
      child: Row(
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Icon(Icons.not_listed_location, color: Color(0xFF364A54)),
          ),
          Container(
            height: 30.0,
            width: 1.0,
            color: Colors.grey.withOpacity(0.5),
            margin: const EdgeInsets.only(right: 10.0),
          ),
          FlatButton(
              child: Text(
                _loc_name,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MapTest(onSelected: _change_loc_name)));
              }),
        ],
      ),
    );
  }

  Widget _title(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Text(
        title,
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18.0),
      ),
    );
  }

  Widget _preferenceSport() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Column(
            children: getPList(),
          ),
        ),
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
          listUI.add(Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    onTap: () {
                      setState(() {
                        sport.isSelected = !sport.isSelected;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            sport.isSelected
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: sport.isSelected
                                ? GameJoinTheme.buildLightTheme().primaryColor
                                : Colors.grey.withOpacity(0.6),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            sport.titleTxt,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ));
          cout += 1;
        } catch (e) {
          print(e);
        }
      }
      noList.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: listUI,
      ));
    }
    return noList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("프로필 수정",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w900),
              textAlign: TextAlign.center),
          backgroundColor: Color(0xff3B5998),
          elevation: 1.5,
          leading: Builder(
            builder: (context) => IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () => Navigator.of(context).pop()),
          ),
        ),
        body: Container(
            child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.all(10),
                            child: Card(
                                elevation: 5,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Container(
                                      height: 100,
                                      width: 100,
                                      margin: EdgeInsets.only(top: 10),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.orangeAccent),
                                      padding: EdgeInsets.all(5),
                                      child: CircleAvatar(
                                        minRadius: 10,
                                        backgroundColor: Colors.transparent,
                                        backgroundImage: AssetImage(
                                          "assets/image/userImage.png",
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 100,
                                      alignment: Alignment.center,
                                      child: TextFormField(
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          hintText: _userName,
                                          hintStyle: TextStyle(color: Colors.grey),
                                        ),
                                        style: TextStyle(fontSize: 18),
                                        validator: (value) {
                                          return value.isEmpty ? "Your name can\'t be empty" : null;
                                        },
                                        onSaved: (value) {
                                          _userName = value;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    _my_gender(),
                                    ////////////////
                                  ],
                                ))),
                        Container(
                            height: 300,
                            padding: EdgeInsets.all(10),
                            child: Card(
                              elevation: 5,
                              child: SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      _title("선호 종목"),
                                      _preferenceSport(),
                                      _title("선호 시간"),
                                      _preferenceTime(preferList.length),
                                      _title("선호 위치"),
                                      _my_location(),
                                    ],
                                  )),
                            )),
                        Container(
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10),
                          width: double.infinity,
                          child: MaterialButton(
                            child: Text("Edit Profile"),
                            color: Color(0xff3B5998),
                            onPressed: () {
                              if(_formKey.currentState.validate()){
                                _formKey.currentState.save();

                                // 데이터 갱신

                                Navigator.pop(context);
                              }
                            },
                          ),
                        )
                      ],
                    )))));
  }
}