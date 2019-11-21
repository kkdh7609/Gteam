import 'package:flutter/material.dart';
import 'package:gteams/manager_main/model/FacilitySchema.dart';

class Facilities {
  static List<Facility> facilities = [
    Facility(
      name: "HM풋살파크 서수원점",
      background: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [const Color(0xFF083663), const Color(0xFF82B1FF)],
      ),
      subtitle: "권선구 금곡로 236",
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
