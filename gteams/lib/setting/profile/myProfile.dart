import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gteams/game/game_join/widgets/GameJoinTheme.dart';
import 'package:gteams/map/google_map.dart';
import 'package:gteams/setting/popularFilterList.dart';
import 'package:gteams/game/game_create/GameCreateTheme.dart';
import 'package:gteams/setting/profile/preferenceTime.dart';
import 'package:gteams/menu/drawer/UserData.dart';
import 'package:gteams/services/crud.dart';
import 'package:gteams/map/StadiumListData.dart';
import 'package:gteams/root_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'dart:io';


class UserProfile extends StatefulWidget {
  UserProfile({Key key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

enum Gender { MALE, FEMALE }

class _UserProfileState extends State<UserProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  crudMedthods crudObj = new crudMedthods();

  UserData _userData;
  String _userDocID;
  File _image;
  bool _checkedImage = false;

  bool _checkedGender = false;
  bool _editClicked = false;

  Gender _selectedGender;

  List<SettingListData> sportListData = SettingListData.sportList;
  var stadiumList =StadiumListData.stadiumList;

  String _phoneValidator(String value){
    Pattern pattern = r'^[0-9]{2,4}-{1}[0-9]{3,4}-{1}[0-9]{4}$';
    RegExp regex = new RegExp(pattern);
    if(!regex.hasMatch(value))
      return '123-456-7890 형태로 입력해 주십시오';
    else
      return null;
  }

  void _change_loc_name(String newName, String temp, String temp2) {
    _userData.preferenceLoc = newName;
  }

  void _applyEdit(){
    List<String> updateList = []; // List for get select sport list
    for (var i = 0; i < sportListData.length; i++) {
      if (sportListData[i].isSelected) {
        print(sportListData[i].titleTxt + "   " + sportListData[i].isSelected.toString());
        updateList.add(sportListData[i].titleTxt);
      }
    }

    crudObj.updateData(
      'user',
      _userDocID,
      {
        'name': _userData.name,
        'gender': _selectedGender.toString(),
        'prferenceLoc': _userData.preferenceLoc,
        'sportList': updateList,
        'phoneNumber': _userData.phoneNumber,
      },
    );

    setState(() {
      _editClicked = false;
      print("edit clicked: "+ _editClicked.toString());
    });

    Navigator.pop(context);
  }

  Widget _my_gender() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Radio(
            activeColor: Color(0xff20253d),
            value: Gender.MALE,
            groupValue: _selectedGender,
            onChanged: (Gender value) {
              setState(() {
                _selectedGender = value;
              });
            },
          ),
          Text("남성", style: TextStyle(fontSize: 16, fontFamily: 'Dosis')),
          SizedBox(
            width: 20,
          ),
          Radio(
            activeColor : Color(0xff20253d),
            value: Gender.FEMALE,
            groupValue: _selectedGender,
            onChanged: (Gender value) {
              setState(() {
                _selectedGender = value;
              });
            },
          ),
          Text("여성", style: TextStyle(fontSize: 16, fontFamily: 'Dosis')),
        ],
      ),
    );
  }

  Widget _preferenceTime() {
    return Container(
      child: Row(
        children: <Widget>[
          new Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Icon(Icons.date_range, color: Color(0xFF364A54))),
          Container(
            height: 30.0,
            width: 1.0,
            color: GameCreateTheme.buildLightTheme().primaryColor.withOpacity(0.5),
            margin: const EdgeInsets.only(right: 10.0),
          ),
          FlatButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PreferenceTime(userData: _userData, userDocID: _userDocID)));
              },
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                  ),
                  Text(
                    "선호시간 수정",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0),
                  ),
                ],

              )),
        ],
      ),
    );
  }

  Widget _showGameLoc(){
    return StreamBuilder<QuerySnapshot>(
        stream  : Firestore.instance.collection("stadium").snapshots(),
        builder : (context, snapshot){
          if(!snapshot.hasData) return LinearProgressIndicator();
          return Container(
            child: Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.symmetric(horizontal: 20.0), child: Icon(Icons.location_on, color: Color(0xFF364A54))),
                Container(
                  height: 30.0,
                  width: 1.0,
                  color: GameCreateTheme.buildLightTheme().primaryColor.withOpacity(0.5),
                  margin: const EdgeInsets.only(right: 10.0),
                ),
                FlatButton(
                    child: Text(
                      _userData.preferenceLoc != null ? _userData.preferenceLoc : "선호 위치 설정",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0),
                    ),
                    onPressed: () {
                      this.stadiumList = snapshot.data.documents.map((data) => StadiumListData.fromJson(data.data)).toList();
                      //snapshot.data.documents[0].documentID
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MapTest(onSelected: _change_loc_name, nowReq: mapReq.findLocation, stadiumList: stadiumList,)));
                    }),
              ],
            ),
          );
        }
    );
  }

  Widget _title(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Text(
        title,
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w900, fontSize: 18.0, fontFamily:'Dosis'),
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
          child: Column(children: getPList()),
        ),
      ],
    );
  }

  List<Widget> getPList() {
    List<Widget> noList = List<Widget>();
    var cout = 0;
    final columCount = 2;

    for (var i = 0; i < sportListData.length / columCount; i++) {;
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
        if(cout == sportListData.length)  break;
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
        ));
    }
    return noList;
  }

  @override
  Widget build(BuildContext context) {

    Future chooseFile() async {
      await ImagePicker.pickImage(source: ImageSource.gallery).then((newImage) {
        setState(() {
          if(newImage != null) {
            _image = newImage;
            _checkedImage = true;
            _userData.imagePath = "not updated";
          }
        });
      });
    }

    Future uploadData() async {
      StorageReference storageReference = FirebaseStorage.instance.ref().child("profile/${_userData.email}.png");
      if(_image == null)
        _applyEdit();
      else{
        StorageUploadTask uploadTask = storageReference.putFile(_image);
        await uploadTask.onComplete;
        storageReference.getDownloadURL().then((fileURL) {
          _userData.imagePath = fileURL;
          crudObj.updateData(
            'user',
            _userDocID,
            {
              'imagePath' : _userData.imagePath.toString(),
            },
          );
          _applyEdit();
        });
      }
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("프로필 수정",
              style: TextStyle(
                  fontFamily: 'Dosis',
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center),
          backgroundColor: Color(0xff20253d),
          elevation: 1.5,
          leading: Builder(
            builder: (context) => IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop()),
          ),
        ),
        body: _editClicked == false ? StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('user').where('email', isEqualTo: RootPage.user_email).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return LinearProgressIndicator();
              // 최초 정보 체크
              if(!_checkedGender) {
                this._userData = snapshot.data.documents.map((data) => UserData.fromJson(data.data)).elementAt(0);
                _userDocID = snapshot.data.documents.elementAt(0).documentID;

                _selectedGender = (this._userData.gender == "Gender.FEMALE") ? Gender.FEMALE : Gender.MALE;

                for (var i = 0; i < sportListData.length; i++) {
                  if(this._userData.preferenceSports.contains(sportListData[i].titleTxt)) {
                    sportListData[i].isSelected = true;
                  }
                  else {
                    sportListData[i].isSelected = false;
                  }
                }

                _checkedGender = true;
              }

              return Container(
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
                                          InkWell(
                                            customBorder: CircleBorder(),
                                            onTap: () {
                                              chooseFile();
                                            },
                                            child: Container(
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
                                                backgroundImage: _userData.imagePath == null ?
                                                AssetImage("assets/image/profile_pic.png"):
                                                _checkedImage == false ?
                                                NetworkImage(_userData.imagePath): FileImage(_image),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 100,
                                            alignment: Alignment.center,
                                            child: TextFormField(
                                              initialValue: _userData.name,
                                              inputFormatters: [LengthLimitingTextInputFormatter(10)],
                                              textAlign: TextAlign.center,
                                              keyboardType: TextInputType.text,
                                              decoration: InputDecoration(
                                                hintText: _userData.name,
                                                hintStyle: TextStyle(color: Colors.black),
                                              ),
                                              style: TextStyle(fontSize: 18),
                                              onSaved: (value) {
                                                if(value.isEmpty) {
                                                  _userData.name = _userData.name;
                                                }else
                                                  _userData.name = value;
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          _my_gender(),
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
                                            _title("연락처"),
                                            Container(
                                              child: Row(
                                                children: <Widget>[
                                                  Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                                                      child: Icon(Icons.phone, color: Color(0xFF364A54))),
                                                  Container(
                                                    height: 30.0,
                                                    width: 1.0,
                                                    color: GameCreateTheme.buildLightTheme().primaryColor.withOpacity(0.5),
                                                    margin: const EdgeInsets.only(right: 10.0),
                                                  ),
                                                  Flexible(
                                                    child: TextFormField(
                                                      initialValue: _userData.phoneNumber,
                                                      validator: _phoneValidator,
                                                      inputFormatters: [LengthLimitingTextInputFormatter(20)],
                                                      enableInteractiveSelection: false,
                                                      keyboardType: TextInputType.number,
                                                      decoration: InputDecoration(
                                                        hintText: _userData.phoneNumber,
                                                        hintStyle: TextStyle(color: Colors.black),
                                                      ),
                                                      onSaved: (value) {
                                                        _userData.phoneNumber = value;
                                                      },
                                                    ),
                                                  ),
                                                  Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: 20.0)
                                                  ),
                                                ],
                                              ),
                                            ),
                                            _title("선호 종목"),
                                            _preferenceSport(),
                                            _title("선호 시간"),
                                            _preferenceTime(),
                                            _title("선호 위치"),
                                            _showGameLoc(),
                                          ],
                                        )),
                                  )),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 10, bottom: 10),
                                width: double.infinity,
                                child: MaterialButton(
                                  child: Text("Edit Profile", style: TextStyle(color: Colors.white, fontSize: 20)),
                                  color: Color(0xff20253d),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                      setState(() {
                                        _editClicked = true;
                                        print("edit clicked: "+ _editClicked.toString());
                                      });

                                      uploadData();

                                    }
                                  },
                                ),
                              )
                            ],
                          ))));
            }
        ): Center(child: CircularProgressIndicator()));
  }
}