import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:gteams/root_page.dart';

typedef selectFunc = void Function(int);
final GlobalKey<FormState> formKey = GlobalKey<FormState>();

class PhotoWidget extends StatelessWidget{
  PhotoWidget({this.photo, this.onPressed});

  final ImageProvider photo;
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
              image: photo != null? photo : AssetImage("assets/image/camera.png")
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
          )
        ),
        Divider(height: 1.0, color: Colors.black)
      ]
    )),]
    ));
  }
}


class CheckButton extends StatelessWidget{

  CheckButton({this.formKey,this.stadiumName,this.price,this.location,this.lat,this.lng,this.locId,this.telephone,this.isParking,this.isClothes,this.isShower,this.isBall,this.isShoes, @required this.refreshData});

  final GlobalKey<FormState> formKey;
  final String stadiumName;
  final String price;
  final String location;
  final double lat;
  final double lng;
  final String locId;
  final String telephone;
  final int isParking;
  final int isClothes;
  final int isShower;
  final int isShoes;
  final int isBall;
  final VoidCallback refreshData;

  @override
  Widget build(BuildContext context){
    return IconButton(
        icon: Icon(Icons.check),
        onPressed: (() async {
          if(formKey.currentState.validate()){
            var data = await Firestore.instance.collection('stadium').add({
              'imagePath' : "https://firebasestorage.googleapis.com/v0/b/gteam-18931.appspot.com/o/%ED%92%8B%EC%82%B4%EC%9E%A52.jpg?alt=media&token=f224a5cd-0869-46de-bb0f-487b0576e6a8",
              'stadiumName' : stadiumName,
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
            });
            var adminData = await Firestore.instance.collection('user').document(RootPage.userDocID).get();
            List<String> myStadium = List.from(adminData.data["MyStadium"]);
            myStadium.add(data.documentID);
            await Firestore.instance.collection('user').document(RootPage.userDocID).updateData({"MyStadium": myStadium});
            await Firestore.instance.collection('stadium').document(data.documentID).updateData({"stdId": data.documentID});
            Navigator.pop(context);
            refreshData();
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
  TimeWidget({this.checkTimes, this.onPressed});

  final bool checkTimes;
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
                    checkTimes ? "Edit times" : "Select times",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    minFontSize: 13.0,
                    maxLines: 2,
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
