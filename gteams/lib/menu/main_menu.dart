import 'package:flutter/material.dart';
import 'package:gteams/menu/MainMenuScreen.dart';
import 'package:gteams/menu/drawer/homeDrawer.dart';
import 'package:gteams/menu/drawer/DrawerTheme.dart';
import 'package:gteams/setting/currentRoomMenu/currentRoomList.dart';
import 'package:gteams/menu/drawer/drawerUserController.dart';
import 'package:gteams/pay/pay.dart';
import 'package:gteams/contact_page.dart';

class MainMenuPage extends StatefulWidget {
  MainMenuPage({
    Key key,
    this.onSignedOut,
  }) : super(key: key);

  final VoidCallback onSignedOut;

  @override
  _MainMenuPageState createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  Widget screenView;
  DrawerIndex drawerIndex;
  AnimationController sliderAnimationController;

  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    screenView = MainHomePageScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DrawerTheme.nearlyWhite,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: DrawerTheme.nearlyWhite,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            animationController: (AnimationController animationController) {
              sliderAnimationController = animationController;
            },
            onDrawerCall: (DrawerIndex drawerIndexData) {
              changeIndex(drawerIndexData);
            },
            screenView: screenView,
            onSignedOut: widget.onSignedOut,
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexData) {
    if (drawerIndex != drawerIndexData) {
      drawerIndex = drawerIndexData;
      if (drawerIndex == DrawerIndex.HOME) {
        setState(
          () {
            screenView = MainHomePageScreen();
          },
        );
      } else if (drawerIndex == DrawerIndex.POINTCHARGE) {
        setState(
          () {
            drawerIndex = DrawerIndex.HOME;
            Navigator.push(context, MaterialPageRoute(builder: (context) => PayPage()));
            screenView = MainHomePageScreen();
          },
        );
      } else if (drawerIndex == DrawerIndex.CURRENTROOM) {
        setState(
          () {
            drawerIndex = DrawerIndex.HOME;
            Navigator.push(context, MaterialPageRoute(builder: (context) => CurrentRoomListPage()));
            screenView = MainHomePageScreen();
          },
        );
      } else if (drawerIndex == DrawerIndex.CONTACT) {
        setState(
          () {
            drawerIndex = DrawerIndex.HOME;
            Navigator.push(context, MaterialPageRoute(builder: (context) => ContactPage()));
            screenView = MainHomePageScreen();
          },
        );
      }
    }
  }
}
