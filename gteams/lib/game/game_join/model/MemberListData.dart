// 게임 방에 참여되어있는 인원 정보
class MemberListData {
  String name;
  String address;
  String photo;

  MemberListData({
    this.name,
    this.address,
    this.photo
  });

  factory MemberListData.fromJson(Map<String, dynamic> json){
    return MemberListData(
      name: json['name'],
      address: json['address'],
//      photo: json['photo'],
    );
  }

  static List<MemberListData> memberList = [];
}