// 게임 방에 참여되어있는 인원 정보
class MemberListData {
  String name;
  String address;
  String imagePath;

  MemberListData({
    this.name,
    this.address,
    this.imagePath
  });

  factory MemberListData.fromJson(Map<String, dynamic> json){
    return MemberListData(
      name: json['name'],
      address: json['address'],
      imagePath: json['imagePath'],
    );
  }

  static List<MemberListData> memberList = [];
}