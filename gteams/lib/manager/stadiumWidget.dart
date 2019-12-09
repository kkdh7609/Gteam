import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:gteams/root_page.dart';
import 'package:firebase_storage/firebase_storage.dart';

typedef selectFunc = void Function(int);
final GlobalKey<FormState> formKey = GlobalKey<FormState>();

class PhotoWidget extends StatelessWidget{
  PhotoWidget({this.image, this.onPressed});

  final ImageProvider image;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context){
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 1 / 3,
          height: MediaQuery.of(context).size.height * 1 / 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: image != null? image : AssetImage("assets/image/camera.png")
            )
          )
        )
      )
    );
  }
}
class TextWidget extends StatelessWidget{
  TextWidget({this.controller, this.header, this.hint, this.type});

  final TextEditingController controller;
  final String header;
  final String hint;
  final int type;

  @override
  Widget build(BuildContext context){
    return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
    child: Row(
        children: <Widget>[
          Expanded(
          child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(header, style: TextStyle(
          color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 13
        )),
        TextFormField(
          //key: _formKey,
          controller: controller,
          maxLength: 15,
          enableInteractiveSelection: false,
          keyboardType: type == 1 ? TextInputType.number : null,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey
            ),
          ),
          validator: (value) {
            return value.isEmpty ? "값을 입력하세요" : null;
          },
        ),
        Divider(height: 1.0, color: Colors.black)
      ]
    )),]
    ));
  }
}


class EditButton extends StatelessWidget{
  EditButton({this.formKey,this.photo, this.stadiumName,this.stadiumDescription, this.price, this.telephone,this.isParking,this.isClothes,this.isShower,this.isBall,this.isShoes, this.intTimes, this.strTimes, this.setAvailable, this.isPhotoChanged, this.docId, @required this.refreshData, @required this.popFunc});

  final GlobalKey<FormState> formKey;
  final List<int> intTimes;
  final File photo;
  final String stadiumName;
  final String stadiumDescription;
  final String price;
  final String telephone;
  final String docId;
  final List<String> strTimes;
  final int isParking;
  final int isClothes;
  final int isShower;
  final int isShoes;
  final int isBall;
  final bool isPhotoChanged;
  final VoidCallback refreshData;
  final VoidCallback popFunc;
  final void Function(bool) setAvailable;

  String photoURL;

  @override
  Widget build(BuildContext context){
    _showAlertDialog(title, text) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text(title),
                content: Text(text),
                actions: <Widget>[
                  FlatButton(
                    color: Color(0xff20253d),
                    child: Text("OK", style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ]);
          });
    }

    return IconButton(
        icon: Icon(Icons.check),
        onPressed: (() async {
          setAvailable(false);

          bool checkTimes = false;
          for(var idx=0;idx<strTimes.length;idx++){
            if(strTimes[idx] !="휴무"){
              checkTimes = true;
              break;
            }
          }

          if(checkTimes == false){
            _showAlertDialog("확인", ("운영 시간을 확인하세요"));
            setAvailable(true);
          }else{
            if(formKey.currentState.validate()){
              StorageReference storageReference;
              if(isPhotoChanged) {
                if (photo != null) {
                  storageReference = FirebaseStorage.instance.ref().child("stadium/${DateTime
                      .now()
                      .millisecondsSinceEpoch
                      .toString()}.jpg");
                  StorageUploadTask uploadTask = storageReference.putFile(photo);
                  await uploadTask.onComplete;
                }
                else {
                  storageReference = FirebaseStorage.instance.ref().child("stadium/camera.png");
                }
                // StorageUploadTask uploadTask = storageReference.putFile(photo);
                await storageReference.getDownloadURL().then((fileURL) {
                  photoURL = fileURL;
                  print("photoURL completed");
                });

                await Firestore.instance.collection('stadium').document(docId).updateData({
                  'imagePath' : photoURL
                });
              }
              print(stadiumName);
              await Firestore.instance.collection('stadium').document(docId).updateData({
                'stadiumName' : stadiumName,
                'stadiumDescription': stadiumDescription,
                'price' : int.parse(price),
                'telephone' : telephone,
                'isParking' : isParking,
                'isClothes' : isClothes,
                'isShower' : isShower,
                'isShoes' : isShoes,
                'isBall' : isBall,
                'intTimes' : intTimes,
                'strTimes' : strTimes,
                'gameList': [],
                'notPermitList': [],
              });
              refreshData();
              popFunc();
            }
            else{
              setAvailable(true);
            }
          }}
    ));
  }
}


class CheckButton extends StatelessWidget{

  CheckButton({this.formKey,this.photo, this.stadiumName,this.stadiumDescription, this.price,this.location,this.lat,this.lng,this.locId,this.telephone,this.isParking,this.isClothes,this.isShower,this.isBall,this.isShoes, this.intTimes, this.strTimes, this.setAvailable, @required this.refreshData, @required this.popFunc});

  final GlobalKey<FormState> formKey;
  final List<int> intTimes;
  final File photo;
  final String stadiumName;
  final String stadiumDescription;
  final String price;
  final String location;
  final double lat;
  final double lng;
  final String locId;
  final String telephone;
  final List<String> strTimes;
  final int isParking;
  final int isClothes;
  final int isShower;
  final int isShoes;
  final int isBall;
  final VoidCallback refreshData;
  final VoidCallback popFunc;
  final void Function(bool) setAvailable;


  String photoURL;

  @override
  Widget build(BuildContext context){
    _showAlertDialog(title, text) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text(title),
                content: Text(text),
                actions: <Widget>[
                  FlatButton(
                    color: Color(0xff20253d),
                    child: Text("OK", style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ]);
          });
    }

    return IconButton(
        icon: Icon(Icons.check),
        onPressed: (() async {
          setAvailable(false);

          if(location == null){
            _showAlertDialog("확인", "위치를 선택하세요");
            setAvailable(true);
          }else if(strTimes == null){
            _showAlertDialog("확인", "운영 시간을 선택하세요");
            setAvailable(true);
          }else{
            if(formKey.currentState.validate()){
              StorageReference storageReference;
              if(photo != null){
                storageReference = FirebaseStorage.instance.ref().child("stadium/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg");
                StorageUploadTask uploadTask = storageReference.putFile(photo);
                await uploadTask.onComplete;
              }
              else{
                storageReference = FirebaseStorage.instance.ref().child("stadium/camera.png");
              }
              // StorageUploadTask uploadTask = storageReference.putFile(photo);
              await storageReference.getDownloadURL().then((fileURL) {
                photoURL = fileURL;
                print("photoURL completed");
              });

              var data = await Firestore.instance.collection('stadium').add({
                'imagePath' : photoURL,
                'stadiumName' : stadiumName,
                'stadiumDescription': stadiumDescription,
                'rating' : 0.0,
                'rater' : 0,
                'price' : int.parse(price),
                'location' :location,
                'lat' : lat,
                'lng' : lng,
                'locId' : locId,
                'telephone' : telephone,
                'isParking' : isParking,
                'isClothes' : isClothes,
                'isShower' : isShower,
                'isShoes' : isShoes,
                'isBall' : isBall,
                'intTimes' : intTimes,
                'strTimes' : strTimes,
                'gameList': [],
                'notPermitList': [],
                'ownerId': RootPage.userDocID
              });
              var adminData = await Firestore.instance.collection('user').document(RootPage.userDocID).get();
              List<String> myStadium = List.from(adminData.data["MyStadium"]);
              myStadium.add(data.documentID);
              await Firestore.instance.collection('user').document(RootPage.userDocID).updateData({"MyStadium": myStadium});
              await Firestore.instance.collection('stadium').document(data.documentID).updateData({"stdId": data.documentID});
              refreshData();
              popFunc();
            }
            else{
              setAvailable(true);
            }
          }
        })
    );
  }
}

class PhoneWidget extends StatelessWidget{
  PhoneWidget({this.controller});

  final TextEditingController controller;

  String _phoneValidator(String value){
    Pattern pattern = r'^[0-9]{2,4}-{1}[0-9]{3,4}-{1}[0-9]{4}$';
    RegExp regex = new RegExp(pattern);
    if(!regex.hasMatch(value))
      return '잘못된 입력입니다. (123-456-789 형태로 입력해 주십시오)';
    else
      return null;
  }

  @override
  Widget build(BuildContext context){
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: Row(
            children: <Widget>[
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("연 락 처", style: TextStyle(
                            color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 13
                        )),
                        TextFormField(
                            key: formKey,
                            controller: controller,
                            enableInteractiveSelection: false,
                            validator: _phoneValidator,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "연락처를 입력하시오",
                              hintStyle: TextStyle(
                                  color: Colors.grey
                              ),
                            )
                        ),
                        Divider(height: 1.0, color: Colors.black)
                      ]
                  )),]
        )
    );
  }
}

class LocationWidget extends StatelessWidget{
  LocationWidget({this.location, this.onPressed});

  final String location;
  final VoidCallback onPressed;


  @override
  Widget build(BuildContext context){
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(FontAwesomeIcons.mapMarkedAlt),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("위 치", style: TextStyle(
                    color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 13
                  )),
                  SizedBox(height: 4.0),
                  AutoSizeText(
                    location == null ? "Select location" : location,
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    minFontSize: 13.0,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Divider(height: 1.0, color: Colors.black)
                ]
              )
            )
          ]
        )
      )
    );
  }
}

class TimeWidget extends StatelessWidget{
  TimeWidget({this.checkTimes, this.strTimes, this.onPressed});

  final bool checkTimes;
  final VoidCallback onPressed;
  final String strTimes;

  @override
  Widget build(BuildContext context){
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(FontAwesomeIcons.clock),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("운영시간", style: TextStyle(
                    color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 13
                  )),
                  SizedBox(height: 4.0),
                  AutoSizeText(
                    checkTimes ? strTimes : "Select times",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    minFontSize: 13.0,
                    maxLines: 100,
                    overflow: TextOverflow.ellipsis
                  ),
                  Divider(height: 1.0, color: Colors.black)
                ]
              )
            )
          ]
        )
      )
    );
  }
}

class SegmentedControl extends StatelessWidget{
  SegmentedControl({this.header, this.value, this.children, this.onValueChanged});

  final String header;
  final int value;
  final Map<int, Widget> children;
  final selectFunc onValueChanged;

  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(header, style:TextStyle(
              color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 13
          ))
        ),
        SizedBox(
          width: double.infinity,
          child: CupertinoSegmentedControl<int>(
            borderColor: Color(0xff20253d),
            children: children,
            groupValue: value,
            selectedColor: Color(0xff20253d),
            pressedColor: Color(0x0000253d),
            onValueChanged: onValueChanged,
          )
        )
      ]
    );
  }
}
