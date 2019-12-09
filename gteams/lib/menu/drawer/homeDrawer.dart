import 'package:gteams/menu/drawer/DrawerTheme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gteams/setting/profile/myProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gteams/root_page.dart';
import 'package:gteams/menu/drawer/UserData.dart';

class HomeDrawer extends StatefulWidget {
  final AnimationController iconAnimationController;
  final DrawerIndex screenIndex;
  final Function(DrawerIndex) callBackIndex;
  final VoidCallback onSignedOut;

  HomeDrawer({Key key, this.screenIndex, this.iconAnimationController, this.callBackIndex, this.onSignedOut}) : super(key: key);

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  List<DrawerList> drawerList;
  UserData _userData;
  @override
  void initState() {
    setDrawerList();
    super.initState();
  }

  void setDrawerList() {
    drawerList = [
      DrawerList(
        index: DrawerIndex.HOME,
        labelName: 'Main',
        icon: new Icon(Icons.home),
      ),
      DrawerList(
        index: DrawerIndex.POINTCHARGE,
        labelName: 'Point Charge',
        //isAssetsImage: true,
        icon: new Icon(FontAwesomeIcons.coins, color: Colors.black),
      ),
      DrawerList(
        index: DrawerIndex.CURRENTROOM,
        labelName: 'Current Room',
        icon: new Icon(Icons.group),
      ),
      DrawerList(
        index: DrawerIndex.CONTACT,
        labelName: 'About G-TEAM',
        icon: new Icon(Icons.info),
      ),
    ];
  }

  Widget userInfo(){
    return StreamBuilder<QuerySnapshot>(
        stream : Firestore.instance.collection("user").where('email',isEqualTo: RootPage.user_email).snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData) return LinearProgressIndicator();
          this._userData = snapshot.data.documents.map((data) => UserData.fromJson(data.data)).elementAt(0);
          return  Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 40.0),
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, Widget child) {
                      return new ScaleTransition(
                        scale: new AlwaysStoppedAnimation(1.0 - (widget.iconAnimationController.value) * 0.2),
                        child: RotationTransition(
                          turns: new AlwaysStoppedAnimation(Tween(begin: 0.0, end: 24.0)
                              .animate(CurvedAnimation(parent: widget.iconAnimationController, curve: Curves.fastOutSlowIn))
                              .value /
                              360),
                          child: Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: <BoxShadow>[
                                BoxShadow(color: DrawerTheme.grey.withOpacity(0.6), offset: Offset(2.0, 4.0), blurRadius: 8),
                              ],
                            ),
                            child: CircleAvatar(
                              minRadius: 10,
                              backgroundColor: Colors.transparent,
                              backgroundImage: _userData.imagePath == null ?
                              AssetImage("assets/image/profile_pic.png"): NetworkImage(
                                  _userData.imagePath
                              )
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 4),
                    child: Row(
                      children: <Widget>[
                        Text(
                          _userData.name,
                          style: TextStyle(
                            fontFamily: 'Dosis',
                            fontWeight: FontWeight.w600,
                            color: DrawerTheme.grey,
                            fontSize: 18,
                          ),
                        ),
                        Padding(padding: const EdgeInsets.only(left: 15), child: InkWell(onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => UserProfile()));
                        }, child: Text("Edit")))
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DrawerTheme.notWhite.withOpacity(0.5),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          userInfo(),
          SizedBox(
            height: 4,
          ),
          Divider(
            height: 1,
            color: DrawerTheme.grey.withOpacity(0.6),
          ),
          Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(0.0),
                itemCount: drawerList.length,
                itemBuilder: (context, index) {
                  return inkwell(drawerList[index]);
                },
              )),
          Divider(
            height: 1,
            color: DrawerTheme.grey.withOpacity(0.6),
          ),
          Column(
            children: <Widget>[
              ListTile(
                title: new Text(
                  "Sign Out",
                  style: new TextStyle(
                    fontFamily: DrawerTheme.fontName,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: DrawerTheme.darkText,
                  ),
                  textAlign: TextAlign.left,
                ),
                trailing: new Icon(
                  Icons.power_settings_new,
                  color: Colors.red,
                ),
                onTap: () { widget.onSignedOut();
                            /*Navigator.pop(context);
                              Navigator.push(context,
                              MaterialPageRoute(builder: (context) => MyApp()));*/
                            // 혹시 나중에 로그아웃 검은화면 뜨면 이부분 확인
                            },
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget inkwell(DrawerList listData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          navigationtoScreen(listData.index);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 6.0,
                    height: 46.0,
                    decoration: BoxDecoration(
                      color: widget.screenIndex == listData.index ? Colors.black : Colors.transparent,
                      borderRadius: new BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  listData.isAssetsImage
                      ? Container(
                    width: 24,
                    height: 24,
                    child: Image.asset(listData.imageName,
                        color: widget.screenIndex == listData.index ? DrawerTheme.primaryColor : DrawerTheme.nearlyBlack),
                  )
                      : new Icon(listData.icon.icon,
                      color: widget.screenIndex == listData.index ? DrawerTheme.primaryColor : DrawerTheme.nearlyBlack),
                  Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  new Text(
                    listData.labelName,
                    style: new TextStyle(
                      fontFamily: 'Dosis',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: widget.screenIndex == listData.index ? DrawerTheme.primaryColor : DrawerTheme.nearlyBlack,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            widget.screenIndex == listData.index ? AnimatedBuilder(
              animation: widget.iconAnimationController,
              builder: (BuildContext context, Widget child) {
                return new Transform(
                  transform: new Matrix4.translationValues(
                      (MediaQuery.of(context).size.width * 0.75 - 64) * (1.0 - widget.iconAnimationController.value - 1.0),
                      0.0,
                      0.0),
                  child: Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.75 - 64,
                      height: 46,
                      decoration: BoxDecoration(
                        color: DrawerTheme.primaryColor.withOpacity(0.1),
                        borderRadius: new BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(28),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(28),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
                : SizedBox()
          ],
        ),
      ),
    );
  }

  void navigationtoScreen(DrawerIndex indexScreen) async {
    widget.callBackIndex(indexScreen);
  }
}

enum DrawerIndex {
  HOME,
  POINTCHARGE,
  CURRENTROOM,
  CONTACT,
}

class DrawerList {
  String labelName;
  Icon icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex index;

  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.imageName = '',
  });
}