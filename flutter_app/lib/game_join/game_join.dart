import 'dart:ui';
import 'package:gteams/game_join/model/GameListData.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gteams/game_join/GameListView.dart';
import 'package:gteams/game_join/GameJoinTheme.dart';
import 'package:gteams/game_join/GameFilterScreen.dart';
import 'package:gteams/game_join/CalendarPopUpView.dart';
import 'package:gteams/services/crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GameJoinPage extends StatefulWidget {
  @override
  _GameJoinPageState createState() => _GameJoinPageState();
}

class _GameJoinPageState extends State<GameJoinPage> with TickerProviderStateMixin {

  var gameList =GameListData.gameList;

  crudMedthods crudObj = new crudMedthods();

  AnimationController animationController;
  ScrollController _scrollController = new ScrollController();

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(Duration(days: 5));

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  void initState() {
    this.gameList = GameListData.gameList;
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: GameJoinTheme.buildLightTheme(),
        child: Container(
            child: Scaffold(
                body: Stack(
                  children: <Widget>[
                    InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        child: Column(
                          children: <Widget>[
                            _showAppBarUI(),
                            Expanded(
                                child: NestedScrollView(
                                  controller: _scrollController,
                                  headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                                    return <Widget>[
                                      SliverList(
                                        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                                          return Column(
                                            children: <Widget>[
                                              _showSearchBarUI(),
                                              _showTimeDateUI(),
                                            ],
                                          );
                                        }, childCount: 1),
                                      ),
                                      SliverPersistentHeader(
                                        pinned: true,
                                        floating: true,
                                        delegate: ContestTabHeader(
                                          _showFilterBarUI(),
                                        ),
                                      ),
                                    ];
                                  },
                                  body: _buildBody()
                                )
                            )
                          ],
                        )
                    )
                  ],
                )
            )
        )
    );
  }
  /*YeongUn modify
  By using Stream Builder, Firestroe game2 collection and App can update real time*/
  Widget _buildBody(){
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('game2').snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData) return LinearProgressIndicator();

          return _showGamelist(context,snapshot.data.documents);
        }
      );
  }

  Widget _showGamelist(BuildContext context, List<DocumentSnapshot> snapshot){
    return Container(
      color: GameJoinTheme.buildLightTheme().backgroundColor,
      child:  ListView.builder(
        itemCount: snapshot.length,
        padding: EdgeInsets.only(top: 8),
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          var count = snapshot.length > 10 ? 10 : snapshot.length;
          var animation = Tween(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                  parent: animationController,
                  curve: Interval((1 / count) * index, 1.0, curve: Curves.fastOutSlowIn)));
          animationController.forward();
          return GameListView(
            callback: () {},
            gameData: snapshot.map((data) => GameListData.fromJson(data.data)).toList()[index],
            animation: animation,
            animationController: animationController,
          );
        },
      ),
    );
  }

  /* AppBar 보여주는 UI */
  Widget _showAppBarUI() {
    return Container(
        decoration: BoxDecoration(
            color: GameJoinTheme
                .buildLightTheme()
                .backgroundColor,
            boxShadow: <BoxShadow>[
              BoxShadow(color: Colors.grey.withOpacity(0.2),
                  offset: Offset(0, 2),
                  blurRadius: 8.0),
            ]
        ),
        child: Padding(
            padding: EdgeInsets.only(top: MediaQuery
                .of(context)
                .padding
                .top, left: 8, right: 8),
            child: Row(
              children: <Widget>[
                Container(
                    alignment: Alignment.centerLeft,
                    width: AppBar().preferredSize.height + 40,
                    height: AppBar().preferredSize.height,
                    child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                            borderRadius: BorderRadius.all(
                              Radius.circular(32.0),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.arrow_back),
                            )
                        )
                    )
                ),
                Expanded(
                    child: Center(
                        child: Text("Search the Game", style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 22),)
                    )
                ),
                Container(
                    width: AppBar().preferredSize.height + 40,
                    height: AppBar().preferredSize.height,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Material(
                            color: Colors.transparent,
                            child: InkWell(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(32.0),
                                ),
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(FontAwesomeIcons.mapMarkedAlt),
                                )
                            )
                        )
                      ],
                    )
                )
              ],
            )
        )
    );
  }

  Widget _showSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: GameJoinTheme.buildLightTheme().backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(38.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(color: Colors.grey.withOpacity(0.2),
                              offset: Offset(0, 2),
                              blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 4, bottom: 4),
                  child: TextField(
                    onChanged: (String txt) {},
                    style: TextStyle(fontSize: 18),
                    cursorColor: GameJoinTheme.buildLightTheme().primaryColor,
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      hintText: "Suwon",
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: GameJoinTheme
                  .buildLightTheme()
                  .primaryColor,
              borderRadius: BorderRadius.all(
                Radius.circular(38.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(color: Colors.grey.withOpacity(0.4),
                    offset: Offset(0, 2),
                    blurRadius: 8.0),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(
                      FontAwesomeIcons.search,
                      size: 20,
                      color: GameJoinTheme.buildLightTheme().backgroundColor)
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showTimeDateUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 18, bottom: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      // setState(() {
                      //   isDatePopupOpen = true;
                      // });
                      showDemoDialog(context: context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Choose date",
                            style: TextStyle(fontWeight: FontWeight.w100, fontSize: 16, color: Colors.grey.withOpacity(0.8)),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "${DateFormat("dd, MMM").format(startDate)} - ${DateFormat("dd, MMM").format(endDate)}",
                            style: TextStyle(
                              fontWeight: FontWeight.w100,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: Container(
              width: 1,
              height: 42,
              color: Colors.grey.withOpacity(0.8),
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Number of Rooms",
                            style: TextStyle(fontWeight: FontWeight.w100, fontSize: 16, color: Colors.grey.withOpacity(0.8)),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "1 Room - 2 Adults",
                            style: TextStyle(
                              fontWeight: FontWeight.w100,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _showFilterBarUI() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 24,
            decoration: BoxDecoration(
              color: GameJoinTheme.buildLightTheme().backgroundColor,
              boxShadow: <BoxShadow>[
                BoxShadow(color: Colors.grey.withOpacity(0.2), offset: Offset(0, -2), blurRadius: 8.0),
              ],
            ),
          ),
        ),
        Container(
          color: GameJoinTheme.buildLightTheme().backgroundColor,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "530 hotels found",
                      style: TextStyle(
                        fontWeight: FontWeight.w100,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GameFilterScreen(), fullscreenDialog: true),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Filtter",
                            style: TextStyle(
                              fontWeight: FontWeight.w100,
                              fontSize: 16,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.sort, color: GameJoinTheme.buildLightTheme().primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Divider(
            height: 1,
          ),
        )
      ],
    );
  }

  void showDemoDialog({BuildContext context}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CalendarPopupView(
        barrierDismissible: true,
        minimumDate: DateTime.now(),
        //  maximumDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 10),
        initialEndDate: endDate,
        initialStartDate: startDate,
        onApplyClick: (DateTime startData, DateTime endData) {
          setState(() {
            if (startData != null && endData != null) {
              startDate = startData;
              endDate = endData;
            }
          });
          },
        onCancelClick: () {},
      ),
    );
  }
}

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  final Widget searchUI;
  ContestTabHeader(
      this.searchUI,
      );
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return searchUI;
  }

  @override
  double get maxExtent => 52.0;

  @override
  double get minExtent => 52.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}