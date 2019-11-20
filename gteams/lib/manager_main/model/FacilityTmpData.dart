import 'package:flutter/material.dart';
import 'package:gteams/manager_main/model/FacilitySchema.dart';

class Facilities {
  static List<Facility> facilities = [
    Facility(
      name: "에스빌드 풋살장",
      background: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [const Color(0xFF083663), const Color(0xFF82B1FF)],
      ),
      subtitle: "팔달구 월드컵로 310",
      image: "assets/image/menu/soccerball.svg",
      lastindex: false,
    ),
    Facility(
      name: "Plus",
      background: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [const Color(0xFF083663), const Color(0xFF82B1FF)],
      ),
      subtitle: null,
      image: "assets/image/manager/plus.svg",
      lastindex: true,
    ),
  ];
}
