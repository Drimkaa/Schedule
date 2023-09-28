import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule/services/data/lesson.dart';
import 'package:schedule/services/schedule.dart';
import 'package:schedule/shared/appbar/appbar_bloc.dart';
import 'package:schedule/today/cards/today_blocks.dart';
import 'package:schedule/today/lines/today_lines.dart';
import 'package:schedule/today/today_model.dart';

import '../services/time.dart';

class TodayPage extends StatefulWidget {
  const TodayPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TodayPage();
}

class _TodayPage extends State<TodayPage> {
  final TimeService _timeService = TimeService.instance;

  @override
  initState() {
    super.initState();
    init();
  }

  init() async {
    appBloc.updateTitle('Сегодня');
  }

  getTime(Time time) {
    var first = time.start.split(":");

    return int.parse(first[0]) * 60 + int.parse(first[1]);
  }

  Future<TodayModel> getTodaySchedule() async {
    TodayModel model = TodayModel();
    final scheduleService = await ScheduleService.instance;
    DaySchedule currentDay = await scheduleService.localThisDaySchedule();
    if (currentDay.lessons.length>0) {
      int lessonsCount = currentDay.lessons.length;
      currentDay.lessons.sort((a, b) => getTime(a.time).compareTo(getTime(b.time)));


      int counter = 0;
      for (var i = 0; i < lessonsCount; i++) {
        var lesson = currentDay.lessons[i];
        var temp = lesson.time.start.split(":");
        int start = int.parse(temp[0]) * 3600 + int.parse(temp[1]) * 60;
        temp = lesson.time.end.split(":");
        int end = int.parse(temp[0]) * 3600 + int.parse(temp[1]) * 60;
        Timing blockTime = Timing(lesson.time.start,lesson.time.end,start, end);
        ScheduleBlock blockLesson = ScheduleBlock("lesson", lesson.objectType, blockTime, counter++);
        blockLesson.lesson = lesson;
        model.add(blockLesson);
        if (i + 1 < lessonsCount) {
          var nextLesson = currentDay.lessons[i + 1];
          temp = nextLesson.time.start.split(":");
          int nextLessonStart = int.parse(temp[0]) * 3600 + int.parse(temp[1]) * 60;
          blockTime = Timing(lesson.time.end,nextLesson.time.start,end + 1, nextLessonStart);
          ScheduleBlock blockBreak = ScheduleBlock("break", "break", blockTime, counter++);
          model.add(blockBreak);
        }
      }
    }
    return model;
  }

  @override
  Widget build(BuildContext context) {
    return FutureProvider<TodayModel?>(
      initialData: null,
      create: (context) => getTodaySchedule(),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Stack(
          children: [
            TodayLines(),
            Container(
              padding: const EdgeInsets.only(top: 16, left: 32, right: 32),
              child: TodayBlocks(),
            ),
          ],
        ),
      ),
    );
  }
}
