import 'dart:convert';

import 'package:schedule/services/data/lesson2.dart';
import 'package:schedule/services/data/view_lesson.dart';
import 'package:schedule/services/data/week.dart';

import 'package:schedule/services/group.dart';
import 'package:schedule/services/time.dart';
import 'package:shared_preferences/shared_preferences.dart';
export 'data/lesson.dart';

class ScheduleService {

  static late SharedPreferences prefs;
  static late GroupService _groupService;
  static final TimeService _timeService = TimeService.instance;

  ScheduleService._();

  static ScheduleService? _instance;

  static Future<ScheduleService> get instance async {
    if (_instance == null) {
      prefs = await SharedPreferences.getInstance();
      _groupService = await GroupService.instance;
      _instance = ScheduleService._();
    }
    return _instance!;
  }
  ScheduleOfWeek getWeekSchedule(Week? week){
    List<String>? tempLessons = prefs.getStringList('ScheduleLessons');
    String group = _groupService.group;
    int subgroup = _groupService.subgroup;
    week ??= Week(number:_timeService.weekNumber);

    ScheduleOfWeek schedule = ScheduleOfWeek({});
    if(tempLessons==null) {
      List<String> groupDayLessonsStrings = [];
      for (GroupDayLesson dayLesson in groupDayLessons){
        if(dayLesson.group == group && (dayLesson.subgroup == subgroup || dayLesson.subgroup==0)){
          DayLesson lesson = dayLesson.lesson;
          if(lesson.week ==week.number.toString() || lesson.week.toLowerCase() == week.type.toLowerCase() || lesson.week.toLowerCase()=="любая"){
            schedule.addLesson(lesson);
          }
        }
        String dayLessonString = GroupDayLesson.toJson(dayLesson).toString();
        groupDayLessonsStrings.add(dayLessonString);
      }
      prefs.setStringList('ScheduleLessons', groupDayLessonsStrings);
      tempLessons = groupDayLessonsStrings;
    } else {
      for(String tempLesson in tempLessons){
        GroupDayLesson groupDayLesson = GroupDayLesson.fromJson( json.decode(tempLesson));
        if(groupDayLesson.group == group && (groupDayLesson.subgroup == subgroup || groupDayLesson.subgroup==0)){
          DayLesson dayLesson = groupDayLesson.lesson;
          if(dayLesson.week ==week.number.toString() || dayLesson.week.toLowerCase() == week.type.toLowerCase() || dayLesson.week.toLowerCase()=="любая"){
            schedule.addLesson(dayLesson);
          }
        }
      }
    }
    return schedule;
  }
  ScheduleOfWeek get weekLessons {
    return getWeekSchedule(Week(number:_timeService.weekNumber));
  }
  ScheduleOfDay get dayLessons {
    Weekday day = _timeService.weekday;
    ScheduleOfDay? schedule = weekLessons.list[_timeService.day-1];
    if(schedule!=null){
      return schedule;
    }
    else{
      return ScheduleOfDay(day, []);
    }
  }
}