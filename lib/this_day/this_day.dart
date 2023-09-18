import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:schedule/services/schedule.dart';
import 'package:schedule/shared/appbar/appbar_bloc.dart';
import 'package:schedule/theme_config.dart';
import 'package:schedule/this_day/bloc.dart';
import 'package:schedule/this_day/sizeBloc.dart';
import 'package:schedule/this_day/this_day_break.dart';
import 'package:schedule/this_day/this_day_lesson.dart';

import '../services/time.dart';
import '../services/times.dart';
import '../shared/widgets/curve_line.dart';

class ThisDayPage extends StatefulWidget {
  const ThisDayPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ThisDayPage();
}

class _ThisDayPage extends State<ThisDayPage> {
  late Timer timer;
  bool condition = false;
  TimeService timeService = TimeService.instance;

  @override
  initState() {
    super.initState();
    appBloc.updateTitle('Сегодня');
  }

  timerFunction() {
    var time = DateTime.now();
    int currentTime = time.second + time.minute * 60 + time.hour * 3600;
    if (dayTimes.isNotEmpty) {
      dayTimes.forEach((element) {
        if (currentTime >= element.end) {
          timeBloc.updateGradient(element.id, [1, 1]);
        }
        if (currentTime >= element.start && currentTime <= element.end) {
          var duration = element.end - element.start;
          var offset = currentTime - element.start;
          var position = min(offset / duration, 1.0);
          List<double> steps = [position, min(position + 0.1, 1.0)];
          timeBloc.updateGradient(element.id, steps);
        }
      });
    }
  }

  startTimer() {
    if (!condition) {
      condition = true;
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        timerFunction();
      });
    }
  }

  List<EventTime> dayTimes = [];

  cancelTimer() {
    timer.cancel();
  }

  Future<DaySchedule> getDay() async {
    final scheduleService = await ScheduleService.instance;

    DaySchedule currentDay = await scheduleService.localThisDaySchedule();
    if (currentDay.lessons.isNotEmpty) {
      int lessonsCount = currentDay.lessons.length;
      var j = 0;
      for (var i = 0; i < lessonsCount; i++) {
        if (timeBloc.length < j + 1) {
          timeBloc.add();
          sizeBloc.add();

          var lesson = currentDay.lessons[i];
          var temp = lesson.time.start.split(":");
          int startTime = int.parse(temp[0]) * 3600 + int.parse(temp[1]) * 60;
          temp = lesson.time.end.split(":");
          int endTime = int.parse(temp[0]) * 3600 + int.parse(temp[1]) * 60;
          dayTimes.add(EventTime("lesson", j++, startTime, endTime));
          if (i + 1 < lessonsCount) {
            var nextLesson = currentDay.lessons[i + 1];

            temp = nextLesson.time.start.split(":");
            int nextLessonStartTime = int.parse(temp[0]) * 3600 + int.parse(temp[1]) * 60;
            dayTimes.add(EventTime("break", j++, endTime + 1, nextLessonStartTime - 1));
            timeBloc.add();
          }
          sizeBloc.get(i).listen((event) {
            getSizes(event);
          });
        }
      }
    }
    timerFunction();
    startTimer();
    return currentDay;
  }

  @override
  void dispose() {
    cancelTimer();
    timeBloc.dispose();
    sizeBloc.dispose();

    super.dispose();
  }

  var counter = 0;

  getSizes(contentBlock block) {
    curveSizes[block.id] = block;
    createRoadMap();
  }

  var offsetList = 0.0;
  List<Widget> roadMap = [];

  createRoadMap() {
    if (curveSizes.length != dayTimes.length) {
      return;
    }
    roadMap = [];
    var firstGradientColor =  Color(0xff33ff77);
    var secondGradientColor =  Color(0xff33ff77);
    List<Color> gradientColors = [Colors.white, Colors.white];
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var lineType = "start";
    Color color = Theme.of(context).extension<MyColors>()!.lessonCardBorder ?? Color(0xFFffffff);
    var elementHeight = 0.0;
    var offset = 10.0;
    var borderRadius = 24.0;
    int currentTime = timeService.currentDayTime;
    for (int i = 0; i < 15; i++) {
      color = Theme.of(context).extension<MyColors>()!.lessonCardBorder ?? Color(0xFFffffff);

      if (curveSizes[i] != null) {

        switch (curveSizes[i]?.lessonType){
          case "Лекция":
            firstGradientColor = Color(0xFFdeff38);
            break;
          case "Практика":
            firstGradientColor = Color(0xFF6bbfff);
            break;
          case "Лабораторная работа":
            firstGradientColor = Color(0xFFFF4DB8);
            break;
          case "break":
            firstGradientColor = Color(0xff33ff77);
            break;

        }
        final BuildContext? buildContext = curveSizes[i]?.key.currentContext;
        if (buildContext != null) {
          final renderObject = buildContext.findRenderObject();
          if (renderObject != null) {

            var firstSchedule = dayTimes[min(i, dayTimes.length - 1)];
            final RenderBox renderBox = renderObject as RenderBox;
            final path = Path();
            var viewPadding = MediaQuery.of(context).systemGestureInsets.top;
            double firstPosition = i == 0 ? renderBox.localToGlobal(Offset.zero).dy - 4 - viewPadding : renderBox.size.height / 2;
            double firstHeight = renderBox.size.height;
            double firstLeft = renderBox.localToGlobal(Offset.zero).dx + 2;
            double firstRight = renderBox.localToGlobal(Offset.zero).dx + renderBox.size.width - 2;
            if (i == 0 && lineType == "start") {
              path.moveTo(offset, -height);
              path.lineTo(offset, firstPosition - borderRadius);
              path.quadraticBezierTo(offset, firstPosition, offset + borderRadius, firstPosition);
              path.lineTo(firstLeft, firstPosition);
              lineType = "right";
              gradientColors[0] = Color(0xff33ff77);
              if (currentTime >= firstSchedule.start) {
                gradientColors[1] = firstGradientColor;
              }
              else{
                gradientColors[1] = gradientColors[1] = Theme.of(context).extension<MyColors>()!.lessonCardBorder ?? Color(0xFFffffff);
              }

              roadMap.add(Container(
                  width: width, height: 0, child: CustomPaint(size: Size.zero, painter: CurvePainter(path: path, color: color,
                  gradient: LinearGradient( begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,colors: [gradientColors[0], gradientColors[1]], stops:  [0.9, 1])))));
              gradientColors[0] = firstGradientColor;
            }
            if (curveSizes[i + 1] != null) {

              switch (curveSizes[i+1]?.lessonType){
                case "Лекция":
                  secondGradientColor = Color(0xFFdeff38);
                  break;
                case "Практика":
                  secondGradientColor = Color(0xFF6bbfff);
                  break;
                case "Лабораторная работа":
                  secondGradientColor = Color(0xFFFF4DB8);
                  break;
                case "break":
                  secondGradientColor = Color(0xff33ff77);
                  break;
              }
              final BuildContext? buildContext2 = curveSizes[i + 1]?.key.currentContext;
              if (buildContext2 != null) {
                final renderObject2 = buildContext2.findRenderObject();
                if (renderObject2 != null) {
                  final RenderBox renderBox2 = renderObject2 as RenderBox;
                  var secondSchedule = dayTimes[min(i, dayTimes.length - 1)];
                  double secondPosition = firstPosition + renderBox2.size.height / 2;

                  double secondLeft = renderBox2.localToGlobal(Offset.zero).dx + 2;
                  double secondRight = renderBox2.localToGlobal(Offset.zero).dx + renderBox2.size.width - 2;

                  if (lineType == "right") {
                    lineType = "left";
                    var yOffset = 0.0;
                    if (i == 0) {
                      yOffset = firstPosition;
                      secondPosition += firstHeight / 2;
                    }
                    elementHeight = secondPosition;
                    path.moveTo(firstRight, yOffset);
                    path.lineTo(width - offset - borderRadius, yOffset);
                    path.quadraticBezierTo(width - offset, yOffset, width - offset, yOffset + borderRadius);
                    path.lineTo(width - offset, secondPosition - borderRadius);
                    path.quadraticBezierTo(width - offset, secondPosition, width - offset - borderRadius, secondPosition);
                    path.lineTo(secondRight, secondPosition);
                  } else if (lineType == "left") {
                    elementHeight = secondPosition;
                    lineType = "right";
                    path.moveTo(firstLeft, 0);
                    path.lineTo(offset + borderRadius, 0);
                    path.quadraticBezierTo(offset, 0, offset, borderRadius);
                    path.lineTo(offset, secondPosition - borderRadius);
                    path.quadraticBezierTo(offset, secondPosition, offset + borderRadius, secondPosition);
                    path.lineTo(secondLeft, secondPosition);
                  }
                  if(currentTime>=firstSchedule.end){
                    gradientColors[0] = firstGradientColor;
                    if(currentTime>=secondSchedule.start){
                      gradientColors[1] = secondGradientColor;
                    } else{
                      gradientColors[1] = Theme.of(context).extension<MyColors>()!.lessonCardBorder ?? Color(0xFFffffff);
                    }
                  }
                  else{
                    gradientColors[0] = Theme.of(context).extension<MyColors>()!.lessonCardBorder ?? Color(0xFFffffff);
                  }

                }
              }
            } else if (curveSizes[i + 1] == null) {
              gradientColors[1] = Color(0xff33ff77);
              if (lineType == "left") {
                path.moveTo(firstLeft, 0);
                path.lineTo(offset + borderRadius, 0);
                path.quadraticBezierTo(offset, 0, offset, borderRadius);
                path.lineTo(offset, height);
              } else if (lineType == "right") {
                var yOffset = i == 0 ? firstPosition : 0.0;
                path.moveTo(firstRight, yOffset);
                path.lineTo(width - offset - borderRadius, yOffset);
                path.quadraticBezierTo(width - offset, yOffset, width - offset, yOffset + borderRadius);
                path.lineTo(width - offset, height - renderBox.localToGlobal(Offset.zero).dy - 4 + height);
              }
              if (currentTime >= firstSchedule.end) {
                color = Theme.of(context).extension<MyColors>()!.active ?? Color(0xFFffffff);
              }
              switch (curveSizes[i]?.lessonType){
                case "Лекция":
                  gradientColors[0] = Color(0xFFdeff38);
                  break;
                case "Практика":
                  gradientColors[0] = Color(0xFF6bbfff);
                  break;
                case "Лабораторная работа":
                  gradientColors[0] = Color(0xFFFF4DB8);
                  break;
                case "break":
                  gradientColors[0] = Color(0xff33ff77);
                  break;

              }
            }

            roadMap.add(SizedBox(
                width: width,
                height: elementHeight,

                child: CustomPaint(size: Size.zero, painter: CurvePainter(path: path, color: color,
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,colors: [gradientColors[0], gradientColors[1]], stops:  [0, 0.3])))));
          }
        }
      }
    }
    setState(() {
      roadMap;
    });
  }

  Map<int, contentBlock> curveSizes = {};
  Map<int, contentBlock> curveSizesTemp = {};
  List<Widget> children = [];
  List<GlobalKey> childrenKeys = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DaySchedule>(
        future: getDay(),
        builder: (context, snapshot) {
          children = [];
          childrenKeys = [];
          if (snapshot.hasData) {
            if (snapshot.data!.lessons.isNotEmpty) {
              for (int i = 0; i < snapshot.data!.lessons.length; i++) {
                var lesson = snapshot.data!.lessons[i];
                final key = GlobalKey<StateThisDayLessonCard>();
                childrenKeys.add(key);

                children.add(ThisDayLessonCard(
                  lesson: lesson,
                  id: i,
                ));
                if (i + 1 < snapshot.data!.lessons.length) {
                  var time = Time(lesson.time.end, snapshot.data!.lessons[i + 1].time.start, "перерыв");
                  children.add(ThisDayBreakCard(time: time, id: i));
                }
              }
            }
          } else if (!snapshot.hasData) {
            children = <Widget>[];
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Stack(
              children: [
                Column(
                  children: <Widget>[...roadMap],
                ),
                Container(
                    padding: const EdgeInsets.only(top: 16, left: 32, right: 32),
                    child: Column(
                      children: children,
                    )),
              ],
            ),
          );
        });
  }
}
