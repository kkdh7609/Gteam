class StadiumListData {
  String imagePath;
  String stadiumName;
  String location;
  int fieldNumber;
  String telephone;
  String webSite;
  List<Map<dynamic,dynamic>> operationTime=[{"openTime":1,"endTime":1}];
  bool isShower;
  bool isParking;
  bool isClothes;
  int parkingHours;
  String etc;
  int price;
  int addPrice;


  StadiumListData({
    this.imagePath = '',
    this.stadiumName = '',
    this.location = "",
    this.webSite = "",
    this.telephone = "",
    this.fieldNumber=1,
    this.isShower=false,
    this.isClothes=false,
    this.isParking=false,
    this.addPrice=0,
    this.etc="",
    this.parkingHours=0,
    this.price=0,
    this.operationTime,
  });

  factory StadiumListData.fromJson(Map<String, dynamic> json){
    return StadiumListData(
      imagePath: json['imagePath'],
      stadiumName: json['stadiumName'],
      location: json['location'],
      telephone: json['telephone'],
      webSite: json['webSite'],
      fieldNumber: json['fieldNumber'],
      isShower: json['isShower'],
      isClothes:json['isClothes'],
      isParking:json['isParking'],
      addPrice: json['addPrice'],
      etc: json['etc'],
      parkingHours: json['parkingHours'],
      price: json['price'],
      operationTime: json['operationTime'],
    );
  }
  static List<StadiumListData> stadiumList = [
  ];

}