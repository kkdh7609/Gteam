import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gteams/map/google_map.dart';
import 'package:gteams/game/game_join/model/GameListData.dart';
import 'package:gteams/game/game_join/widgets/GameListView.dart';
import 'package:gteams/game/game_join/widgets/GameJoinTheme.dart';
import 'package:gteams/game/game_join/widgets/GameFilterScreen.dart';
import 'package:gteams/game/game_join/widgets/CalendarPopUpView.dart';
import 'package:gteams/map/StadiumListData.dart';
import 'package:gteams/game/game_join/model/StreamList.dart';

class GameJoinPage extends StatefulWidget {
  @override
  _GameJoinPageState createState() => _GameJoinPageState();
}

enum Filter {
  DATE,
  SEARCH,
}

class _GameJoinPageState extends State<GameJoinPage> with TickerProviderStateMixin {

  var gameList =GameListData.gameList;
  var stadiumList =StadiumListData.stadiumList;
  var stadiumListForMap = StadiumListData.stadiumList;
  StadiumListData stadiumData;
  List<DocumentReference> gameRef = [];
  int gameListLength;
  bool flag =false;

  AnimationController animationController;
  ScrollController _scrollController = new ScrollController();

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(Duration(days: 5));
  String _nowLocation;
  String _nowAddr;

  //필터링에 사용되는것
  int _selectStream;
  Query basicStream; // stream을 사용하기 위한 기본 쿼리
  String _searchTxt="";
  String _tmpTxt="";
  Filter filter;
  Iterable<DocumentSnapshot> filterSnapshot;


  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  void initState() {
    this.gameList = GameListData.gameList;
    this.stadiumList =StadiumListData.stadiumList;
    this.stadiumListForMap =StadiumListData.stadiumList;
    this.flag =false;
    this._selectStream=0;
    this.filter=Filter.DATE;
    animationController = AnimationController(duration: Duration(milliseconds: 1000), vsync: this);
    basicStream = Firestore.instance.collection('game3').where('reserve_status',isEqualTo: 0);

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
                resizeToAvoidBottomPadding: false,
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
                                  body: _buildBody(true),
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

  // 달력에서 선택한 날짜 범위 안에 있는 데이터만 가져오기 위한 함수
  bool dateCheck(DocumentSnapshot document){
    return document.data['dateNumber'] >= startDate.millisecondsSinceEpoch
        && document.data['dateNumber'] <= endDate.millisecondsSinceEpoch ? true : false;
  }
  bool search(DocumentSnapshot document){
    return document.data['gameName'].toString().contains(new RegExp(r'^.*'+_searchTxt+'.*'));
  }

  ///YeongUn modify
  ///By using Stream Builder, Firestroe game2 collection and App can update real time
  Widget _buildBody(bool check) {
    return StreamBuilder<QuerySnapshot>(
        stream : StreamList.streamQuery(basicStream, _selectStream).snapshots(),
        builder: (context, snapshot) {
            if(!snapshot.hasData) return LinearProgressIndicator();
            filterSnapshot = snapshot.data.documents.where(dateCheck);
            switch(filter){
              case Filter.DATE:
                break;
              case Filter.SEARCH:
                filterSnapshot = filterSnapshot.where(search);
                break;
            }

            if(filterSnapshot.length == 0) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(FontAwesomeIcons.minusCircle, color: GameJoinTheme.buildLightTheme().primaryColor, size: 100),
                  SizedBox(height: 30),
                  Text("No Data Founded.." ,
                      style: TextStyle(
                          fontFamily: 'Dosis',
                          fontWeight: FontWeight.w600,
                          fontSize: 30,
                          color: GameJoinTheme.buildLightTheme().primaryColor)
                  ),
                ],
              ),
              );
            }
            gameList = filterSnapshot.map((data) => GameListData.fromJson(data.data)).toList();
            //gameReference 저장
            for(int i = 0; i < gameList.length ; i++){
              gameRef.add(filterSnapshot.elementAt(i).reference);
            }

            if(flag && filterSnapshot.length != stadiumList.length){
            flag = false;
             }
            if(!flag) {
              flag = true;
              stadiumList = new List(filterSnapshot.length);
            }
            return _showGamelist(context,filterSnapshot.toList());
        }
    );
  }

  Widget _showGamelist(BuildContext context, List<DocumentSnapshot> snapshot) {
    return Container(
      color: GameJoinTheme.buildLightTheme().backgroundColor,
      child: ListView.builder(
        itemCount: snapshot.length,
        padding: EdgeInsets.only(top: 8),
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          var count = snapshot.length > 10 ? 10 : snapshot.length;
          var animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: animationController, curve: Interval((1 / count) * index, 1.0, curve: Curves.fastOutSlowIn)));
          animationController.forward();
          //GameData 및 stadium Data Setting
          gameList[index].stadiumRef.get().then((document){
            if(this.mounted ){
              setState(() {
                stadiumList[index] = StadiumListData.fromJson(document.data);
                gameListLength = gameList.length;
              });
            }
          });
          // StadiumData를 받고 나서 GameListView를 출력해준다.
          return stadiumList[index] != null ?GameListView(
            callback: () {},
            gameData: gameList[index],
            stadiumData: stadiumList[index],
            docId :snapshot[index].documentID,
            animation: animation,
            animationController: animationController,
          ) : LinearProgressIndicator();
        },
      ),
    );
  }

  void _changeLoc(String newLocation,String newAddr, String temp) {
    _nowLocation = newLocation;
    _nowAddr     = newAddr;
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
        child: Container(
            color: GameJoinTheme.buildLightTheme().primaryColor,
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
                                  child: Icon(Icons.arrow_back, color: Colors.white),
                                )
                            )
                        )
                    ),
                    Expanded(
                        child: Center(
                            child: Text("게임 목록", style: TextStyle(
                                fontFamily: 'Dosis',
                                fontWeight: FontWeight.w600, fontSize: 22, color: Colors.white))
                        )
                    ),
                    Container(
                        width: AppBar().preferredSize.height + 40,
                        height: AppBar().preferredSize.height,
                        child: _showMapIconUi()
                    )
                  ],
                )
            )
        )
    );
  }

  ///YeongUn Modify
  ///By using Stream Builder, Firestore stadium collection and google_map can update real time
  Widget _showMapIconUi(){
    return StreamBuilder<QuerySnapshot>(
        stream  : Firestore.instance.collection("stadium").snapshots(),
        builder : (context, snapshot){
          if(!snapshot.hasData) return LinearProgressIndicator();
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Material(
                  color: Colors.transparent,
                  child: InkWell(
                      borderRadius: BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                      onTap: () {
                        this.stadiumListForMap=snapshot.data.documents.map((data) => StadiumListData.fromJson(data.data)).toList();
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>MapTest(onSelected: _changeLoc,stadiumList: stadiumListForMap, nowReq: mapReq.mapCheck,)));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(FontAwesomeIcons.mapMarkedAlt, color: Colors.white),
                      )
                  )
              )
            ],
          );
        }
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
                    BoxShadow(color: Colors.grey.withOpacity(0.2), offset: Offset(0, 2), blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
                  child: TextField(
                    onChanged: (String txt) {
                      _tmpTxt=txt;
                    },
                    style: TextStyle(fontSize: 18, fontFamily : 'Dosis'),
                    cursorColor: GameJoinTheme.buildLightTheme().primaryColor,
                    decoration: new InputDecoration(
                        border: InputBorder.none,
                        hintText: "Suwon",
                        hintStyle: TextStyle(
                            fontFamily: 'Dosis',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black.withOpacity(0.2))),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: GameJoinTheme.buildLightTheme().primaryColor,
              borderRadius: BorderRadius.all(
                Radius.circular(38.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(color: Colors.grey.withOpacity(0.4), offset: Offset(0, 2), blurRadius: 8.0),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: () {
                  _searchTxt=_tmpTxt;
                  filter=Filter.SEARCH;
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(FontAwesomeIcons.search, size: 20, color: GameJoinTheme.buildLightTheme().backgroundColor)),
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
                            style: TextStyle(
                                fontFamily: 'Dosis',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black.withOpacity(0.5)),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "${DateFormat("dd, MMM").format(startDate)} - ${DateFormat("dd, MMM").format(endDate)}",
                            style: TextStyle(
                                fontFamily: 'Dosis',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black.withOpacity(0.5)),
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
                            "Number of Members",
                            style: TextStyle(
                                fontFamily: 'Dosis',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black.withOpacity(0.5)),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "10 Members",
                            style: TextStyle(
                                fontFamily: 'Dosis',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black.withOpacity(0.5)),
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
                    child: gameListLength != null ? Text(
                      filterSnapshot.length.toString()+" games found",
                      style: TextStyle(
                          fontFamily: 'Dosis', fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black.withOpacity(0.5)),
                    ) : Text(
                      "Loading.. ",
                      style: TextStyle(
                          fontFamily: 'Dosis', fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black.withOpacity(0.5)),
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
                      ).then((data){
                        if(data != null){
                          print(11111111);
                          print(data);
                          setState(() {
                            this._selectStream=data;
                          });
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Filter",
                            style: TextStyle(
                                fontFamily: 'Dosis',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black.withOpacity(0.5)),
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
              filter=Filter.DATE;
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
    return true;
  }
}