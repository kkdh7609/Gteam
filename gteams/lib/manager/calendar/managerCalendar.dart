import 'package:flutter/material.dart';
import 'package:gteams/manager/calendar/calendarView.dart';

class CalendarViewApp extends StatefulWidget {
  @override
  _CalendarViewAppState createState() => _CalendarViewAppState();
}

class _CalendarViewAppState extends State<CalendarViewApp> {
  DateTime _selectedDay;

  Widget calendar() {
    return Calendar(
      onDateSelected: (day) {
        _selectedDay = day;
        print(day);
      },
      onSelectedRangeChange: (range) =>
          print("Range is ${range.item1}, ${range.item2}"),
      isExpandable: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
            title: Text("시설 관리자 예약 관리",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    color: Colors.white)),
            centerTitle: true,
            backgroundColor: Color(0xff20253d)),
        body: Column(
          children: <Widget>[
            Expanded(
                flex: 3,
                child: GridView.builder(
                    scrollDirection: Axis.vertical,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 2),
                    ),
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return calendar();
                    })),
            Expanded(flex: 1, child: Divider(height: 10, color: Colors.black)),
            Expanded(
              flex: 7,
              child: ListView.builder(
                  itemExtent: 48,
                  itemCount: 48,
                  itemBuilder: (context, index) {
                    return Row(children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: Center(
                              child: Text(
                                  "${(index ~/ 2)}:${((index % 2) == 0) ? '00' : '30'}",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500)))),
                      Expanded(
                          flex: 7,
                          child:
                              Container(child: Center(child: Text("$index"))))
                    ]);
                  }),
            )
          ],
        ));
  }
}
