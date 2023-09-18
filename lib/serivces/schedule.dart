import 'dart:convert';

import 'package:schedule/serivces/data/lesson.dart';
import 'package:schedule/serivces/group.dart';
import 'package:schedule/serivces/time.dart';
import 'package:shared_preferences/shared_preferences.dart';
export 'data/lesson.dart';

class ScheduleService {
  ScheduleService._();
  static late SharedPreferences prefs;
  static ScheduleService? _instance;

  static Future<ScheduleService> get instance async {
    if (_instance == null) {
      prefs = await SharedPreferences.getInstance();
      _instance = ScheduleService._();
    }
    return _instance!;
  }
  DateTime currentDay = DateTime.now();
  get semester {
    int currentMonth = currentDay.month;
    return currentMonth>=8 && currentMonth < 2?
      1:
      2;


  }
   get weekNumber {
    if(semester == 2){
      return ((currentDay.difference(DateTime(currentDay.year, 9, 0, 0, 0)).inDays+ DateTime(currentDay.year, 9, 0, 0, 0).weekday) / 7) .ceil();
    }
    else{
      return ((currentDay.difference(DateTime(currentDay.year, 2, 0, 0, 0)).inDays+ DateTime(currentDay.year, 2, 0, 0, 0).weekday) / 7) .ceil();
    }

  }
  lessonScheduleFromLesson(Lesson lesson){
    var temp = lesson.weekIds;
    var weeks = [];
    temp.forEach((element) {weeks.add(dataWeekList[element]); });

    return LessonSchedule(
        dataLessonTypeList[lesson.lessonTypeId],
        dataObjectList[lesson.objectId],
        dataObjectTypeList[lesson.objectTypeId],

        weeks,
        dataTimeList[lesson.timeId],
        dataTeacherList[lesson.teacherId],
        dataClassRoomList[lesson.classRoomId],
        dataDayList[lesson.dayId],
        lesson.group

    );
  }
  get weekType {
    if(weekNumber%2 == 0){
    return dataWeekList[0];
    }
    else{
      return  dataWeekList[1];
    }
  }
  weekTypeByNumber(int num){
    if(num%2 == 0){
      return dataWeekList[0];
    }
    else{
      return  dataWeekList[1];
    }
  }
  get weekTempType {
    return weekNumber%2;
  }
  get time {
    return dataTimeList;
  }
  get teacher{
    return prefs.getStringList('scheduleTeachers')?? [];
  }
  get classRoom{
    return prefs.getStringList('scheduleClassRooms')?? [];
  }
  get object {
    return prefs.getStringList('scheduleObjects') ?? [];
  }
  localSchedule(int week) async{
    var tempWeekNumber = week;
    var tempWeekType = tempWeekNumber % 2;

    GroupService groupService = await GroupService.instance;

    var tempLessons = dataLessonList;
    List<DaySchedule> days = [
      DaySchedule(0, []),
      DaySchedule(1, []),
      DaySchedule(2, []),
      DaySchedule(3, []),
      DaySchedule(4, []),
      DaySchedule(5, []),
      DaySchedule(6, []),
    ];
    var group = groupService.group;
    for(final lesson in tempLessons){

      LessonSchedule scheduleLesson = lessonScheduleFromLesson(lesson);
      if(
      (scheduleLesson.weeks.contains(tempWeekNumber) ||
          lesson.weekIds.contains(tempWeekType))
          && (lesson.group == group || lesson.group == 0)
          ){
        if(!days[lesson.dayId].lessons.contains(scheduleLesson)) {
          days[lesson.dayId].lessons.add(scheduleLesson);

        }
      }
    }
    return WeekSchedule([tempWeekType,tempWeekNumber+2], days);
  }
  Future<DaySchedule> localThisDaySchedule() async {
    var tempWeekType = weekTempType;
    var tempWeekNumber = weekNumber;
    GroupService groupService = await GroupService.instance;
    TimeService timeService =  TimeService.instance;
    var currentDay = timeService.day - 1;
    var thisDaySchedule =  DaySchedule(currentDay, []);
    var group = groupService.group;
    var tempLessons = dataLessonList;
    for(final lesson in tempLessons){
      LessonSchedule scheduleLesson = lessonScheduleFromLesson(lesson);
      if((scheduleLesson.weeks.contains(tempWeekNumber) ||
         lesson.weekIds.contains(tempWeekType))
         && (lesson.group == group || lesson.group == 0)){
        if(!thisDaySchedule.lessons.contains(scheduleLesson) &&
            lesson.dayId == thisDaySchedule.day) {
          thisDaySchedule.lessons.add(scheduleLesson);

        }
      }
    }
    return thisDaySchedule;
  }
  get schedule {
    var tempLessons = prefs.getStringList('scheduleLessons')?? [];

    var tempWeekDays = prefs.getStringList('scheduleWeekDays')?? [];
    var tempWeekType = weekType;
    var tempWeekNumber = weekNumber;
    List<DaySchedule> days = [];
    for(final dayOfWeek in tempWeekDays){
      var temp =  WeekDays.fromJson(jsonDecode(dayOfWeek));
      if(temp.weekIds.isNotEmpty){
        if( temp.weekIds.contains(tempWeekType) ||
            temp.weekIds.contains(dataWeekList[tempWeekNumber+2])){
          bool containsDay = false;
          var tempLesson =  Lesson.fromJson(jsonDecode(tempLessons[temp.lessonId]));
          for (var element in days) {
            if(element.day==temp.dayId){
              containsDay = true;


              element.lessons.add(
    lessonScheduleFromLesson(tempLesson));
            }
          }
          if(containsDay == false){
            DaySchedule temp2 = DaySchedule(temp.dayId,[lessonScheduleFromLesson(tempLesson)]);

            days.add(temp2);
          }
        }
      }
    }
    return WeekSchedule([tempWeekType,tempWeekNumber+2], days);
  }

  save(String newThemeName) {
    var currentThemeName = prefs.getString('theme');
    if (currentThemeName != null) {
      prefs.setString('previousThemeName', currentThemeName);
    }
    prefs.setString('theme', newThemeName);
  }

}