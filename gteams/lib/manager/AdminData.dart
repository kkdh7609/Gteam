class AdminData {
  String name;
  String email;
  List<dynamic> myStadium;

  AdminData({
    this.name = "",
    this.email = "",
    this.myStadium,
  });

  factory AdminData.fromJson(Map<String, dynamic> json) {
    return AdminData(
      name: json['name'],
      email: json['email'],
      myStadium: json['myStadium'],
    );
  }

  static List<AdminData> AdminInfo = [];
}