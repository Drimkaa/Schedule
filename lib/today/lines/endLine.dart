import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule/shared/widgets/curve_line.dart';
import 'package:schedule/today/today_model.dart';

class EndLine extends StatefulWidget {
  const EndLine({Key? key ,required this.lineDirection}) : super(key: key);

  final String lineDirection;

  @override
  State<StatefulWidget> createState() => _EndLine();
}

class _EndLine extends State<EndLine> {
  late TodayModel? value;
  late  String lineDecoration;
  @override
  initState() {
    super.initState();

    init();
  }

  init() async {
    lineDecoration = widget.lineDirection;
  }

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
    var params = firstBlock.decor.block;
    double firstPosition = params.offset.dy - 4;
    double firstLeft = params.offset.dx + 2;
    double firstRight = params.offset.dx + params.size.width - 2;
    if(lineDecoration == "left"){
      setState(() {
        path = Path();
        path.moveTo(firstLeft, 0);
        path.lineTo(offset + borderRadius, 0);
        path.quadraticBezierTo(offset, 0, offset, borderRadius);
        path.lineTo(offset,  height - firstPosition + height);
      });
    }
    else{
      setState(() {
        path = Path();
        path.moveTo(firstRight, 0);
        path.lineTo(width - offset - borderRadius, 0);
        path.quadraticBezierTo(width - offset, 0, width - offset, 0 + borderRadius);
        path.lineTo(width - offset, height - firstPosition + height);
      });
    }


  }
  bool startListener = false;
  @override
  Widget build(BuildContext context) {
    value = context.watch<TodayModel?>();
    if (value != null) {
      width = MediaQuery.of(context).size.width;

      ScheduleBlock block = value!.get(value!.length-1)!;
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
                TodayColors().get(block.lessonType, block.status, Theme.of(context).brightness),
                TodayColors().get("break", block.status, Theme.of(context).brightness)

              ],
              stops: const [0, 0.1],
            ),
          ),
        ),
      );
    }
    return Container();
  }
}
