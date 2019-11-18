class UserData {
  String name;
  String email;
  String gender;
  String preferenceLoc;
  List<dynamic> preferenceSports;

  UserData({
    this.name = "",
    this.email = "",
    this.gender = "",
    this.preferenceLoc = "",
    this.preferenceSports,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'],
      email: json['email'],
      gender: json['gender'],
      preferenceLoc: json['prferenceLoc'],
      preferenceSports: json['sportList'],

    );
  }

  static List<UserData> UserInfo = [];
}

class PreferListData {
  String startTime;
  String endTime;
  List<dynamic> dayList;

  PreferListData({
    this.startTime = "",
    this.endTime = "",
    this.dayList,
  });

  factory PreferListData.fromJson(Map<String, dynamic> json){
    return PreferListData(
      dayList: json['dayList'],
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }

  static List<PreferListData> preferList = [];
}
