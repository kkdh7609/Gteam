class UserData {
  String name;
  String gender;
  String preferenceLoc;
  List<dynamic> preferenceSports;

  UserData({
    this.name = "",
    this.gender = "",
    this.preferenceLoc = "",
    this.preferenceSports,

  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
        name: json['name'],
        gender: json['gender'],
        preferenceLoc: json['preferenceLoc'],
        preferenceSports: json['sportList']
    );
  }

  static List<UserData> UserInfo = [];
}