import 'package:cloud_firestore/cloud_firestore.dart';

class GameListData {
//  String imagePath;
  String gameName;
  String selectedSport;
  int gameLevel;
  int groupSize;
  String dateText;
  String startTime;
  String endTime;
  String loc_name;
  int perPrice;
  int totalPrice;
  int dateNumber;
  List<dynamic> userList;
  DocumentReference stadiumRef;
  Timestamp sort;

  GameListData({
//    this.imagePath = '',
    this.gameName = '',
    this.selectedSport = "",
    this.startTime = "",
    this.dateText = "",
    this.endTime = "",
    this.loc_name = "",
    this.totalPrice=0,
    this.perPrice=0,
    this.gameLevel=1,
    this.groupSize=1,
    this.dateNumber=1,
    this.userList,
    this.stadiumRef,
    this.sort,
  });

  factory GameListData.fromJson(Map<String, dynamic> json) {
    return GameListData(
//      imagePath: json['imagePath'],
      gameName: json['gameName'],
      selectedSport: json['selectedSport'],
      dateText: json['dateText'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      loc_name: json['loc_name'],
      gameLevel:json['gameLevel'],
      groupSize:json['groupSize'],
      dateNumber: json['dateNumber'],
      userList: json['userList'],
      stadiumRef: json['stadiumRef'],
      totalPrice: json['totalPrice'],
      perPrice: json['perPrice'],
      sort:json['sort'],
    );
  }

  static List<GameListData> gameList = [];
}
