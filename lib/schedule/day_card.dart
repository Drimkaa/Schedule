import 'package:flutter/material.dart';
import 'package:schedule/schedule/lesson_card.dart';
import 'package:schedule/schedule/sizeBloc.dart';
import 'package:schedule/serivces/schedule.dart';
import 'package:schedule/serivces/time.dart';
import 'package:schedule/theme_config.dart';

class DayCard extends StatefulWidget {
  const DayCard({Key? key, required this.day,required this.id, required this.week}) : super(key: key);
  final DaySchedule day;
  final int id;
  final int week;
  @override
  State<StatefulWidget> createState() => _DayCard(day);
}

class _DayCard extends State<DayCard> {
  final DaySchedule day;
  late bool currentDay = false;
  late int id;
  _DayCard(this.day);
  List<Widget> children = [];

  @override
  void initState() {
    checkDay();

    for (final lesson in day.lessons) {

      children.add(LessonCard(lesson: lesson, day: day.day+1,));
      children.add(
        const Padding(padding: EdgeInsets.only(top: 10)),
      );
    }

    super.initState();
    id = widget.id;
  }

  void checkDay() async {
    final timeService = await TimeService.instance;

    currentDay = timeService.day == day.day + 1;
    if (currentDay && timeService.currentWeek == widget.week) {
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
  GlobalKey _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => afterFirstLayout(context));

    return Column(children: [
      const Padding(padding: EdgeInsets.only(top: 10)),
      Column(
        key: _key,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(dataDayList[day.day],
                    textAlign: TextAlign.left,
                    style: currentDay
                        ? Theme.of(context).textTheme.titleMedium!.copyWith(color:Theme.of(context).extension<MyColors>()!.active )
                        : Theme.of(context).textTheme.titleMedium),
                if (currentDay)
                  Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .color))
              ]),
          Container(height: 16),
          ...children
        ],
      ),
    ]);
  }
}
