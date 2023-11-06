import 'package:flutter/material.dart';
import 'package:schedule/services/data/lesson2.dart';
import 'package:schedule/services/schedule.dart';
import 'package:schedule/services/time.dart';
import 'package:schedule/theme_config.dart';

import '../services/data/week.dart';

class LessonCard extends StatefulWidget {
  const LessonCard({Key? key, required this.lesson, required this.day, required this.week}) : super(key: key);
  final Week week;
  final DayLesson lesson;
  final int day;

  @override
  State<StatefulWidget> createState() => _LessonCard();
}

class _LessonCard extends State<LessonCard> {
  late DayLesson lesson = widget.lesson;
  late int day = widget.day;
  late Week week = widget.week;
  _LessonCard();
  List<Widget> children = [];
  late bool currentLesson = false;
  final TimeService _timeService = TimeService.instance;
  @override
  void initState() {
    super.initState();
    checkLesson();
  }

  void checkLesson() async {
    final timeService = TimeService.instance;
    var startTime = lesson.lesson.time.startInt;
    var endTime = lesson.lesson.time.endInt;
    int currentTime = timeService.currentDayTime;
    if (currentTime >= startTime && currentTime <= endTime && day == timeService.day && week == _timeService.week) {
      setState(() {
        currentLesson = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).extension<MyColors>()!.lessonCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).extension<MyColors>()!.lessonCardBorder ?? const Color(0xffffffff), width: 2),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            SizedBox(
              width: 50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    lesson.lesson.time.start,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Text(
                    lesson.lesson.classroom,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.red),
                  ),
                  Text(
                    lesson.lesson.time.end,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
            Container(width: 6),
            Flexible(
              fit: FlexFit.tight,
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(lesson.lesson.subjectType.toString().toUpperCase(), style: Theme.of(context).textTheme.labelLarge),
                  Text(lesson.lesson.subject, softWrap: true, style: Theme.of(context).textTheme.headlineMedium),
                  Text(lesson.lesson.teacher, style: Theme.of(context).textTheme.labelLarge),
                ],
              ),
            ),
            Container(width: 6),
            if (currentLesson)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Theme.of(context).textTheme.titleSmall!.color,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
