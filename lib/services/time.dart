

import 'package:schedule/services/data/week.dart';

import 'data/lesson2.dart';

class TimeService {
  TimeService._();
  static TimeService? _instance;
  static TimeService get instance  {
    _instance ??= TimeService._();
    return _instance!;
  }

  get currentTime {
    return DateTime.now().add( Duration(hours: 3));
  }

   get day {

    return currentTime.weekday;
  }
  Weekday get weekday {
    var temp = day;
    switch (temp){
      case 1:
        return Weekday.monday;
      case 2:
        return Weekday.tuesday;
      case 3:
        return Weekday.wednesday;
      case 4:
        return Weekday.thursday;
      case 5:
        return Weekday.friday;
      case 6:
        return Weekday.saturday;
      case 7:
        return Weekday.sunday;
    }
    return Weekday.monday;
  }
  get currentWeek {
    return weekNumber;
  }
  get semester {
    int currentMonth = currentTime.month;
    return currentMonth>=8 && currentMonth < 2 ? 1 : 2;
  }
  get weekNumber {
    int month = semester==2 ? 9 : 2;
    return ((currentTime.difference(DateTime(currentTime.year, month, 0, 0, 0)).inDays+ DateTime(currentTime.year, month, 0, 0, 0).weekday) / 7) .ceil();
  }
  Week get week {
      return Week(number: weekNumber);
  }
  Week weekByNumber(int number){
    return Week(number: number);
  }
  get hours{
    return currentTime.hour;
  }
  get minutes{
    return currentTime.minute;
  }
  get seconds{
    return currentTime.second;
  }
  get currentDayTime{
    return hours * 3600 + minutes * 60 + seconds;
  }
  int get  timestamp {
    return currentTime.millisecondsSinceEpoch;
  }
}