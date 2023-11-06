import 'dart:async';

import 'package:flutter/material.dart';
import 'package:schedule/schedule/day_card.dart';
import 'package:schedule/services/data/view_lesson.dart';
import 'package:schedule/services/schedule_service.dart';
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
  late Week currentWeek = _timeService.week;
  late ScheduleService scheduleService;
  late Future<ScheduleOfWeek> data = getLessons(currentWeek);
  @override
  initState() {
    super.initState();
    init();
  }

  void init() async {
    appBloc.updateTitle('Расписание', changeWeek);
  }

  void changeWeek(Week value) {
    setState(() {
      currentWeek = value;
      data = getLessons(currentWeek);
    });
  }

  Future<ScheduleOfWeek> getLessons(Week currentWeek) async {
    scheduleService = await ScheduleService.instance;
    ScheduleOfWeek week = scheduleService.getWeekSchedule(currentWeek);
    for (var element in week.list.keys) {
      week.list[element]?.lessons.sort((a, b) => a.lesson.time.startInt.compareTo(b.lesson.time.startInt));
    }
    return week;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ScheduleOfWeek>(
        future: data,
        builder: (context, snapshot) {
          List<Widget> children = [];
          if (currentWeek.number <= 0) {
            return SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: Align(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("🍀", style: Theme.of(context).textTheme.displayLarge),
                    Text("пусто!!", style: Theme.of(context).textTheme.displayMedium),
                  ],
                ),
              ),
            );
          }
          if (snapshot.hasData) {
            for (int i = 0; i < 7; i++) {
              var day = snapshot.data!.list[i];
              if (day != null) {
                children.add(DayCard(day: day, week: currentWeek));
              }
            }
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(Icons.error_outline, color: Colors.red, size: 60),
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
              child: Column(children: [...children, Container(height: 82)]));
        });
  }
}
