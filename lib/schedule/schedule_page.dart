import 'dart:async';

import 'package:flutter/material.dart';
import 'package:schedule/schedule/day_card.dart';
import 'package:schedule/schedule/sizeBloc.dart';
import 'package:schedule/services/schedule.dart';
import 'package:schedule/services/data/week.dart';
import 'package:schedule/services/time.dart';
import 'package:schedule/shared/appbar/appbar_bloc.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SchedulePage();
}

class _SchedulePage extends State<SchedulePage> {
  final TimeService _timeService = TimeService.instance;
  late Week week = _timeService.week;
  late ScheduleService scheduleService;
  late Future<WeekSchedule> data = getLessons(week);
  @override
  initState() {
    super.initState();
    init();
  }

  void init() async {
    appBloc.updateTitle('Расписание', changeWeek);
    dayBloc.dispose();
  }

  void changeWeek(Week value) {
    setState(() {
      print(week.toString());
      week = value;
      data = getLessons(week);
      print(week);
    });
  }

  Future<WeekSchedule> getLessons(Week currentWeek) async {
    scheduleService = await ScheduleService.instance;
    WeekSchedule week = await scheduleService.localSchedule(currentWeek);
    week.days.sort((a, b) => a.day.compareTo(b.day));
    for (var element in week.days) {
      element.lessons.sort((a, b) => getTime(a.time).compareTo(getTime(b.time)));
    }

    return week;
  }

  getTime(Time time) {
    var first = time.start.split(":");

    return int.parse(first[0]) * 60 + int.parse(first[1]);
  }

  @override
  void dispose() {
    dayBloc.dispose();
    super.dispose();
  }

  void scroll(DayBlock day) {
    if (day.current) {
      Scrollable.ensureVisible(day.key.currentContext!, alignment: 20.0);
      scrolled = true;
    }
  }

  bool scrolled = false;
  List<GlobalKey> keysList = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WeekSchedule>(
        future: data,
        builder: (context, snapshot) {
          dayBloc.dispose();
          List<Widget> children = [];
          if (week.number == -1) {
            return Container();
          }
          var counter = 0;
          if (snapshot.hasData) {
            for (int i = 0; i < snapshot.data!.days.length; i++) {
              var day = snapshot.data!.days[i];
              if (day.lessons.isNotEmpty) {
                GlobalKey keys = GlobalKey();
                dayBloc.add();
                dayBloc.get(counter).listen((event) {
                  if (!scrolled) {
                    scroll(event);
                  }
                });
                children.add(
                  DayCard(
                    key: keys,
                    day: day,
                    id: counter++,
                    week: week,
                  ),
                );
              }
            }
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'Ошибка: ${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            ];
          }
          return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(top: 0, left: 16, right: 16),
              child: Column(children: [
                ...children,
                Container(
                  height: 82,
                )
              ]));
        });
  }
}
