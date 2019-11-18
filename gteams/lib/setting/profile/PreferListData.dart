class PreferListData {
  List<String> dayText = List<String>();
  String time_start;
  String time_end;

  PreferListData({
    this.dayText,
    this.time_start = "",
    this.time_end = ""
  });

  factory PreferListData.fromJson(Map<String, dynamic> json){
    return PreferListData(
//      dayText: ,
      time_start: json['timeStart'],
      time_end: json['timeEnd'],
    );
  }

  static List<PreferListData> preferList = [
    PreferListData(
        dayText: ['월', '화'],
        time_start: '12:00',
        time_end: '13:00'
    ),
    PreferListData(
        dayText: ['화'],
        time_start: '12:00',
        time_end: '13:00'
    ),
    PreferListData(
        dayText: ['수'],
        time_start: '12:00',
        time_end: '13:00'
    ),
    PreferListData(
        dayText: ['목'],
        time_start: '12:00',
        time_end: '13:00'
    ),
    PreferListData(
        dayText: ['금'],
        time_start: '12:00',
        time_end: '13:00'
    ),
    PreferListData(
        dayText: ['토'],
        time_start: '12:00',
        time_end: '13:00'
    ),
  ];
}