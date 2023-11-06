import 'package:flutter/material.dart';
import 'package:schedule/services/data/view_lesson.dart';

class ScheduleModel with ChangeNotifier {
  final Map<int, ScheduleOfDay> _mapSchedule = {};
  Map<int, ScheduleOfDay> get mapSchedule => _mapSchedule;
  addSchedule(ScheduleOfWeek scheduleOfWeek){
    for (int i = 0; i < 7; i++) {
      var day = scheduleOfWeek.list[i];
      if (day != null) {
        _mapSchedule[i] = day;
      }
    }
    notifyListeners();
  }
}
class ScheduleDayModel with ChangeNotifier {

}