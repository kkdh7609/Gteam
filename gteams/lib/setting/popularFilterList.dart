class SettingListData {
  String titleTxt;
  bool isSelected;

  SettingListData({
    this.titleTxt = '',
    this.isSelected = false,
  });

  static List<SettingListData> sportList = [
    SettingListData(
      titleTxt: 'Futsal',
      isSelected: false,
    ),
    SettingListData(
      titleTxt: 'Table Tennis',
      isSelected: false,
    ),
    SettingListData(
      titleTxt: 'Bowling',
      isSelected: true,
    ),
    SettingListData(
      titleTxt: 'Basketball',
      isSelected: false,
    ),
    SettingListData(
      titleTxt: 'Baseball',
      isSelected: false,
    ),
  ];

  static List<SettingListData> dayList = [
    SettingListData(
      titleTxt: '월',
      isSelected: false,
    ),
    SettingListData(
      titleTxt: '화',
      isSelected: false,
    ),
    SettingListData(
      titleTxt: '수',
      isSelected: false,
    ),
    SettingListData(
      titleTxt: '목',
      isSelected: false,
    ),
    SettingListData(
      titleTxt: '금',
      isSelected: false,
    ),
    SettingListData(
      titleTxt: '토',
      isSelected: false,
    ),
    SettingListData(
      titleTxt: '일',
      isSelected: false,
    ),
  ];
}
