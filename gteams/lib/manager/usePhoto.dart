import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';
import 'dart:io';

typedef FileCallBack = void Function(ImageProvider);

class ImageCapture extends StatefulWidget{
  ImageCapture({this.photo, this.onPressed});

  final ImageProvider photo;
  final FileCallBack onPressed;
  createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture>{
  File _imageFile;
  ImageProvider _image;

  @override
  void initState(){
    super.initState();
    _image = widget.photo;
  }

  Future<void> _pickImage(ImageSource source) async{
    File selected = await ImagePicker.pickImage(source: source);
    if(selected != null) {
      setState(() {
        _imageFile = selected;
        _image = FileImage(_imageFile);
      });
    }
  }

  void _clear(){
    setState((){
      _imageFile = null;
      _image = null;
    });
  }

  Future<void> _cropImage() async{
    File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
      /*toolbarColor: Color(0xff3B5998),
      toolbarTitle: 'Crop It'*/
    );

    setState((){
      _imageFile = cropped ?? _imageFile;
      _image = cropped ?? FileImage(_imageFile);
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text("Select Photo",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
          centerTitle: true,
          backgroundColor: Color(0xff20253d),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap:(){
                    _pickImage(ImageSource.gallery);
                },
                child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 1 / 2,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: _image != null ? _image : AssetImage("assets/image/camera.png")
                        )
                    )
                )),
              if(_imageFile != null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        child: Icon(Icons.crop),
                        onPressed: _cropImage,
                      ),
                      FlatButton(
                        child: Icon(IconData(58829, fontFamily: "MaterialIcons")),
                        onPressed: _clear,
                      )
                    ]
                )
              ]
              else if(_image != null) ...[
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        child: Icon(IconData(58829, fontFamily: "MaterialIcons")),
                        onPressed: _clear,
                      )
                    ]
                )
              ],

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
                              fontSize: 22,
                              color: Colors.white)))),
                  onPressed: () {
                    if(_imageFile != null){
                      widget.onPressed(_image);
                    }
                    else{
                      widget.onPressed(null);
                    }
                    Navigator.pop(context);
                  },
                  color: Color(0xff20253d)
              )
        ]),


     /* bottomNavigationBar: BottomAppBar(
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.photo_library),
                onPressed: () => _pickImage(ImageSource.gallery),
              )
            ], mainAxisAlignment: MainAxisAlignment.center,)),
*/
    );
  }
}


