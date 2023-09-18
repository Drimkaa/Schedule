import 'package:flutter/material.dart';
import 'package:schedule/schedule/lesson_card.dart';
import 'package:schedule/schedule/sizeBloc.dart';
import 'package:schedule/services/data/week.dart';

import 'package:schedule/services/schedule.dart';
import 'package:schedule/services/time.dart';
import 'package:schedule/theme_config.dart';

class DayCard extends StatefulWidget {
  const DayCard({Key? key, required this.day, required this.id, required this.week}) : super(key: key);
  final Week week;
  final DaySchedule day;

  final int id;

  @override
  State<StatefulWidget> createState() => _DayCard();
}

class _DayCard extends State<DayCard> {
  _DayCard();
  late final DaySchedule day;
  late bool currentDay = false;
  late int id;

  List<Widget> children = [];

  final TimeService _timeService = TimeService.instance;
  @override
  void initState() {
    super.initState();
    init();

    for (final lesson in day.lessons) {
      children.add(LessonCard(
        lesson: lesson,
        day: day.day + 1,
        week:widget.week,
      ));
      children.add(
        const Padding(padding: EdgeInsets.only(top: 10)),
      );
    }

    id = widget.id;
  }

  void init() {

    day = widget.day;

    currentDay = _timeService.day == day.day + 1 && _timeService.week.number == widget.week.number;
    if (currentDay && _timeService.week == widget.week) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void afterFirstLayout(BuildContext context) {
    dayBloc.update(id, DayBlock(_key, currentDay, id));
  }

  final GlobalKey _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => afterFirstLayout(context));

    return Column(
      children: [
        const Padding(padding: EdgeInsets.only(top: 10)),
        Column(
          key: _key,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(dataDayList[day.day],
                    textAlign: TextAlign.left,
                    style: currentDay
                        ? Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Theme.of(context).extension<MyColors>()!.active)
                        : Theme.of(context).textTheme.titleMedium),
                if (currentDay)
                  Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24), color: Theme.of(context).textTheme.titleSmall!.color))
              ],
            ),
            Container(height: 16),
            ...children
          ],
        ),
      ],
    );
  }
}
