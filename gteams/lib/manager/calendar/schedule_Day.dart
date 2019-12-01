import 'package:flutter/material.dart';

class DaySchedule extends StatefulWidget {
  final DateTime day;

  DaySchedule(
  {
    this.day,
  });

  @override
  _DayScheduleState createState() => _DayScheduleState();
}

class _DayScheduleState extends State<DaySchedule> {
  String _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.day.toString().split(" ")[0];
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text(_selectedDay, style: TextStyle(
          fontWeight: FontWeight.w600, fontSize: 22, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color(0xff20253d),
      ),
      body: Container()
    );
  }
}
