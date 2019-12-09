import 'package:google_maps_flutter/google_maps_flutter.dart';

class StadiumListData {
  String imagePath;
  String stadiumName;
  String stadiumDescription;
  String location;
  int fieldNumber;
  double rating;
  int rater;
  String telephone;
  String webSite;
  List<dynamic> intTimes;
  List<dynamic> operationTime;
  int isShower;
  int isParking;
  int isClothes;
  int isShoes;
  int isBall;
  int parkingHours;
  String etc;
  int price;
  int addPrice;
  double lat;
  double lng;
  LatLng locationCoords;
  String id;
  String stdId;

  StadiumListData({
    this.imagePath = '',
    this.stadiumName = '',
    this.stadiumDescription = '',
    this.location = "",
    this.webSite = "",
    this.telephone = "",
    this.fieldNumber=1,
    this.rating = 0.0,
    this.rater = 0,
    this.isShower=0,
    this.isClothes=0,
    this.isParking=0,
    this.isShoes=0,
    this.isBall=0,
    this.addPrice=0,
    this.etc="",
    this.parkingHours=0,
    this.price=0,
    this.intTimes,
    this.operationTime,
    this.lat = 0.0,
    this.lng = 0.0,
    this.id ="",
    this.stdId = "",
  });

  factory StadiumListData.fromJson(Map<dynamic, dynamic> json){
    return StadiumListData(
      imagePath: json['imagePath'],
      stadiumName: json['stadiumName'],
      stadiumDescription: json['stadiumDescription'],
      location: json['location'],
      telephone: json['telephone'],
      webSite: json['webSite'],
      fieldNumber: json['fieldNumber'],
      rating: json['rating'] is int ? json['rating'].toDouble() : json['rating'],
      rater: json['rater'],
      isShower: json['isShower'],
      isClothes:json['isClothes'],
      isParking:json['isParking'],
      isShoes: json['isShoes'],
      isBall: json['isBall'],
      addPrice: json['addPrice'],
      etc: json['etc'],
      parkingHours: json['parkingHours'],
      price: json['price'],
      intTimes: json['intTimes'],
      operationTime: json['strTimes'],
      lat: json['lat'],
      lng : json['lng'],
      id: json['id'],
      stdId: json['stdId'],
    );
  }

  static List<StadiumListData> stadiumList = [
  ];

}