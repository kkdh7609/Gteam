class GameListData {
  String imagePath;
  String gameName;
  String selectedSport;
  int gameLevel;
  int groupSize;
  String dateText;
  String startTime;
  String endTime;
  String loc_name;

  GameListData({
    this.imagePath = '',
    this.gameName = '',
    this.selectedSport = "",
    this.startTime = "",
    this.dateText = "",
    this.endTime = "",
    this.loc_name = "",
    this.gameLevel=1,
    this.groupSize=1,
  });

  factory GameListData.fromJson(Map<String, dynamic> json){
    return GameListData(
      imagePath: json['imagePath'],
      gameName: json['gameName'],
      selectedSport: json['selectedSport'],
      dateText: json['dateText'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      loc_name: json['loc_name'],
      gameLevel:json['gameLevel'],
      groupSize:json['groupSize'],
    );
  }
  static List<GameListData> gameList = [
  ];

}