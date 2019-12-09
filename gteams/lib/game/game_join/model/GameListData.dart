import 'package:cloud_firestore/cloud_firestore.dart';

class GameListData {
//  String imagePath;
  String Description;
  String gameName;
  String creator;
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
  String stadiumId;
  Timestamp sort;
  int reserve_status;
  double chamyeyul;

  GameListData({
//    this.imagePath = '',
    this.gameName = '',
    this.creator = '',
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
    this.stadiumId,
    this.sort,
    this.reserve_status,
    this.Description = "",
    this.chamyeyul = 0.0
  });

  factory GameListData.fromJson(Map<String, dynamic> json) {
    return GameListData(
//      imagePath: json['imagePath'],
      gameName: json['gameName'],
      creator: json['creator'],
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
      stadiumId: json['stadiumId'],
      totalPrice: json['totalPrice'],
      perPrice: json['perPrice'],
      sort:json['sort'],
      reserve_status: json['reserve_status'],
      Description: json['Description'],
      chamyeyul: json['chamyeyul'] is int ? json['chamyeyul'].toDouble() : json['chamyeyul'],
    );
  }

  static List<GameListData> gameList = [];
}
