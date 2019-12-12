import 'package:flutter_test/flutter_test.dart';
import 'package:gteams/util/timeUtil.dart';
import 'package:tuple/tuple.dart';

void main(){
  test("배열에서 0번째 INDEX가 의미하는 시간은 0:00분이다.", (){
    int now = 0;

    expect(oneTimeConverter(now), "0:00");
  });
  test("배열에서 47번째 INDEX가 의미하는 시간은 23:30분이다.", (){
    int now = 47;

    expect(oneTimeConverter(now), "23:30");
  });
  test("첫번째 블록은 23:30~24:00 블록이다", (){
    int now = 1 << 0;
    expect(intTimeToStr(now), [Tuple2<String, String>("23:30", "24:00")]);
  });
  test("마지막 블록(48번째)는 0:00~0:30 블록이다.", (){
    int now = 1 << 47;
    expect(intTimeToStr(now), [Tuple2<String, String>("0:00", "0:30")]);
  });
  test("첫번째 블록과 마지막 블록을 더하면 시간은 0:00~30, 23:30~24:00을 가르킨다.", (){
    int now = (1 << 0) + (1 << 47);
    expect(intTimeToStr(now), [Tuple2<String, String>("23:30", "24:00"), Tuple2<String, String>("0:00", "0:30")]);
  });
  test("연속되지 않은 시간 블럭이 있는 경우, String에서는 , 마크를 통해서 구분한다.", (){
    List<Tuple2<String, String>> now = [Tuple2<String, String>("23:30", "24:00"), Tuple2<String, String>("0:00", "0:30")];
    expect(listTimeConverter(now), "0:00~0:30, 23:30~24:00");
  });
}
