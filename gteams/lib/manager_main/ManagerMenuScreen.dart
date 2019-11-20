import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gteams/manager_main/page.dart';
import 'package:gteams/manager_main/pager.dart';
import 'package:gteams/manager_main/model/FacilityTmpData.dart';
import 'package:gteams/manager_main/aliment.dart';
import 'package:gteams/manager_main/facility_content.dart';

class MainManagerPageScreen extends StatelessWidget {
  MainManagerPageScreen() {
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp]);
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
    );
  }
}
