import 'package:flutter/material.dart';
import 'package:gteams/manager_main/ManagerMenuScreen.dart';

class ManagerMainMenuPage extends StatefulWidget {
  @override
  _ManagerMainMenuPageState createState() => _ManagerMainMenuPageState();
}

class _ManagerMainMenuPageState extends State<ManagerMainMenuPage> {
  Widget screenView;
  AnimationController sliderAnimationController;

  @override
  void initState() {
    screenView = MainManagerPageScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          body: screenView,
        ),
      ),
    );
  }

}