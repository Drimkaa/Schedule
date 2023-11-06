import 'package:flutter/material.dart';
import 'package:schedule/schedule/lesson_card.dart';
import 'package:schedule/services/data/view_lesson.dart';
import 'package:schedule/services/data/week.dart';
import 'package:schedule/services/time.dart';
import 'package:schedule/theme_config.dart';

class DayCard extends StatefulWidget {
  const DayCard({Key? key, required this.day, required this.week}) : super(key: key);
  final Week week;
  final ScheduleOfDay day;
  @override
  State<StatefulWidget> createState() => _DayCard();
}

class _DayCard extends State<DayCard> {
  _DayCard();
  late final ScheduleOfDay day;
  late bool currentDay = false;
  List<Widget> children = [];
  final TimeService _timeService = TimeService.instance;
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    day = widget.day;
    day.
    for (final lesson in day.lessons) {
      children.add(
        LessonCard(
          lesson: lesson,
          day: day.dayId,
          week: widget.week,
        )
      );
      children.add(
        const Padding(padding: EdgeInsets.only(top: 10)),
      );
    }
    currentDay = _timeService.day == day.dayId + 1 && _timeService.week.number == widget.week.number;
    if (currentDay && _timeService.week == widget.week) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> dayLabel = [Text(day.dayName, textAlign: TextAlign.left, style: Theme.of(context).textTheme.titleMedium)];
    if (currentDay) {
      dayLabel = [
        Text(day.dayName,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).extension<MyColors>()!.active)),
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Theme.of(context).textTheme.titleSmall!.color,
          ),
        ),
      ];
    }
    return Column(
      children: [
        const Padding(padding: EdgeInsets.only(top: 10)),
        Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [...dayLabel],
            ),
            Container(height: 16),
            ...children
          ],
        ),
      ],
    );
  }
}
