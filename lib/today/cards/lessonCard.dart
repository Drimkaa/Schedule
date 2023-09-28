import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule/services/data/lesson.dart';
import 'package:schedule/shared/widgets/gradient_outline.dart';
import 'package:schedule/theme_config.dart';
import 'package:schedule/today/today_model.dart';

import '../../services/time.dart';

class LessonCard extends StatefulWidget {
  const LessonCard({Key? key, required this.id}) : super(key: key);
  final int id;
  @override
  State<StatefulWidget> createState() => _LessonCard();
}

class _LessonCard extends State<LessonCard> {
  final TimeService _timeService = TimeService.instance;
  late  LessonSchedule lesson;
  late final int id;
  final GlobalKey _key= GlobalKey();
  @override
  initState() {
    super.initState();
    init();
  }

  init() async {
    id = widget.id;

  }

  @override
  void dispose() {

    super.dispose();
  }
  BlockSize sizes = BlockSize();
  afterFirstLayout(BuildContext context, BlockDecoration decoration) {
    final BuildContext? buildContext = _key.currentContext;
    if (buildContext != null) {
      final renderObject = buildContext.findRenderObject();
      if (renderObject != null) {
        final RenderBox renderBox = renderObject as RenderBox;

        sizes.size = renderBox.size;
        sizes.offset = renderBox.localToGlobal(Offset.zero);
        decoration.block = sizes;

      }
    }
  }
  bool startListener = false;
  @override
  Widget build(BuildContext context) {
    final value = context.watch<TodayModel?>();
    if (value != null) {
      ScheduleBlock block = value.get(id)!;
      if (block.type == "lesson" ) {
        lesson = block.lesson;
        WidgetsBinding.instance.addPostFrameCallback((_) => afterFirstLayout(context, block.decor));
        Gradient gradient = block.decor.gradient.linear;
        if(startListener == false){
          startListener = true;
          block.decor.gradient.addListener(() {
            setState(() {
              gradient = block.decor.gradient.linear;
            });

            print("${block.decor.gradient.steps.toString()}");
          });
        }
        return Column(
          key: _key,
          children: [

            GradientOutlineButton(
              strokeWidth: 8,
              radius: 32,
              gradient: gradient,
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
                          Text(
                            lesson.time.start,
                            style: Theme.of(context).textTheme.labelMedium!.copyWith(color: block.decor.time),
                          ),
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
                              Text(
                                lesson.classRoom,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.red),
                              ),
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
                          Text(
                            lesson.time.end,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }
    }
    return Container();
  }


}
