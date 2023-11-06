import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule/today/cards/breakCard.dart';
import 'package:schedule/today/cards/lessonCard.dart';
import 'package:schedule/today/today_model.dart';

import '../../services/time.dart';

class TodayBlocks extends StatefulWidget {
  const TodayBlocks({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TodayBlocks();
}

class _TodayBlocks extends State<TodayBlocks> {
  final TimeService _timeService = TimeService.instance;
  late Timer timer;
  bool condition = false;

  @override
  initState() {
    super.initState();
    init();
  }

  init() async {}
  @override
  void dispose() {
    condition = false;
    super.dispose();
  }

  startTimer(TodayModel today) {

    if (!condition) {
      condition = true;
      timerFunction(today);
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        timerFunction(today);
      });
    }
  }

  cancelTimer() {
    timer.cancel();
  }

  timerFunction(TodayModel today) {
    if (today != null) {
      int daySeconds = _timeService.currentDayTime;
      for (int i = 0; i < today.length; i++) {
        ScheduleBlock block = today.get(i)!;
        if (block.timing.start <= daySeconds && block.timing.end >= daySeconds) {
          if (block.status != "active") {
            setState(() {
              block.status = "active";
              block.decor.gradient.colors = [
                TodayColors().get(block.lessonType, "active", Theme.of(context).brightness),
                TodayColors().get(block.lessonType, "inactive", Theme.of(context).brightness)
              ];

            });
          }
          var duration = (block.timing.end - block.timing.start);
          var offset = (daySeconds - block.timing.start);
          var position = min(offset / duration, 1.0);
          block.decor.gradient.steps = [position, min(position + 0.1, 1.0)];
        } else if (block.timing.end <= daySeconds) {
          if (block.status != "finished") {
            setState(() {
              block.decor.gradient.steps = [1];
              block.decor.gradient.colors = [TodayColors().get(block.lessonType, "finished", Theme.of(context).brightness)];
              block.status = "finished";
            });
          }
        } else {
          if (block.status != "inactive") {
            setState(() {
              block.decor.gradient.steps = [1];
              block.decor.gradient.colors = [TodayColors().get(block.lessonType, "inactive", Theme.of(context).brightness)];
              block.status = "inactive";
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final value = context.watch<TodayModel?>();


    List<Widget> children = [];
    if (value != null) {
      if(value.length > 0){
        for (int i = 0; i < value.length; i++) {
          ScheduleBlock block = value.get(i)!;
          if (block.type == "lesson") {
            children.add(LessonCard(id: i));
          }
          if (block.type == "break") {
            children.add(BreakCard(id: i));
          }
        }
        startTimer(value);

        return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: children,
          
        );
      }
      else{
        return Container(
          height: MediaQuery.of(context).size.height / 2,
          child: Align(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("🤙",style: Theme.of(context).textTheme.displayLarge),
                  Text("чилл!!", style: Theme.of(context).textTheme.displayMedium),
                ],
              )),
        );
      }

    }
    return Container();
  }
}
