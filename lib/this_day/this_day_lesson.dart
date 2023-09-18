import 'package:flutter/material.dart';
import 'package:schedule/services/data/lesson.dart';
import 'package:schedule/services/time.dart';
import 'package:schedule/shared/widgets/gradient_outline.dart';
import 'package:schedule/theme_config.dart';
import 'package:schedule/this_day/bloc.dart';
import 'package:schedule/this_day/sizeBloc.dart';

class ThisDayLessonCard extends StatefulWidget {
  ThisDayLessonCard({Key? key, required this.lesson, required this.id}) : super(key: key);
  final LessonSchedule lesson;
  final int id;

  @override
  State<StatefulWidget> createState() => StateThisDayLessonCard();
}

class StateThisDayLessonCard extends State<ThisDayLessonCard> {
  late LessonSchedule lesson;

  late int id;
  List<Widget> children = [];

  late bool currentLesson = false;
  late TimeService timeService;
  @override
  void initState() {
    super.initState();
    init();
  }

  late Future<List<double>> steps = Future.value([1, 1]);
  init() async {
    lesson = widget.lesson;

    id = widget.id;
    timeService = TimeService.instance;
    checkLesson();
    timeBloc.get(id * 2).listen((event) {
      if (event != steps) {
        steps = Future.value(event);
      }
    });
  }

  void checkLesson() async {

    var temp = lesson.time.start.split(":");
    int startTime = int.parse(temp[0]) * 3600 + int.parse(temp[1]) * 60;
    temp = lesson.time.end.split(":");
    int endTime = int.parse(temp[0]) * 3600 + int.parse(temp[1]) * 60;
    int currentTime = timeService.hours * 3600 + timeService.minutes * 60 + timeService.seconds;
    if (currentTime >= startTime && currentTime <= endTime) {
      setState(() {
        currentLesson = true;
      });
    }
  }

  @override
  void dispose() {
    timeBloc.disposeOn(id * 2);

    super.dispose();
  }

  GlobalKey _key = GlobalKey();

  var pos = Offset(0.0, 0.0);
  var width = 0.0;
  void afterFirstLayout(BuildContext context) {
    final BuildContext? buildContext = _key.currentContext;
    if (buildContext != null) {
      final renderObject = buildContext.findRenderObject();
      if (renderObject != null) {
        final RenderBox renderBox = renderObject as RenderBox;
        if (renderBox.localToGlobal(Offset.zero) != pos || renderBox.size.width != width) {
          sizeBloc.update(id, contentBlock(_key, "lesson", id * 2,lesson.objectType));
          pos = renderBox.localToGlobal(Offset.zero);
          width = renderBox.size.width;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => afterFirstLayout(context));
    return  FutureBuilder<List<double>>(
        future: steps,
        builder: (context, snapshot) {
          return Column(
            key: _key,
            children: [
              Padding(padding: EdgeInsets.only(top: 5, right: 5, left: 5, bottom: 5)),
              GradientOutlineButton(
                strokeWidth: 2,
                radius: 24,
                gradient: LinearGradient(colors: [
                  Theme.of(context).extension<MyColors>()!.active ?? Color(0xFFffffff),
                  Theme.of(context).extension<MyColors>()!.lessonCardBorder ?? Color(0xFFffffff)
                ], stops: snapshot.data != null ? snapshot.data!.map((s) => s).toList() : [0, 0]),
                onPressed: () {},
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(lesson.time.start,
                                style: currentLesson
                                    ? Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(color: Theme.of(context).extension<MyColors>()!.active)
                                    : Theme.of(context).textTheme.labelMedium),
                          ],
                        ),
                      ),
                      Container(width: 6),
                      Flexible(
                          fit: FlexFit.tight,
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                Text(lesson.classRoom,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.red)),
                                Text(lesson.objectType.toUpperCase(), style: Theme.of(context).textTheme.labelLarge),
                              ]),
                              Text(lesson.object, softWrap: true, style: Theme.of(context).textTheme.headlineMedium),
                              Text(lesson.teacher, style: Theme.of(context).textTheme.labelLarge)
                            ],
                          )),
                      Container(width: 6),
                      SizedBox(
                        width: 50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(lesson.time.end,
                                style: currentLesson
                                    ? Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(color: Theme.of(context).extension<MyColors>()!.active)
                                    : Theme.of(context).textTheme.labelMedium),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(5)),
            ],
          );
        });
  }
}
