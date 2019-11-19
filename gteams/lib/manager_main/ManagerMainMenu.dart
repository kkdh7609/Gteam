import 'package:flutter/material.dart';
import 'package:gteams/menu/MainMenuScreen.dart';
import 'package:gteams/menu/drawer/DrawerTheme.dart';

class ManagerMainMenuPage extends StatefulWidget {
  @override
  _ManagerMainMenuPageState createState() => _ManagerMainMenuPageState();
}

class _ManagerMainMenuPageState extends State<ManagerMainMenuPage> {
  Widget screenView;
  AnimationController sliderAnimationController;

  @override
  void initState() {
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
          body: screenView,
        ),
      ),
    );
  }

}
