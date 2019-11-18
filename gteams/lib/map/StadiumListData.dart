import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StadiumListData {
  String imagePath;
  String stadiumName;
  String location;
  int fieldNumber;
  String telephone;
  String webSite;
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

  StadiumListData({
    this.imagePath = '',
    this.stadiumName = '',
    this.location = "",
    this.webSite = "",
    this.telephone = "",
    this.fieldNumber=1,
    this.isShower=0,
    this.isClothes=0,
    this.isParking=0,
    this.isShoes=0,
    this.isBall=0,
    this.addPrice=0,
    this.etc="",
    this.parkingHours=0,
    this.price=0,
    this.operationTime,
    this.lat = 0.0,
    this.lng = 0.0,
  });

  factory StadiumListData.fromJson(Map<dynamic, dynamic> json){
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
      isShoes: json['isShoes'],
      isBall: json['isBall'],
      addPrice: json['addPrice'],
      etc: json['etc'],
      parkingHours: json['parkingHours'],
      price: json['price'],
      operationTime: json['operationTime'], // operationTime의 각요소접근 방법 => operationTime['openTime'] .operationTime['endTime'] .
      lat: json['lat'],
      lng : json['lng'],
    );
  }

  static List<StadiumListData> stadiumList = [
  ];

}