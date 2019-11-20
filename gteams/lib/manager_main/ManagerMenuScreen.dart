import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gteams/manager_main/page.dart';
import 'package:gteams/manager_main/pager.dart';
import 'package:gteams/manager_main/model/FacilityTmpData.dart';
import 'package:gteams/manager_main/aliment.dart';
import 'package:gteams/manager_main/facility_content.dart';
import 'package:gteams/fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gteams/manager_main/ManagePay.dart';


class MainManagerPageScreen extends StatefulWidget {
/*
  MainManagerPageScreen() {
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp]);
  }
*/
  MainManagerPageScreen({Key key, this.onSignedOut}) : super(key: key);

  final VoidCallback onSignedOut;

  @override
  _MainManagerPageScreenState createState() => _MainManagerPageScreenState();
}

class _MainManagerPageScreenState extends State<MainManagerPageScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: MenuPager(
          children: Facilities.facilities.map(
                (facility) => Page(
              title: "Facility Manager",
              background: facility.background,
              child: CardItem(
                child: FacilityWidget(
                  facility: facility,
                  theme: facility.background,
                ),
                lastindex: facility.lastindex == true ? true : false,
              ),
            ),
          ).toList(),
        ),
      ),
        bottomNavigationBar: FancyBottomNavigation(
          activeIconColor: Colors.white,
          barBackgroundColor: Color(0xff20253d),
          circleColor: Color(0xff0D47A1),
          textColor: Colors.white,
          inactiveIconColor: Colors.white,
          tabs: [
            TabData(iconData: Icons.home, title: "Home"),
            TabData(iconData: FontAwesomeIcons.coins, title: "Point"),
            TabData(iconData: Icons.person, title: "Profile"),
            TabData(iconData: Icons.power_settings_new, title: "Logout")
          ],
          onTabChangedListener: (position) {
            setState(() {
              if(position == 1)
                Navigator.push(context, MaterialPageRoute(builder: (context) => ManagePay()));
              if(position == 3)
                widget.onSignedOut();
            });

            position = 0;
          },
        )
    );
  }
}