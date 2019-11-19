import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gteams/menu/widgets/page.dart';
import 'package:gteams/menu/widgets/pager.dart';
import 'package:gteams/manager_main/model/FacilityTmpData.dart';
import 'package:gteams/menu/widgets/aliment.dart';
import 'package:gteams/menu/widgets/sports_content.dart';

class MainHomePageScreen extends StatelessWidget {
  MainHomePageScreen() {
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: MenuPager(
          children: Facilities.facilities.map(
                (aliment) => Page(
              title: "G-TEAM",
              background: aliment.background,
              child: CardItem(
                child: AlimentWidget(
                  aliment: aliment,
                  theme: aliment.background,
                ),
              ),
            ),
          )
              .toList(),
        ),
      ),
    );
  }
}
