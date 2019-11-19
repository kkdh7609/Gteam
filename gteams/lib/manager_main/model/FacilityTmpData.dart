import 'package:flutter/material.dart';
import 'package:gteams/menu/model/aliment.dart';

class Facilities {
  static List<Aliment> facilities = [
    Aliment(
      name: "Futsal",
      background: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [const Color(0xFF083663), const Color(0xFF6CD8F0)],
      ),
      subtitle: "Make Your Futsal Team",
      image: "assets/image/menu/soccerball.svg",
    ),
    Aliment(
      name: "Table Tennis",
      background: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [const Color(0xFFF8C08E), const Color(0xFFFDA65B)],
      ),
      subtitle: "Make Your Table Tennis Team",
      image: "assets/image/menu/pingpong.svg",
    ),
    Aliment(
      name: "Bowling",
      background: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [const Color(0xFF6CD8F0), const Color(0xFF6AD89D)],
      ),
      subtitle: "Make Your Bowling Team",
      image: "assets/image/menu/bowling.svg",
    ),
    Aliment(
      name: "Basketball",
      background: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [const Color(0xFFEE0979), const Color(0xFFFF6A00)],
      ),
      subtitle: "Make Your Basketball Team",
      image: "assets/image/menu/basketball.svg",
    ),
    Aliment(
      name: "Baseball",
      background: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [const Color(0xFFBB377D), const Color(0xFFFBD3E9)],
      ),
      subtitle: "Make Your Baseball Team",
      image: "assets/image/menu/baseball.svg",
    ),
  ];
}
