import 'package:flutter/material.dart';
import 'package:gteams/manager_main/page.dart';
import 'package:gteams/manager_main/pager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gteams/manager_main/aliment.dart';
import 'package:gteams/manager_main/model/FacilitySchema.dart';
import 'package:gteams/manager_main/facility_content.dart';
import 'package:gteams/fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gteams/manager_main/ManagePay.dart';
import 'package:gteams/root_page.dart';

typedef newFunc = Future<void> Function();

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

  List<Facility> facilities;
  List<DocumentSnapshot> staRefList = [];
  @override
  void initState() {
    facilities = [
      Facility(
        name: "Plus",
        background: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [const Color(0xFF083663), const Color(0xFF82B1FF)],
        ),
        subtitle: null,
        image: "assets/image/manager/plus.svg",
        lastindex: true,
      )
    ];
    refreshFacilities();
    super.initState();
  }

  Future<void> refreshFacilities() async {
    setState((){
      facilities = [];
      staRefList = [];
    });
    List<Facility> tempfacilities = [
        Facility(
          name: "Plus",
          background: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [const Color(0xFF083663), const Color(0xFF82B1FF)],
          ),
          subtitle: null,
          image: "assets/image/manager/plus.svg",
          lastindex: true,
        )
      ];
    List<DocumentSnapshot> tempStaRefList = [];

    var userRef = await Firestore.instance.collection('user').document(RootPage.userDocID).get();
    List<dynamic> idList = userRef.data["MyStadium"];
    for(int idx=0; idx < idList.length; idx++){
      var staRef = await Firestore.instance.collection('stadium').document(idList[idx]).get();
      List<String> locArr = staRef.data["location"].split(" ");
      String loc = "";
      for(int cnt=3; cnt<locArr.length; cnt++){
        loc += locArr[cnt];
        if(cnt != locArr.length - 1)    loc += " ";
      }
      tempfacilities.insert(0, Facility(
        name: staRef.data["stadiumName"],
        background: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [const Color(0xFF083663), const Color(0xFF82B1FF)],
        ),
        subtitle: loc,
        image: "assets/image/menu/soccerball.svg",
        lastindex: false,
      ));
      tempStaRefList.insert(0, staRef);
      /*setState(() {
        staRefList.insert(0, staRef);
        facilities.insert(0, Facility(
          name: staRef.data["stadiumName"],
          background: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [const Color(0xFF083663), const Color(0xFF82B1FF)],
          ),
          subtitle: loc,
          image: "assets/image/menu/soccerball.svg",
          lastindex: false,
        ));
      });
       */
    }
    RootPage.facilityData = List.of(tempStaRefList);
    setState((){
      staRefList = List.of(tempStaRefList);
      facilities = List.of(tempfacilities);
    });
  }

  @override
  Widget build(BuildContext context) {
    return facilities.length == 0 ? Center(child: CircularProgressIndicator()) : Scaffold(
      body: Stack(
          children: <Widget>[
            Container(
        child: MenuPager(
          children: mapIndexed(
            facilities, (index, facility) => Page(
              title: "Facility Manager",
              background: facility.background,
              child: CardItem(
                child: FacilityWidget(
                  facility: facility,
                  theme: facility.background,
                ),
                lastindex: facility.lastindex == true ? true : false,
                staRef: facility.lastindex == true ? null : staRefList[index],
                refreshData: refreshFacilities,
                index: index
              ),
            ),
          ).toList(),
        ),
      ),
            Align(
                child: InkWell(child: Icon(Icons.refresh, size: 40, color: Colors.white),
                onTap:(){refreshFacilities();}),
              alignment: const Alignment(0.0, 0.9),
            )
          ]),

        bottomNavigationBar: FancyBottomNavigation(
          activeIconColor: Colors.white,
          barBackgroundColor: Color(0xff20253d),
          circleColor: Color(0xff0D47A1),
          textColor: Colors.white,
          inactiveIconColor: Colors.white,
          tabs: [
            TabData(iconData: Icons.home, title: "Home"),
            TabData(iconData: FontAwesomeIcons.coins, title: "Point"),
            // TabData(iconData: Icons.person, title: "Profile"),
            TabData(iconData: Icons.power_settings_new, title: "Logout")
          ],
          onTabChangedListener: (position) {
            setState(() {
              if(position == 1){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ManagePay()));
              }
              if(position == 2)
                widget.onSignedOut();
            });
          },
        )
    );
  }

  Iterable<E> mapIndexed<E, T>(
      Iterable<T> items, E Function(int index, T item) f) sync* {
    var index = 0;

    for (final item in items) {
      yield f(index, item);
      index = index + 1;
    }
  }

}