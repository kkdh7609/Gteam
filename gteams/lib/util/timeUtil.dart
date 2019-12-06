import 'package:tuple/tuple.dart';

List<Tuple2<String, String>> intTimeToStr(intTime){
  bool isStarted = false;
  int tempTime = intTime;
  List<Tuple2<String, String>> result = [];

  String startTime;
  String endTime;
  for(int cnt=47; cnt > -1; cnt--){
    if(cnt == 0 && (tempTime & 1 == 1)){
      if(isStarted){
        startTime = oneTimeConverter(cnt);
        result.add(Tuple2<String, String>(startTime, endTime));
      }
      else{
        endTime = oneTimeConverter(cnt+1);
        startTime = oneTimeConverter(cnt);
        result.add(Tuple2<String, String>(startTime, endTime));
      }
      break;
    }

    if((tempTime & 1 == 0) && isStarted){
      isStarted = false;
      startTime = oneTimeConverter(cnt+1);
      result.add(Tuple2<String, String>(startTime, endTime));
    }
    else if((tempTime & 1 == 1) && !isStarted){
      isStarted = true;
      endTime = oneTimeConverter(cnt+1);
    }
    tempTime = tempTime >> 1;
  }
  return result;
}

String oneTimeConverter(oneTime){
  String hour = (oneTime ~/ 2).toString();
  String min;
  if(oneTime % 2 == 0){
    min = "00";
  }
  else{
    min = "30";
  }
  return hour + ":" + min;
}

String listTimeConverter(times){
  var result = times.reversed.toList();
  String strTime = "";
  if(result.length == 0)   strTime = "휴무";
  else{
    for(int cnt=0; cnt<result.length; cnt++){
      strTime += result[cnt].item1 + "~" + result[cnt].item2;
      if(cnt != result.length - 1)   strTime += ", ";
    }
  }
  return strTime;
}

String listTimeToStr(strTimes){
  List<String> days = ["월", "화", "수", "목", "금", "토", "일"];
  String result = "";
  for(int i = 0; i < days.length; i++){
    result += (days[i] + ": " + strTimes[i]);
    if(i != days.length - 1){
      result += "\n";
    }
  }
  return result;
}

int partTimeToTotalTime(int startHour, int startMin, int endHour, int endMin){
  int startTime = (startHour * 2) + (startMin ~/ 30);
  int endTime = (endHour * 2) + (endMin ~/ 30);

  int totalTime = 0;

  for(int cnt = startTime; cnt < endTime; cnt++){
    totalTime = totalTime << 1;
    totalTime = totalTime + 1;
  }

  totalTime = totalTime << (48 - endTime);

  return totalTime;
}

List<int> totalTimeToOrder(int totalTime){
  List<int> resultIndex = [];
  int tempTotalTime = totalTime;
  for(int i = 47; i >= 0; i--){
    if(tempTotalTime & 1 == 1){
      resultIndex.add(i);
    }
    tempTotalTime = tempTotalTime >> 1;
  }
  return resultIndex;
}
