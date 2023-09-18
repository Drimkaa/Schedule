import 'package:flutter/material.dart';
import 'package:schedule/services/schedule.dart';
import 'package:schedule/services/time.dart';
import 'package:schedule/theme_config.dart';

import '../services/data/week.dart';

class LessonCard extends StatefulWidget {
  const LessonCard({Key? key, required this.lesson, required this.day, required this.week}) : super(key: key);
  final Week week;
  final LessonSchedule lesson;
  final int day;

  @override
  State<StatefulWidget> createState() => _LessonCard();
}

class _LessonCard extends State<LessonCard> {
  late LessonSchedule lesson = widget.lesson;
  List<Widget> children = [];
  _LessonCard();
  late int day = widget.day;
  late Week week = widget.week;
  late bool currentLesson = false;
  final TimeService _timeService = TimeService.instance;
  @override
  void initState() {
    checkLesson();

    super.initState();
  }

  void checkLesson() async {
    final timeService = await TimeService.instance;
    var temp = lesson.time.start.split(":");
    int startTime = int.parse(temp[0]) * 3600 + int.parse(temp[1]) * 60;
    temp = lesson.time.end.split(":");
    int endTime = int.parse(temp[0]) * 3600 + int.parse(temp[1]) * 60;
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
        border: Border.all(color: Theme.of(context).extension<MyColors>()!.lessonCardBorder ?? Color(0xffffffff), width: 2),

        //_stops.map((s) => s + animation!.value).toList())
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
                    lesson.time.start,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Text(lesson.classRoom,
                      textAlign: TextAlign.center, style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.red)),
                  Text(
                    lesson.time.end,
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
                  Text(lesson.objectType.toUpperCase(), style: Theme.of(context).textTheme.labelLarge),
                  Text(lesson.object, softWrap: true, style: Theme.of(context).textTheme.headlineMedium),
                  Text(lesson.teacher, style: Theme.of(context).textTheme.labelLarge)
                ],
              ),
            ),
            Container(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (currentLesson)
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24), color: Theme.of(context).textTheme.titleSmall!.color),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
