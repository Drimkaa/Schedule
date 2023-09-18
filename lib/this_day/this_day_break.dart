
import 'package:flutter/material.dart';
import 'package:schedule/serivces/data/lesson.dart';

import 'package:schedule/shared/widgets/gradient_outline.dart';
import 'package:schedule/theme_config.dart';
import 'package:schedule/this_day/bloc.dart';
import 'package:schedule/this_day/sizeBloc.dart';


class ThisDayBreakCard extends StatefulWidget {
  ThisDayBreakCard({Key? key, required this.time, required this.id}) : super(key: key);
  final Time time;
  final int id;

  @override
  State<StatefulWidget> createState() => _ThisDayBreakCard();
}

class _ThisDayBreakCard extends State<ThisDayBreakCard> {

  late int id;
  late Time time;

  late bool currentLesson = false;

  @override
  void initState() {
    time = widget.time;

    id = widget.id;
    super.initState();
  }



  @override
  void dispose() {
    timeBloc.disposeOn(id * 2+1);

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
        if(renderBox.localToGlobal(Offset.zero) != pos || renderBox.size.width != width){
          sizeBloc.update(id, contentBlock(_key, "break", id * 2+1));
          pos = renderBox.localToGlobal(Offset.zero);
          width = renderBox.size.width;
        }

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => afterFirstLayout(context));
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return StreamBuilder<List<double>>(
          stream: timeBloc.get(id * 2+1),

          builder: (context, snapshot) {

            return  Align(
              alignment: id.isEven? Alignment.centerRight: Alignment.centerLeft,
            child:
                GradientOutlineButton(
                  key:  _key,
                  strokeWidth: 2,
                  radius: 24,
                  gradient: LinearGradient(colors: [
                    Theme.of(context).extension<MyColors>()!.lessonCardBorder ?? Color(0xFFffffff),
                    Theme.of(context).extension<MyColors>()!.active ?? Color(0xFFffffff),
                  ], stops: snapshot.data != null ? snapshot.data!.reversed.map((s) => s=1-s).toList() : [1, 1]),
                  onPressed: () {},
                  child:  Row(
                    mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [

                        SizedBox(
                          width: 50,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(time.start,
                                  style: currentLesson
                                      ? Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).extension<MyColors>()!.active)
                                      : Theme.of(context).textTheme.labelMedium),
                            ],
                          ),
                        ),
                        Container(width: 6),

                                Text("Перерыв", softWrap: true, style: Theme.of(context).textTheme.headlineMedium),



                        Container(width: 6),
                        SizedBox(
                          width: 50,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(time.end,
                                  style: currentLesson
                                      ? Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).extension<MyColors>()!.active)
                                      : Theme.of(context).textTheme.labelMedium),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),



            );
          });
    });
  }
}
