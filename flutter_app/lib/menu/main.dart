import 'package:gteams/menu/model/aliments.dart';
import 'package:gteams/menu/widgets/aliment.dart';
import 'package:gteams/menu/widgets/card_item.dart';
import 'package:gteams/menu/widgets/page.dart';
import 'package:gteams/menu/widgets/pager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyApps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BurnOff',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage() {
    SystemChrome.setPreferredOrientations(
        <DeviceOrientation>[DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: MenuPager(
          children: Aliments.aliments.map((aliment) => Page(
                      title: "G-TEAM",
                      background: aliment.background,
                      icon: aliment.bottomImage,
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
