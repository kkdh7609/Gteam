import 'package:flutter/material.dart';
import 'package:gteams/manager_main/ManagerMenuScreen.dart';


class ManagerMainMenuPage extends StatefulWidget {
  ManagerMainMenuPage({Key key, this.onSignedOut}) : super(key: key);

  final VoidCallback onSignedOut;

  @override
  _ManagerMainMenuPageState createState() => _ManagerMainMenuPageState();
}

class _ManagerMainMenuPageState extends State<ManagerMainMenuPage> {

  AnimationController sliderAnimationController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          body: MainManagerPageScreen(onSignedOut: widget.onSignedOut),
        ),
      ),
    );
  }
}