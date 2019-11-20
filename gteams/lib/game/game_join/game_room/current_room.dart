import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gteams/game/game_join/model/MemberListData.dart';
import 'package:gteams/game/game_join/game_room/GameRoomTheme.dart';
import 'package:gteams/services/crud.dart';

class currentRoomPage extends StatefulWidget {

  currentRoomPage({Key key, this.currentUserList}) : super(key: key);

  List<dynamic> currentUserList;

  @override
  _currentRoomPageState createState() => _currentRoomPageState();
}

class _currentRoomPageState extends State<currentRoomPage> with SingleTickerProviderStateMixin {
  crudMedthods crudObj = new crudMedthods();
  var memberlist = MemberListData.memberList;

  final infoHeight = 100.0;
  var opacity1 = 0.0;
  var opacity2 = 0.0;
  var opacity3 = 0.0;

  @override
  void initState() {
    super.initState();
    this.memberlist = MemberListData.memberList;

    for(var i = 0; i < widget.currentUserList.length; i++){
      var userQuery = crudObj.getDocumentByWhere('user', 'email', widget.currentUserList[i]);

      userQuery.then((data){
        setState((){
          if(data.documents.length >= 1){
            var name = data.documents[0].data['name'];
            var address = data.documents[0].data['prferenceLoc'];
            this.memberlist.add(MemberListData(name: name, address: address));
          }
        });
      });
    }
  }

  @override
  void dispose() {
    this.memberlist.clear();
    super.dispose();
  }

  List<Widget> _tabTwoParameters() => [
    Tab(
      text: "Member",
      icon: Icon(Icons.group),
    ),
    Tab(
        text: "Chatting",
        icon: Icon(Icons.chat)),
    Tab(
      text: "details",
      icon: Icon(Icons.details),
    ),
  ];

  TabBar _tabBarLabel() => TabBar(
    tabs: _tabTwoParameters(),
    labelColor: Colors.redAccent,
    labelStyle: TextStyle(fontSize: 12),
    unselectedLabelColor: Colors.blueGrey,
    unselectedLabelStyle: TextStyle(fontSize: 12),
    onTap: (index) {
      var content = "";
      switch (index) {
        case 0:
          content = "Member";
          break;
        case 1:
          content = "Chatting";
          break;
        case 2:
          content = "details";
          break;
        default:
          content = "Other";
          break;
      }
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: <Widget>[
            _main_info(),
            Container(
//              constraints: BoxConstraints.expand(height: 50),
              child: _tabBarLabel(),
            ),
            Expanded(
              child: Container(
                child: TabBarView(children: [
                  ListView.builder(
                    itemCount: this.memberlist.length,
                    itemBuilder: (BuildContext context, int index){
                      return this.memberlist.length != 0 ?_member_info(
                          this.memberlist[index].name, this.memberlist[index].address
                      ):LinearProgressIndicator();
                    },
                  ),
                  Container(
                    child: Text("Chatting ui"),
                  ),
                  _detail_tab()
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _member_info(String name, String address){
    return Card(
      key: ValueKey(name),
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .5)),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
          leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right: new BorderSide(width: 1.0, color: Colors.white24))),
              child: Hero(
                  tag: "avatar_" + name,
                  child: CircleAvatar(
                    radius: 32,
                    backgroundImage: AssetImage("assets/image/userImage.png"),
                  )
              )
          ),
          title: Text(
            name,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Row(
            children: <Widget>[
              new Flexible(
                  child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            text: address,
                            style: TextStyle(color: Colors.white),
                          ),
                          maxLines: 3,
                          softWrap: true,
                        )
                      ]))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, MemberListData member) {
    return Card(
      key: ValueKey(member.name),
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
        child: ListTile(
          contentPadding:
          EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right: new BorderSide(width: 1.0, color: Colors.white24))),
              child: Hero(
                  tag: "avatar_" + member.name,
                  child: CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(member.photo),
                  )
              )
          ),
          title: Text(
            member.name,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Row(
            children: <Widget>[
              new Flexible(
                  child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            text: member.address,
                            style: TextStyle(color: Colors.white),
                          ),
                          maxLines: 3,
                          softWrap: true,
                        )
                      ]))
            ],
          ),
          trailing:
          Icon(Icons.group, color: Colors.white, size: 30.0),
        ),
      ),
    );
  }

  Widget _main_info(){
    return Container(
        child: Stack(
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(left: 10.0),
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage("assets/image/game/room/footsal_club.jpg"),
                    fit: BoxFit.fill,
                  ),
                )),
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              padding: EdgeInsets.all(40.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, .9)),
              child: Center(
                child: _main_info_text(),
              ),
            ),
            Positioned(
              left: 8.0,
              top: 50.0,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back, color: Colors.white),
              ),
            )
          ],
        ));
  }

  Widget _main_info_text(){
    return Padding(
        padding: EdgeInsets.only(left: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10.0),
            Text(
              "풋살 5vs5 ㄱㄱ",
              style: TextStyle(color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      "시작: "+"11:30",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    )
                ),
                Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      "/",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    )
                ),

                Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      "종료: "+"13:30",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    )
                ),

              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    flex: 8,
                    child: Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          "희망 수준: 6",
                          style: TextStyle(color: Colors.white),
                        )
                    )
                ),
                Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(7.0),
                      decoration: new BoxDecoration(
                          border: new Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: new Text(
                        "10000원",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    )
                )
              ],
            ),
          ],
        ));
  }

  Widget getTimeBoxUI(String text1, String text2, Icon icon1) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.28,
      height: 110,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: GameRoomTheme.nearlyWhite,
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(color: GameRoomTheme.grey.withOpacity(0.2), offset: Offset(1.1, 1.1), blurRadius: 8.0),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 12.0, bottom: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                icon1,
                Text(
                  text1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Dosis',
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    letterSpacing: 0.27,
                    color: GameRoomTheme.nearlyBlue,
                  ),
                ),
                Text(
                  text2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Dosis',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    letterSpacing: 0.27,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _changeState(String tempStr) {
    print(tempStr);
  }

  Widget _detail_tab(){
    final tempHeight = (MediaQuery.of(context).size.height - (MediaQuery.of(context).size.width / 1.2) + 24.0);
    return SingleChildScrollView(
        child: Container(
          constraints:
          BoxConstraints(minHeight: infoHeight, maxHeight: tempHeight > infoHeight ? tempHeight : infoHeight),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 32.0, left: 18, right: 16),
                child: Text(
                  "Suwon-World Cup Stadium, Suwon, Gyeonggi-do",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    letterSpacing: 0.27,
                    color: GameRoomTheme.darkerText,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "10,000 원",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: 22,
                        letterSpacing: 0.27,
                        color: GameRoomTheme.nearlyBlue,
                      ),
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Text(
                            "4.3",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w200,
                              fontSize: 22,
                              letterSpacing: 0.27,
                              color: GameRoomTheme.grey,
                            ),
                          ),
                          Icon(
                            Icons.star,
                            color: GameRoomTheme.nearlyBlue,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        getTimeBoxUI("5 vs 5", "Match", Icon(FontAwesomeIcons.peopleCarry)),
                        getTimeBoxUI("2시간", "Time", Icon(FontAwesomeIcons.clock)),
                        getTimeBoxUI("신발 대여", "Shoe", Icon(FontAwesomeIcons.shoePrints)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        getTimeBoxUI("위치", "Location", Icon(FontAwesomeIcons.mapMarkedAlt)),
                        getTimeBoxUI("초보", "Skill", Icon(FontAwesomeIcons.users)),
                        getTimeBoxUI("옷 대여", "Clothes", Icon(FontAwesomeIcons.tshirt)),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 500),
                  opacity: opacity2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                    child: Text(
                      "초보자분들 환영합니다. 풋살을 즐기시는 누구나 참가 신청 가능합니다.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontFamily: 'Dosis',
                        fontWeight: FontWeight.w200,
                        fontSize: 14,
                        letterSpacing: 0.27,
                        color: GameRoomTheme.grey,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        ));
  }
}