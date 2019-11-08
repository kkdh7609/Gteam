import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gteams/menu/widgets/page.dart';
import 'package:gteams/menu/widgets/pager.dart';
import 'package:gteams/menu/model/aliments.dart';
import 'package:gteams/menu/widgets/aliment.dart';
import 'package:gteams/menu/widgets/sports_content.dart';


class MainMenuPage extends StatelessWidget {

  MainMenuPage({Key key,this.onSignedOut,}):super(key: key);

  final VoidCallback onSignedOut;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'G-TEAM',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: MainHomePage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainHomePage extends StatelessWidget {
  MainHomePage() {
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
