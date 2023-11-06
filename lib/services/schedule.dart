import 'dart:convert';

import 'package:schedule/services/data/lesson.dart';
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

  get time {
    return dataTimeList;
  }

  localSchedule(Week currentWeek) async{

    int group = _groupService.subgroup;

    List<DaySchedule> days = [];
    for(int i = 0; i < 7;i++){
      days.add(DaySchedule(i, []));
    }
    var tempLessons = dataLessonList;
    for(final lesson in tempLessons){
      LessonSchedule lessonSchedule = LessonSchedule.fromLesson(lesson);
      if((lessonSchedule.weeks.contains(currentWeek.number) || lesson.weekIds.contains(currentWeek.typeId))
          && (lesson.group == group || lesson.group == 0)){
        if(!days[lesson.dayId].lessons.contains(lessonSchedule)) {
          days[lesson.dayId].lessons.add(lessonSchedule);
        }
      }
    }
    return WeekSchedule([currentWeek.typeId,currentWeek.number+2], days);
  }
  Future<DaySchedule> localThisDaySchedule() async {
    Week currentWeek = _timeService.week;
    int group = _groupService.subgroup;
    int currentDay = _timeService.day - 1;

    var thisDaySchedule =  DaySchedule(currentDay, []);

    var tempLessons = dataLessonList;
    for(final lesson in tempLessons){
      LessonSchedule lessonSchedule = LessonSchedule.fromLesson(lesson);
      if((lessonSchedule.weeks.contains(currentWeek.number) || lesson.weekIds.contains(currentWeek.typeId))
         && (lesson.group == group || lesson.group == 0)){
        if(!thisDaySchedule.lessons.contains(lessonSchedule) &&
            lesson.dayId == currentDay) {
          thisDaySchedule.lessons.add(lessonSchedule);
        }
      }
    }
    return thisDaySchedule;
  }


}