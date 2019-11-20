import 'package:flutter/material.dart';
import 'package:gteams/manager_main/model/FacilitySchema.dart';

class Facilities {
  static List<Facility> facilities = [
    Facility(
      name: "WooIl Games",
      background: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [const Color(0xFF083663), const Color(0xFF82B1FF)],
      ),
      subtitle: "수원시 월드컵로 8",
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
