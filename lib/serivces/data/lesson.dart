
class WeekSchedule{
  List weeks;
  List<DaySchedule> days;
  WeekSchedule(this.weeks,this.days);
}
class DaySchedule{
  int day;
  List<LessonSchedule> lessons;
  DaySchedule(this.day,this.lessons);
  setDay(int day){
    this.day = day;

  }
  addLesson(LessonSchedule lesson){
    this.lessons.add(lesson);
  }

}
class LessonSchedule{
   String lessonType; //очно/дист
   String object;
   String objectType;
   List weeks;
   Time time;
   String teacher;
   String classRoom;
   String day;
   int group;
   LessonSchedule(
       this.lessonType, this.object,
       this.objectType,this.weeks,
       this.time, this.teacher,
       this.classRoom, this.day,this.group,
       );

}
class Lesson{
   int lessonTypeId;
   int objectId;
   int objectTypeId;
   List<int> weekIds;
   int timeId;
   int teacherId;
   int classRoomId;
   int dayId;
   int group;
  Lesson(
      this.lessonTypeId, this.objectId,
      this.objectTypeId,this.weekIds,
      this.timeId, this.teacherId,
      this.classRoomId, this.dayId,this.group,
      );
   factory Lesson.fromJson(Map<String, dynamic> data){
     final lessonTypeId = data['lessonTypeId'];
     final objectId = data['objectId'];
     final objectTypeId = data['objectTypeId'];
     final weekIds = data['weekIds'];
     final timeId = data['timeId'];
     final teacherId = data['teacherId'];
     final classRoomId = data['classRoomId'];
     final dayId = data['dayId'];
     final group = data['group'];
     return Lesson(
         lessonTypeId, objectId, objectTypeId,
         weekIds,timeId,teacherId,classRoomId,dayId,group);
   }
}
class Time {
  String description;
   String start;
   String end;
  Time(this.start, this.end, this.description);
  factory Time.fromJson(Map<String, dynamic> data){
    final description = data['description'];
    final start = data['start'];
    final end = data['end'];
    return Time(start, end, description);
  }
}
class WeekDays {
   List<int> weekIds;
   int dayId;
   int lessonId;
   WeekDays(this.weekIds, this.dayId, this.lessonId);
   factory WeekDays.fromJson(Map<String, dynamic> data){
     final dayId = data['dayId'];
     final weekIds = data['weekIds'];
     final lessonId = data['lessonId'];
     return WeekDays(weekIds,dayId, lessonId);
   }
}
var dataTimeList = [
  Time('8:00', '9:35', "1 пара"),
  Time('9:45', '11:20', "2 пара"),
  Time('11:35', '13:10', "3 пара"),
  Time('13:40', '15:15', "4 пара"),
  Time('15:25', '17:00', "5 пара"),
  Time('17:10', '18:45', "6 пара"),
  Time('7:30', '9:05', "1 пара"),
  Time('9:20', '10:55', "2 пара"),
  Time('11:10', '12:45', "3 пара"),
  Time('13:15', '14:50', "4 пара"),
  Time('15:00', '16:35', "5 пара"),
  Time('16:45', '18:20', "6 пара"),
];
var  dataWeekList = [
  "Четная",
  "Нечётная",
  1, 2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20
];
var  dataObjectList = [
  "Управление IT проектами",
  "Архитектура инфомрационных систем",
  "Математические основы защиты информации",
  "Социология",
  "Методы и средства проектирования информационных систем и технологий",
  "Базы данных",
  "Инфокомунникационные системы и сети",
  "Элективные курсы по физической культуре и спорту, спортивные площадки общежития №3"
];
var dataObjectTypeList = [
  "Лекция",
  "Практика",
  "Лабораторная работа",

];
var dataLessonTypeList = [
  "очно",
  "дистанционно",

];
var dataTeacherList = [
  "Ивлев Михаил Алексеевич",
  "Парамонов А.С.",
  "Семашко Алексей Владимирович",
  "Полозов Игорь Владимирович",
  "Моругин Станислав Львович",
  "Сухоребров Владимир Гаврилович",
  "Егоров Юрий Сергеевич",
  "Скобелева Екатерина Ивановна",
  " "
];
var dataClassRoomList = [
  "1236",
  "1337",
  "1353",
  "3301",
  "4304",
  "4307",
  "4308",
  "4311",
  "6125",
  "6126",
  "6245",
  "6246",
  "6305",
  "6307",
  "6331",
  "3 общага"
];
var dataDayList = [
  "Понедельник",
  "Вторник",
  "Среда",
  "Четверг",
  "Пятница",
  "Суббота",
  "Воскресенье"
];
var dataLessonList = [
  Lesson(0, 0,0,[0,1],1+6,0,3,0,0),
  Lesson(0, 1,2,[1],2+6,6,4,0,1),
  Lesson(0, 1,2,[1],3+6,6,4,0,1),
  Lesson(0, 2,2,[1],0+6,2,6,1,2),
  Lesson(0, 2,2,[1],1+6,2,6,1,2),
  Lesson(0, 2,0,[0,1],2+6,2,6,1,0),
  Lesson(0, 0,1,[1],3+6,0,2,1,0),
  Lesson(0, 3,1,[1],0,7,12,2,0),
  Lesson(0, 4,1,[1],1,4,14,2,0),
  Lesson(0, 5,0,[0,1],2,3,8,2,0),
  Lesson(0, 4,0,[0,1],3,4,8,2,0),
  Lesson(0, 5,2,[1],6+2,3,0,3,1),
  Lesson(0, 5,2,[1],6+3,3,0,3,1),
  Lesson(0, 4,2,[4,8,12,16],6+4,4,1,3,1),
  Lesson(0, 4,2,[4,8,12,16],6+5,4,1,3,1),
  Lesson(0, 6,2,[6,10,14,18],6+4,1,5,3,1),
  Lesson(0, 6,2,[6,10,14,18],6+5,1,5,3,1),
  Lesson(0, 7,1,[0,1],0,8,15,4,0),
  Lesson(0, 3,0,[1],2,7,9,4,0),
  Lesson(0, 6,0,[0,1],3,5,11,4,0),
  Lesson(0, 1,0,[0,1],4,6,10,4,0),
  Lesson(0, 6,1,[0],6+2,1,7,0,0),
  Lesson(0, 2,2,[0],0+6,2,6,1,1),
  Lesson(0, 2,2,[0],1+6,2,6,1,1),
  Lesson(0, 5,2,[0],6+2,3,0,3,2),
  Lesson(0, 5,2,[0],6+3,3,0,3,2),
  Lesson(0, 4,2,[3,7,11,15],6+4,4,1,3,2),
  Lesson(0, 4,2,[3,7,11,15],6+5,4,1,3,2),
  Lesson(0, 6,2,[5,9,13,17],6+4,1,5,3,2),
  Lesson(0, 6,2,[5,9,13,17],6+5,1,5,3,2),
  Lesson(0, 6,1,[0],2,1,13,4,0),
  Lesson(0, 1,2,[0],6+2,6,4,5,2),
  Lesson(0, 1,2,[0],6+3,6,4,5,2),
];
