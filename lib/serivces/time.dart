class TimeService {
  TimeService._();

  static TimeService? _instance;

  static TimeService get instance  {
    _instance ??= TimeService._();

    return _instance!;
  }
  get day {
    return DateTime.now().weekday;
  }
  get currentWeek {
    return weekNumber;
  }
  get semester {
    int currentMonth = DateTime.now().month;
    return currentMonth>=8 && currentMonth < 2?
    1:
    2;


  }
  get weekNumber {
    if(semester == 2){
      return ((DateTime.now().difference(DateTime(DateTime.now().year, 9, 0, 0, 0)).inDays+ DateTime(DateTime.now().year, 9, 0, 0, 0).weekday) / 7) .ceil();
    }
    else{
      return ((DateTime.now().difference(DateTime(DateTime.now().year, 2, 0, 0, 0)).inDays+ DateTime(DateTime.now().year, 2, 0, 0, 0).weekday) / 7) .ceil();
    }

  }
  get hours{
    return DateTime.now().hour;
  }
  get minutes{
    return DateTime.now().minute;
  }
  get seconds{
    return DateTime.now().second;
  }
  get currentDayTime{
    return hours * 3600 + minutes * 60 + seconds;
  }
}