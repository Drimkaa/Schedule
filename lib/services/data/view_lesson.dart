import 'package:schedule/services/data/lesson2.dart';

class ScheduleOfDay{
  Weekday day;
  late int dayId;
  late String dayName;
  List<DayLesson> lessons;
  ScheduleOfDay(this.day,this.lessons) {
      setDay(day);
  }
  setDay(Weekday day){
    this.day = day;
    int id;
    String name;
    switch (day){
      case Weekday.monday:
        id=0;
        name = "Понедельник";
        break;
      case Weekday.tuesday:
        id=1;
        name = "Вторник";
        break;
      case Weekday.wednesday:
        name = "Среда";
        id=2;
        break;
      case Weekday.thursday:
        name = "Четверг";
        id=3;
        break;
      case Weekday.friday:
        name = "Пятница";
        id=4;
        break;
      case Weekday.saturday:
        name = "Суббота";
        id=5;
        break;
      case Weekday.sunday:
        name = "Воскресенье";
        id=6;
        break;
    }
    dayId = id;
    dayName = name;
  }
  addLesson(DayLesson lesson){
    lessons.add(lesson);
  }
}
class ScheduleOfWeek{
  Map<int, ScheduleOfDay> list;
  ScheduleOfWeek(this.list);
  addDay(ScheduleOfDay day){
    list[day.dayId] = day;
  }
  addLesson(DayLesson dayLesson){
    var id = 0;
    switch (dayLesson.day){
      case Weekday.monday:
        id=0;
        break;
      case Weekday.tuesday:
        id=1;
        break;
      case Weekday.wednesday:
        id=2;
        break;
      case Weekday.thursday:
        id=3;
        break;
      case Weekday.friday:
        id=4;
        break;
      case Weekday.saturday:
        id=5;
        break;
      case Weekday.sunday:
        id=6;
        break;
    }
    if(list[id]!=null){
      list[id]!.addLesson(dayLesson);
    } else{
      list[id] = ScheduleOfDay(dayLesson.day, [dayLesson]);
    }
  }
}