import 'package:cloud_firestore/cloud_firestore.dart';

///정렬을 위한 스트림 List
/// streamList[0] => 기본 정렬  : 가장 옛날에 생성된 게임이 맨위에 오게
/// streamList[1] => 가격순     : 가격이 낮은것 부터
/// streamList[2] => 가격순     : 가격이 높은것 부터
/// streamList[3] => 참여율순   : 참여율 낮은순 부터
/// streamList[4] => 참여율순   : 참여율 높은순 부터
/// streamList[5] => 가격참여율 : 가격 낮고 참여율 낮은순 부터
/// streamList[6] => 가격참여율 : 가격 낮고 참여율 높은순 부터
/// streamList[7] => 가격참여율 : 가격 높고 참여율 낮은순 부터
/// streamList[8] => 가격참여율 : 가격 높고 참여율 높은순 부터

class StreamList {

  static Query streamQuery(Query basic,int selectStream){
    switch(selectStream){
      case 0:
        return basic.orderBy('sort',descending: false);
        break;
      case 1:
        return basic.orderBy('perPrice',descending: false);
        break;
      case 2:
        return basic.orderBy('perPrice',descending: true);
        break;
      case 3:
        return basic.orderBy('chamyeyul',descending: false);
        break;
      case 4:
        return basic.orderBy('chamyeyul',descending: true);
        break;
      case 5:
        return basic.orderBy('perPrice',descending: false).orderBy('chamyeyul',descending: false);
        break;
      case 6:
        return basic.orderBy('perPrice',descending: false).orderBy('chamyeyul',descending: true);
        break;
      case 7:
        return basic.orderBy('perPrice',descending: true).orderBy('chamyeyul',descending: false);
        break;
      default:
        return basic.orderBy('perPrice',descending: true).orderBy('chamyeyul',descending: true);
        break;
    }
  }

  /*
  static List<Query> streamList=[
    basic.orderBy('sort',descending: false),
    Firestore.instance.collection('game3').where('dateNumber',isGreaterThanOrEqualTo: startDate.millisecondsSinceEpoch,isLessThanOrEqualTo: endDate.millisecondsSinceEpoch),
    Firestore.instance.collection('game3').where('reserve_status',isEqualTo: 0).orderBy('sort',descending: false),
    Firestore.instance.collection('game3').orderBy('perPrice',descending: false).where('reserve_status',isEqualTo: 0),
    Firestore.instance.collection('game3').orderBy('perPrice',descending: true).where('reserve_status',isEqualTo: 0),
    Firestore.instance.collection('game3').orderBy('chamyeyul',descending: false).where('reserve_status',isEqualTo: 0),
    Firestore.instance.collection('game3').orderBy('chamyeyul',descending: true).where('reserve_status',isEqualTo: 0),
    Firestore.instance.collection('game3').orderBy('perPrice',descending: false).orderBy('chamyeyul',descending: false).where('reserve_status',isEqualTo: 0),
    Firestore.instance.collection('game3').orderBy('perPrice',descending: false).orderBy('chamyeyul',descending: true).where('reserve_status',isEqualTo: 0),
    Firestore.instance.collection('game3').orderBy('perPrice',descending: true).orderBy('chamyeyul',descending: false).where('reserve_status',isEqualTo: 0),
    Firestore.instance.collection('game3').orderBy('perPrice',descending: true).orderBy('chamyeyul',descending: true).where('reserve_status',isEqualTo: 0),
  ];
   */
}
