var subjects = [
  "Управление IT проектами",                                                            // 0
  "Архитектура инфомрационных систем",                                                  // 1
  "Математические основы защиты информации",                                            // 2
  "Социология",                                                                         // 3
  "Методы и средства проектирования информационных систем и технологий",                // 4
  "Базы данных",                                                                        // 5
  "Инфокомунникационные системы и сети",                                                // 6
  "Элективные курсы по физической культуре и спорту, спортивные площадки общежития №3", // 7
];
enum SubjectType {
  lesson,
  practice,
  lab,
}
var teachers = [
  "Ивлев Михаил Алексеевич",        // 0
  "Парамонов А.С.",                 // 1
  "Семашко Алексей Владимирович",   // 2
  "Полозов Игорь Владимирович",     // 3
  "Моругин Станислав Львович",      // 4
  "Сухоребров Владимир Гаврилович", // 5
  "Егоров Юрий Сергеевич",          // 6
  "Скобелева Екатерина Ивановна",   // 7
  "Короленко Андрей Григорьевич "   // 8
];
var classrooms = [
  "1236",    // 0
  "1337",    // 1
  "1353",    // 2
  "3301",    // 3
  "4304",    // 4
  "4307",    // 5
  "4308",    // 6
  "4311",    // 7
  "6125",    // 8
  "6126",    // 9
  "6245",    // 10
  "6246",    // 11
  "6305",    // 12
  "6307",    // 13
  "6331",    // 14
  "3 общага" // 15
];
List<Time> times = [
  Time('8:00', '9:35', "1 пара"),   // 0
  Time('9:45', '11:20', "2 пара"),  // 1
  Time('11:35', '13:10', "3 пара"), // 2
  Time('13:40', '15:15', "4 пара"), // 3
  Time('15:25', '17:00', "5 пара"), // 4
  Time('17:10', '18:45', "6 пара"), // 5
  Time('7:30', '9:05', "1 пара"),   // 6
  Time('9:20', '10:55', "2 пара"),  // 7
  Time('11:10', '12:45', "3 пара"), // 8
  Time('13:15', '14:50', "4 пара"), // 9
  Time('15:00', '16:35', "5 пара"), // 10
  Time('16:45', '18:20', "6 пара"), // 11
];

enum Weekday {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

var weekType = [
  "Четная", // 0
  "Нечётная", // 1
  "Любая", // 2
  "1", "2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20" //2 + номер
];

enum LessonType {
  remote,
  person,
}

var subgroups = [
  0, 1, 2, 3, 4
];

class Lesson {
  String subject;
  SubjectType subjectType;
  String teacher;
  Time time;
  String classroom;
  LessonType type;
  Lesson(this.subject, this.subjectType, this.teacher, this.time, this.classroom, this.type);
  static toJson(Lesson data){
    return '{"subject": "${data.subject}", '
        '"subjectType": "${data.subjectType.toString()}", '
        '"teacher": "${data.teacher}", '
        '"time": ${Time.toJson(data.time)}, '
        '"classroom": "${data.classroom}", '
        '"type": "${data.type.toString()}" '
        '}';
  }
  factory Lesson.fromJson(Map<String, dynamic> data){
    SubjectType subjectType = SubjectType.lab;
    switch (data['subjectType']){
      case "SubjectType.lesson":
        subjectType=SubjectType.lesson;
        break;
      case "SubjectType.practice":
        subjectType=SubjectType.practice;
        break;
      case "SubjectType.lab":
        subjectType=SubjectType.lab;
        break;

    }
    LessonType type = LessonType.person;
    switch (data['type']){
      case "LessonType.person":
        type = LessonType.person;
        break;
      case "LessonType.remote":
        type = LessonType.remote;
        break;

    }
    return Lesson(data['subject'], subjectType, data['teacher'], Time.fromJson(data['time']), data['classroom'], type);
  }
}
class DayLesson {
  Weekday day;
  String week;
  Lesson lesson;
  DayLesson(this.lesson,this.day,this.week);
  static toJson(DayLesson data){
    return '{"lesson": ${Lesson.toJson(data.lesson)}, '
        '"day": "${data.day.toString()}", '
        '"week": "${data.week}"'
        '}';
  }
  factory DayLesson.fromJson(Map<String, dynamic> data){
    Weekday day = Weekday.monday;
    switch (data['day']){
      case "Weekday.monday":
        day = Weekday.monday;
        break;
      case "Weekday.tuesday":
        day = Weekday.tuesday;
        break;
      case "Weekday.wednesday":
        day = Weekday.wednesday;
        break;
      case "Weekday.thursday":
        day = Weekday.thursday;
        break;
      case "Weekday.friday":
        day = Weekday.friday;
        break;
      case "Weekday.saturday":
        day = Weekday.saturday;
        break;
      case "Weekday.sunday":
        day = Weekday.sunday;
        break;
    }
    return DayLesson(Lesson.fromJson(data['lesson']), day, data['week']);
  }
}
class GroupDayLesson {
  DayLesson lesson;
  String group;
  int subgroup;
  GroupDayLesson(this.lesson,this.group,this.subgroup);
  static toJson(GroupDayLesson data){
    return '{"lesson": ${DayLesson.toJson(data.lesson)}, '
        '"group": "${data.group}", '
        '"subgroup": ${data.subgroup} '
        '}';
  }
  factory GroupDayLesson.fromJson(Map<String, dynamic> data){
    return GroupDayLesson(DayLesson.fromJson(data['lesson']), data['group'],  data['subgroup']);
  }
}
class Time {
  String start;
  String end;
  String label;
  late int startInt;
  late int endInt;
  Time(this.start, this.end, this.label){
    var temp = start.split(":");
    startInt = int.parse(temp[0]) * 3600 + int.parse(temp[1]) * 60;
    temp = end.split(":");
    endInt = int.parse(temp[0]) * 3600 + int.parse(temp[1]) * 60;
  }
  static toJson(Time time){
    return '{"start": "${time.start}", "end": "${time.end}", "label": "${time.label}"}';
  }
  factory Time.fromJson(Map<String, dynamic> data){
    return Time(data['start'], data['end'], data['label']);
  }
}
List<Lesson> lessons = [
  //понедельник нечетная
  Lesson(subjects[0], SubjectType.lesson, teachers[0], times[5+2], classrooms[3], LessonType.person),   //0
  Lesson(subjects[1], SubjectType.lab, teachers[6], times[5+3], classrooms[4], LessonType.person),      //1
  Lesson(subjects[1], SubjectType.lab, teachers[6], times[5+4], classrooms[4], LessonType.person),      //2
  //вторник нечетная
  Lesson(subjects[2], SubjectType.lab, teachers[2], times[5+1], classrooms[4], LessonType.person),      //3
  Lesson(subjects[2], SubjectType.lab, teachers[2], times[5+2], classrooms[4], LessonType.person),      //4
  Lesson(subjects[2], SubjectType.lesson, teachers[2], times[5+3], classrooms[4], LessonType.person),   //5
  Lesson(subjects[0], SubjectType.practice, teachers[0], times[5+4], classrooms[2], LessonType.person), //6
  //среда нечетная
  Lesson(subjects[3], SubjectType.practice, teachers[7], times[0], classrooms[12], LessonType.person),  //7
  Lesson(subjects[4], SubjectType.practice, teachers[4], times[1], classrooms[14], LessonType.person),  //8
  Lesson(subjects[5], SubjectType.lesson, teachers[3], times[2], classrooms[8], LessonType.person),     //9
  Lesson(subjects[4], SubjectType.lesson, teachers[4], times[3], classrooms[8], LessonType.person),     //10
  //четверг нечетная
  Lesson(subjects[5], SubjectType.lab, teachers[3], times[5+3], classrooms[0], LessonType.person),      //11
  Lesson(subjects[5], SubjectType.lab, teachers[3], times[5+4], classrooms[0], LessonType.person),      //12
  Lesson(subjects[4], SubjectType.lab, teachers[4], times[5+5], classrooms[1], LessonType.person),      //13
  Lesson(subjects[4], SubjectType.lab, teachers[4], times[5+6], classrooms[1], LessonType.person),      //14
  Lesson(subjects[6], SubjectType.lab, teachers[1], times[5+5], classrooms[5], LessonType.person),      //15
  Lesson(subjects[6], SubjectType.lab, teachers[1], times[5+6], classrooms[5], LessonType.person),      //16
  //пятница нечетная
  Lesson(subjects[7], SubjectType.practice, teachers[8], times[0], classrooms[15], LessonType.person),  //17
  Lesson(subjects[3], SubjectType.lesson, teachers[7], times[2], classrooms[9], LessonType.person),     //18
  Lesson(subjects[6], SubjectType.lesson, teachers[5], times[3], classrooms[11], LessonType.person),    //19
  Lesson(subjects[1], SubjectType.lesson, teachers[6], times[4], classrooms[10], LessonType.person),    //20
  //понедельник четная
  Lesson(subjects[6], SubjectType.practice, teachers[1], times[5+3], classrooms[7], LessonType.person), //21
  //вторник четная
  Lesson(subjects[6], SubjectType.lab, teachers[2], times[5+1], classrooms[6], LessonType.person),      //22
  Lesson(subjects[6], SubjectType.lab, teachers[2], times[5+2], classrooms[6], LessonType.person),      //23
  //четверг четная
  Lesson(subjects[5], SubjectType.lab, teachers[3], times[5+3], classrooms[0], LessonType.person),      //24
  Lesson(subjects[5], SubjectType.lab, teachers[3], times[5+4], classrooms[0], LessonType.person),      //25
  Lesson(subjects[4], SubjectType.lab, teachers[4], times[5+5], classrooms[1], LessonType.person),      //26
  Lesson(subjects[4], SubjectType.lab, teachers[4], times[5+6], classrooms[1], LessonType.person),      //27
  Lesson(subjects[6], SubjectType.lab, teachers[1], times[5+5], classrooms[5], LessonType.person),      //28
  Lesson(subjects[6], SubjectType.lab, teachers[1], times[5+6], classrooms[5], LessonType.person),      //29
  //пятница четная
  Lesson(subjects[6], SubjectType.practice, teachers[1], times[2], classrooms[13], LessonType.person),  //30
  //суббота четная
  Lesson(subjects[1], SubjectType.lab, teachers[6], times[5+3], classrooms[4], LessonType.person),      //31
  Lesson(subjects[1], SubjectType.lab, teachers[6], times[5+4], classrooms[4], LessonType.person),      //32
];
List<DayLesson> dayLessons = [
  //понедельник нечетная
  DayLesson(lessons[0], Weekday.monday, weekType[2]),          //0
  DayLesson(lessons[1], Weekday.monday, weekType[1]),          //1
  DayLesson(lessons[2], Weekday.monday, weekType[1]),          //2
  //вторник нечетная
  DayLesson(lessons[3], Weekday.tuesday, weekType[1]),         //3
  DayLesson(lessons[4], Weekday.tuesday, weekType[1]),         //4
  DayLesson(lessons[5], Weekday.tuesday, weekType[2]),         //5
  DayLesson(lessons[6], Weekday.tuesday, weekType[1]),         //6
  //среда нечетная
  DayLesson(lessons[7], Weekday.wednesday, weekType[1]),       //7
  DayLesson(lessons[8], Weekday.wednesday, weekType[1]),       //8
  DayLesson(lessons[9], Weekday.wednesday, weekType[2]),       //9
  DayLesson(lessons[10], Weekday.wednesday, weekType[2]),      //10
  //четверг нечетная
  DayLesson(lessons[11], Weekday.thursday, weekType[1]),       //11
  DayLesson(lessons[12], Weekday.thursday, weekType[1]),       //12
  DayLesson(lessons[13], Weekday.thursday, weekType[2+3]),     //13
  DayLesson(lessons[13], Weekday.thursday, weekType[2+7]),     //14
  DayLesson(lessons[13], Weekday.thursday, weekType[2+11]),    //15
  DayLesson(lessons[13], Weekday.thursday, weekType[2+15]),    //16
  DayLesson(lessons[14], Weekday.thursday, weekType[2+3]),     //17
  DayLesson(lessons[14], Weekday.thursday, weekType[2+7]),     //18
  DayLesson(lessons[14], Weekday.thursday, weekType[2+11]),    //19
  DayLesson(lessons[14], Weekday.thursday, weekType[2+15]),    //20
  DayLesson(lessons[15], Weekday.thursday, weekType[2+5]),     //21
  DayLesson(lessons[15], Weekday.thursday, weekType[2+9]),     //22
  DayLesson(lessons[15], Weekday.thursday, weekType[2+13]),    //23
  DayLesson(lessons[15], Weekday.thursday, weekType[2+17]),    //24
  DayLesson(lessons[16], Weekday.thursday, weekType[2+5]),     //25
  DayLesson(lessons[16], Weekday.thursday, weekType[2+9]),     //26
  DayLesson(lessons[16], Weekday.thursday, weekType[2+13]),    //27
  DayLesson(lessons[16], Weekday.thursday, weekType[2+17]),    //28
  //пятница нечетная
  DayLesson(lessons[17], Weekday.friday, weekType[2]),         //29
  DayLesson(lessons[18], Weekday.friday, weekType[1]),         //30
  DayLesson(lessons[19], Weekday.friday, weekType[2]),         //31
  DayLesson(lessons[20], Weekday.friday, weekType[2]),         //32
  //понедельник четная
  DayLesson(lessons[21], Weekday.monday, weekType[0]),         //33
  //вторник четная
  DayLesson(lessons[22], Weekday.tuesday, weekType[0]),        //34
  DayLesson(lessons[23], Weekday.tuesday, weekType[0]),        //35
  //среда четная

  // четверг четная
  DayLesson(lessons[24], Weekday.thursday, weekType[0]),        //36
  DayLesson(lessons[25], Weekday.thursday, weekType[0]),        //37
  DayLesson(lessons[26], Weekday.thursday, weekType[2+2]),     //38
  DayLesson(lessons[26], Weekday.thursday, weekType[2+6]),     //39
  DayLesson(lessons[26], Weekday.thursday, weekType[2+10]),    //40
  DayLesson(lessons[26], Weekday.thursday, weekType[2+14]),    //41
  DayLesson(lessons[27], Weekday.thursday, weekType[2+2]),     //42
  DayLesson(lessons[27], Weekday.thursday, weekType[2+6]),     //43
  DayLesson(lessons[27], Weekday.thursday, weekType[2+10]),    //44
  DayLesson(lessons[27], Weekday.thursday, weekType[2+14]),    //45
  DayLesson(lessons[28], Weekday.thursday, weekType[2+4]),     //46
  DayLesson(lessons[28], Weekday.thursday, weekType[2+8]),     //47
  DayLesson(lessons[28], Weekday.thursday, weekType[2+12]),    //48
  DayLesson(lessons[28], Weekday.thursday, weekType[2+16]),    //49
  DayLesson(lessons[29], Weekday.thursday, weekType[2+4]),     //50
  DayLesson(lessons[29], Weekday.thursday, weekType[2+8]),     //51
  DayLesson(lessons[29], Weekday.thursday, weekType[2+12]),    //52
  DayLesson(lessons[29], Weekday.thursday, weekType[2+16]),    //53
  //пятница четная
  DayLesson(lessons[30], Weekday.friday, weekType[0]),         //54
  //суббота четная
  DayLesson(lessons[31], Weekday.saturday, weekType[0]),       //55
  DayLesson(lessons[32], Weekday.saturday, weekType[0]),       //56
];
List<GroupDayLesson> groupDayLessons = [
  GroupDayLesson(dayLessons[0], "21-СТ", 0),
  GroupDayLesson(dayLessons[1], "21-СТ", 1),
  GroupDayLesson(dayLessons[2], "21-СТ", 1),
  GroupDayLesson(dayLessons[3], "21-СТ", 2),
  GroupDayLesson(dayLessons[4], "21-СТ", 2),
  GroupDayLesson(dayLessons[5], "21-СТ", 0),
  GroupDayLesson(dayLessons[6], "21-СТ", 0),
  GroupDayLesson(dayLessons[7], "21-СТ", 0),
  GroupDayLesson(dayLessons[8], "21-СТ", 0),
  GroupDayLesson(dayLessons[9], "21-СТ", 0),
  GroupDayLesson(dayLessons[10], "21-СТ", 0),
  GroupDayLesson(dayLessons[11], "21-СТ", 1),
  GroupDayLesson(dayLessons[12], "21-СТ", 1),
  GroupDayLesson(dayLessons[13], "21-СТ", 1),
  GroupDayLesson(dayLessons[14], "21-СТ", 1),
  GroupDayLesson(dayLessons[15], "21-СТ", 1),
  GroupDayLesson(dayLessons[16], "21-СТ", 1),
  GroupDayLesson(dayLessons[17], "21-СТ", 1),
  GroupDayLesson(dayLessons[18], "21-СТ", 1),
  GroupDayLesson(dayLessons[19], "21-СТ", 1),
  GroupDayLesson(dayLessons[20], "21-СТ", 1),
  GroupDayLesson(dayLessons[21], "21-СТ", 1),
  GroupDayLesson(dayLessons[22], "21-СТ", 1),
  GroupDayLesson(dayLessons[23], "21-СТ", 1),
  GroupDayLesson(dayLessons[24], "21-СТ", 1),
  GroupDayLesson(dayLessons[25], "21-СТ", 1),
  GroupDayLesson(dayLessons[26], "21-СТ", 1),
  GroupDayLesson(dayLessons[27], "21-СТ", 1),
  GroupDayLesson(dayLessons[28], "21-СТ", 1),
  GroupDayLesson(dayLessons[29], "21-СТ", 0),
  GroupDayLesson(dayLessons[30], "21-СТ", 0),
  GroupDayLesson(dayLessons[31], "21-СТ", 0),
  GroupDayLesson(dayLessons[32], "21-СТ", 0),
  GroupDayLesson(dayLessons[33], "21-СТ", 0),
  GroupDayLesson(dayLessons[34], "21-СТ", 1),
  GroupDayLesson(dayLessons[35], "21-СТ", 1),
  GroupDayLesson(dayLessons[36], "21-СТ", 2),
  GroupDayLesson(dayLessons[37], "21-СТ", 2),
  GroupDayLesson(dayLessons[38], "21-СТ", 2),
  GroupDayLesson(dayLessons[39], "21-СТ", 2),
  GroupDayLesson(dayLessons[40], "21-СТ", 2),
  GroupDayLesson(dayLessons[41], "21-СТ", 2),
  GroupDayLesson(dayLessons[42], "21-СТ", 2),
  GroupDayLesson(dayLessons[43], "21-СТ", 2),
  GroupDayLesson(dayLessons[44], "21-СТ", 2),
  GroupDayLesson(dayLessons[45], "21-СТ", 2),
  GroupDayLesson(dayLessons[46], "21-СТ", 2),
  GroupDayLesson(dayLessons[47], "21-СТ", 2),
  GroupDayLesson(dayLessons[48], "21-СТ", 2),
  GroupDayLesson(dayLessons[49], "21-СТ", 2),
  GroupDayLesson(dayLessons[50], "21-СТ", 2),
  GroupDayLesson(dayLessons[51], "21-СТ", 2),
  GroupDayLesson(dayLessons[52], "21-СТ", 2),
  GroupDayLesson(dayLessons[53], "21-СТ", 2),
  GroupDayLesson(dayLessons[54], "21-СТ", 0),
  GroupDayLesson(dayLessons[55], "21-СТ", 2),
  GroupDayLesson(dayLessons[56], "21-СТ", 2),
];