import 'package:gteams/menu/model/aliment.dart';
import 'package:flutter/material.dart';

class Aliments {
  static List<Aliment> aliments = [
    Aliment(
        name: "Football",
        background: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          //0xFFFD8183 // 0xFFFB425A 0xFF083663
          colors: [const Color(0xFF083663), const Color(0xFF6CD8F0)],
        ),
        subtitle: "Make Your Football Team",
        image: "assets/image/menu/soccerball.svg",
        bottomImage: "assets/image/menu/bottom_soccerball.svg",
        totalCalories: 420.0,
        runTime: 47.0,
        bikeTime: 45.0,
        swimTime: 41.0,
        workoutTime: 52.0),
    Aliment(
        name: "Table Tennis",
        background: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [const Color(0xFFF8C08E), const Color(0xFFFDA65B)],
        ),
        subtitle: "Make Your Table Tennis Team",
        image: "assets/image/menu/pingpong.svg",
        bottomImage: "assets/image/menu/bottom_TT.svg",
        totalCalories: 560.0,
        runTime: 112.0,
        bikeTime: 69.0,
        swimTime: 61.0,
        workoutTime: 101.0),
    Aliment(
        name: "Bowling",
        background: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [const Color(0xFF6CD8F0), const Color(0xFF6AD89D)],
        ),
        subtitle: "Make Your Bowling Team",
        image: "assets/image/menu/bowling.svg",
        bottomImage: "assets/image/menu/bottom_bowling.svg",
        totalCalories: 210.0,
        runTime: 36.0,
        bikeTime: 31.0,
        swimTime: 25.0,
        workoutTime: 41.0),
    Aliment(
        name: "Basketball",
        background: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [const Color(0xFFEE0979), const Color(0xFFFF6A00)],
        ),
        subtitle: "Make Your Basketball Team",
        image: "assets/image/menu/basketball.svg",
        bottomImage: "assets/image/menu/bottom_basketball.svg",
        totalCalories: 238.0,
        runTime: 40.0,
        bikeTime: 35.0,
        swimTime: 30.0,
        workoutTime: 50.0),
    Aliment(
        name: "Baseball",
        background: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [const Color(0xFFFBD3E9), const Color(0xFFBB377D)],
        ),
        subtitle: "Make Your Baseball Team",
        image: "assets/image/menu/baseball.svg",
        bottomImage: "assets/image/menu/bottom_baseball.svg",
        totalCalories: 195.0,
        runTime: 33.0,
        bikeTime: 29.0,
        swimTime: 24.0,
        workoutTime: 39.0),
  ];
}