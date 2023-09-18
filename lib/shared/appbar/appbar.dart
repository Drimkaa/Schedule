import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schedule/serivces/schedule.dart';

Widget SettingsAppBar = AppBar(
  title: Text("Настройки"),
);

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
                color: Color(0xFF00FFCC),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            Container(width: 8),
            Text(
              "Практика".toUpperCase(),
              style: TextStyle(color: Color(0xFF00FFCC), fontWeight: FontWeight.w700, fontSize: 12),
            )
          ],
        ),
        Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Color(0xff345cef),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            Container(width: 8),
            Text(
              "перерыв".toUpperCase(),
              style: TextStyle(color: Color(0xff345cef), fontWeight: FontWeight.w700, fontSize: 12),
            )
          ],
        ),
        Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Color(0xFFD0FF00),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            Container(width: 8),
            Text(
              "Лекция".toUpperCase(),
              style: TextStyle(color: Color(0xFFD0FF00), fontWeight: FontWeight.w700, fontSize: 12),
            )
          ],
        ),
        Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Color(0xFFFF00A1),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            Container(width: 8),
            Text(
              "лаба".toUpperCase(),
              style: TextStyle(color: Color(0xFFFF00A1), fontWeight: FontWeight.w700, fontSize: 12),
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
  var weekNumber = 0;
  var weekType = "";
  @override
  initState() {
    super.initState();
    init();
  }

  init() async {
    scheduleService = await ScheduleService.instance;
    setState(() {
      weekNumber = scheduleService.weekNumber;
      weekType = scheduleService.weekType;
    });
  }



  lastWeek() {
    setState(() {
      weekNumber -= 1;
      weekType = scheduleService.weekTypeByNumber(weekNumber);
    });
    if (widget.press != null) {
      widget.press!(weekNumber);
    }
  }

  nextWeek() {
    setState(() {
      weekNumber += 1;
      weekType = scheduleService.weekTypeByNumber(weekNumber);
    });
    if (widget.press != null) {
      widget.press!(weekNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(weekType, style: Theme.of(context).textTheme.headlineMedium),
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
          Text(weekNumber.toString() + " неделя", style: Theme.of(context).textTheme.headlineMedium),
          Container(
            width: 16,
          ),
          IconButton(
            onPressed: () => nextWeek(),
            icon: const Icon(Icons.chevron_right_rounded),
            splashRadius: 30,
          ),
        ],
      )
    ]));
  }
}
