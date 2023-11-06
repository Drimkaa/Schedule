import 'dart:math';

import 'package:flutter/material.dart';
import 'package:schedule/services/data/week.dart';
import 'package:schedule/services/schedule.dart';
import 'package:schedule/services/time.dart';


class SettingsAppBar extends StatefulWidget {
  const SettingsAppBar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsAppBar();
}

class _SettingsAppBar extends State<SettingsAppBar> {
  @override
  initState() {
    super.initState();
    init();
  }

  init() async {}

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      title: Text("Настройки"),
    );
  }
}
class TodayAppBar extends StatefulWidget {
  const TodayAppBar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TodayAppBar();
}

class _TodayAppBar extends State<TodayAppBar> {
  @override
  initState() {
    super.initState();
    init();
  }

  init() async {}

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Color(0xFF6bbfff),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            Container(width: 8),
            Text(
              "Практика".toUpperCase(),
              style: TextStyle(color: Color(0xFF6bbfff), fontWeight: FontWeight.w700, fontSize: 12),
            )
          ],
        ),
        Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Color(0xff33ff77),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            Container(width: 8),
            Text(
              "перерыв".toUpperCase(),
              style: TextStyle(color: Color(0xff33ff77), fontWeight: FontWeight.w700, fontSize: 12),
            )
          ],
        ),
        Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Color(0xFFdeff38),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            Container(width: 8),
            Text(
              "Лекция".toUpperCase(),
              style: TextStyle(color: Color(0xFFdeff38), fontWeight: FontWeight.w700, fontSize: 12),
            )
          ],
        ),
        Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Color(0xFFFF4DB8),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            Container(width: 8),
            Text(
              "лаб.раб".toUpperCase(),
              style: TextStyle(color: Color(0xFFFF4DB8), fontWeight: FontWeight.w700, fontSize: 12),
            )
          ],
        ),
      ]),
    );
  }
}

class ScheduleAppBar extends StatefulWidget {
  ScheduleAppBar({Key? key, Function? this.press}) : super(key: key);
  Function? press;

  @override
  State<StatefulWidget> createState() => _ScheduleAppBar();
}

class _ScheduleAppBar extends State<ScheduleAppBar> {
  late ScheduleService scheduleService;
  final TimeService _timeService = TimeService.instance;
  late Week week = _timeService.week;

  @override
  initState() {
    super.initState();
    init();
  }

  init() async {
    scheduleService = await ScheduleService.instance;
    setState(() {
      week = _timeService.week;
    });
  }

  lastWeek() {
    setState(() {
      week = _timeService.weekByNumber(max(week.number - 1,0));
    });
    if (widget.press != null) {
      widget.press!(week);
    }
  }

  nextWeek() {
    setState(() {
      week = _timeService.weekByNumber(week.number + 1);
    });
    if (widget.press != null) {
      widget.press!(week);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,

      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            week.type,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => lastWeek(),
                icon: const Icon(Icons.chevron_left_rounded),
                splashRadius: 30,
              ),
              Container(
                width: 16,
              ),
              Text(
                "${week.number} неделя",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Container(
                width: 16,
              ),
              IconButton(
                onPressed: () => nextWeek(),
                icon: const Icon(Icons.chevron_right_rounded),
                splashRadius: 30,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
