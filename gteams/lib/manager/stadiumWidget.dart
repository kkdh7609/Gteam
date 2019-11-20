import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
  CheckButton({this.formKey});

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context){
    return IconButton(
        icon: Icon(Icons.check),
        onPressed: ((){
          if(formKey.currentState.validate()){
            // 통신이 여기에 들어가면 됨
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
