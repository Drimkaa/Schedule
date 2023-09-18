import 'dart:async';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule/schedule/day_card.dart';
import 'package:schedule/schedule/sizeBloc.dart';
import 'package:schedule/serivces/schedule.dart';
import 'package:schedule/shared/appbar/appbar_bloc.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SchedulePage();
}

class _SchedulePage extends State<SchedulePage> {

  late Timer timer;
  bool condition = false;
  var currentWeek = -1;
  @override
  initState() {
    super.initState();
    init();
    appBloc.updateTitle('Расписание',changeWeek);
    dayBloc.dispose();
  }
  void changeWeek(int num){

    setState(() {
      currentWeek = num;
    });
  }
  void init() async {
    final scheduleService = await ScheduleService.instance;

    setState(() {
      currentWeek = scheduleService.weekNumber;
    });
  }
  startTimer() {
    if (!condition) {
      condition = true;
      timer = Timer.periodic(const Duration(seconds: 60), (timer) {
        timerFunction();
      });
    }
  }
  var weekNumber = 0;
  void timerFunction() async{
    final scheduleService = await ScheduleService.instance;
    if(weekNumber != scheduleService.weekNumber){
      weekNumber = scheduleService.weekNumber;
      getLessons(weekNumber);
    }

  }
  cancelTimer() {
    timer.cancel();
  }
  Future<WeekSchedule> getLessons(int weekNum) async {
    final scheduleService = await ScheduleService.instance;

    WeekSchedule week = await scheduleService.localSchedule(weekNum);
    week.days.sort((a, b) => a.day.compareTo(b.day));
    week.days.forEach((element) {
      element.lessons.sort((a, b) => getTime(a.time).compareTo(getTime(b.time)));
    });

    startTimer();
    //получение id's
    return week;
  }



  getTime(Time time) {
    var first = time.start.split(":");

    return int.parse(first[0]) * 60 + int.parse(first[1]);
  }

  void dispose() {
    dayBloc.dispose();
    condition = false;
    cancelTimer();
    super.dispose();
  }

  void scroll(DayBlock day) {
    if (day.current) {
      Scrollable.ensureVisible(day.key.currentContext!, alignment:20.0);

      scrolled = true;
    }
  }

  bool scrolled = false;
  List<GlobalKey> keysList = [];
  var currentDay = DateTime.now().day;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WeekSchedule>(
        future: getLessons(currentWeek),
        builder: (context, snapshot) {
          dayBloc.dispose();
          List<Widget> children = [];
          if(currentWeek == -1){

            return  Container();
          }
          var counter = 0;
          if (snapshot.hasData) {
            for (int i = 0; i < snapshot.data!.days.length; i++) {
              var day = snapshot.data!.days[i];
              if (day.lessons.isNotEmpty) {

                GlobalKey keys = GlobalKey();
                dayBloc.add();
                dayBloc.get(counter).listen((event) {
                  if(!scrolled)
                  scroll(event);
                });
                children.add(DayCard(key: keys, day: day, id: counter, week: currentWeek,));

                counter += 1;
              } else {}
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
