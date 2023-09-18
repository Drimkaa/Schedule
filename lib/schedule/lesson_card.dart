import 'package:flutter/material.dart';
import 'package:schedule/serivces/schedule.dart';
import 'package:schedule/serivces/time.dart';
import 'package:schedule/theme_config.dart';

class LessonCard extends StatefulWidget {
  const LessonCard({Key? key, required this.lesson, required this.day})
      : super(key: key);
  final LessonSchedule lesson;
  final int day;

  @override
  State<StatefulWidget> createState() => _LessonCard(this.lesson, this.day);
}

class _LessonCard extends State<LessonCard> {
  final LessonSchedule lesson;
  List<Widget> children = [];
  _LessonCard(this.lesson, this.day);
  final int day;

  late bool currentLesson = false;

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
    int currentTime = timeService.hours * 3600 +
        timeService.minutes * 60 +
        timeService.seconds;
    if (currentTime >= startTime &&
        currentTime <= endTime &&
        day == timeService.day) {
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
        border: Border.all(
            color: Theme.of(context).extension<MyColors>()!.lessonCardBorder ??
                Color(0xffffffff),
            width: 2),

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
                  Text(lesson.time.start,
                      style: currentLesson?
                      Theme.of(context).textTheme.labelMedium!.copyWith(color:Theme.of(context).extension<MyColors>()!.active ):
                      Theme.of(context).textTheme.labelMedium),
                  Text(lesson.classRoom,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(color: Colors.red)),
                  Text(lesson.time.end,
                      style: currentLesson?
                      Theme.of(context).textTheme.labelMedium!.copyWith(color:Theme.of(context).extension<MyColors>()!.active ):
                      Theme.of(context).textTheme.labelMedium
                  ),
                ],
              ),
            ),
            Container(
              width: 6,
            ),
            // 20%

            Flexible(
                fit: FlexFit.tight,
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(lesson.objectType.toUpperCase(),
                        style: Theme.of(context).textTheme.labelLarge),
                    Text(lesson.object,
                        softWrap: true,
                        style: Theme.of(context).textTheme.headlineMedium),
                    Text(lesson.teacher,
                        style: Theme.of(context).textTheme.labelLarge)
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
