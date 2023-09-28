import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule/shared/widgets/curve_line.dart';
import 'package:schedule/today/today_model.dart';

class StartLine extends StatefulWidget {
  const StartLine({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StartLine();
}

class _StartLine extends State<StartLine> {
  late TodayModel? value;
  @override
  initState() {
    super.initState();

    init();
  }

  init() async {}

  @override
  void dispose() {
    super.dispose();
  }

  double width = 0.0;
  double height = 0.0;
  double offset = 10;
  double borderRadius = 24;
  Path path = Path();
  changePath(ScheduleBlock firstBlock) {
    height = MediaQuery.of(context).size.height;
    var viewPadding = MediaQuery.of(context).systemGestureInsets.top;
    var params = firstBlock.decor.block;

    double firstPosition = params.offset.dy - viewPadding - 50 + params.size.height/2;
    double firstLeft = params.offset.dx + 2;

    setState(() {
      path.moveTo(offset, -height);

      path.lineTo(offset, firstPosition - borderRadius);
      path.quadraticBezierTo(offset, firstPosition, offset + borderRadius, firstPosition);
      path.lineTo(firstLeft, firstPosition);

      height = firstPosition;
    });

  }
  bool startListener = false;
  @override
  Widget build(BuildContext context) {
    value = context.watch<TodayModel?>();
    if (value != null) {
      width = MediaQuery.of(context).size.width;

      ScheduleBlock block = value!.get(0)!;
      if(startListener == false){
        startListener = true;
        block.decor.addListener(() {
          changePath(block);
        });
      }

      return SizedBox(
        width: width,
        height: height,
        child: CustomPaint(
          size: Size.zero,
          painter: CurvePainter(
            path: path,
            color: block.decor.border,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                TodayColors().get("break", "finished", Theme.of(context).brightness),
                TodayColors().get(block.lessonType, block.status, Theme.of(context).brightness)
              ],
              stops: const [0.7, 1],
            ),
          ),
        ),
      );
    }
    return Container();
  }
}
