class SettingListData {
  String titleTxt;
  bool isSelected;

  SettingListData({
    this.titleTxt = '',
    this.isSelected = false,
  });

  static List<SettingListData> sportList = [
    SettingListData(
      titleTxt: '축구',
      isSelected: false,
    ),
    SettingListData(
      titleTxt: '풋살',
      isSelected: false,
    ),
    SettingListData(
      titleTxt: '탁구',
      isSelected: true,
    ),
    SettingListData(
      titleTxt: '볼링',
      isSelected: false,
    ),
    SettingListData(
      titleTxt: '테니스',
      isSelected: false,
    ),
  ];
/* unused..
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
 */
}
