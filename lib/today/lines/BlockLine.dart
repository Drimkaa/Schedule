import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule/shared/widgets/curve_line.dart';
import 'package:schedule/today/today_model.dart';

import '../../services/time.dart';

class BlockLine extends StatefulWidget {
  const BlockLine({Key? key, required this.id,required this.count,required this.lineDirection}) : super(key: key);
  final int id;
  final int count;
  final String lineDirection;
  @override
  State<StatefulWidget> createState() => _BlockLine();
}

class _BlockLine extends State<BlockLine> {
  final TimeService _timeService = TimeService.instance;
  late final int id;
  late final int count;
  late final String lineDirection;
  late TodayModel? value;
  bool startListener = false;
  @override
  initState() {
    super.initState();

    init();
  }

  init() async {
    id = widget.id;
    count = widget.count;
    lineDirection = widget.lineDirection;
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
  AlignmentGeometry startA =  Alignment.topCenter;
  AlignmentGeometry endA = Alignment.bottomCenter;

  changePath(ScheduleBlock firstBlock, ScheduleBlock secondBlock) {
    width = MediaQuery.of(context).size.width;
    var fBlock = firstBlock.decor.block;
    var sBlock = secondBlock.decor.block;


    double firstRight = fBlock.offset.dx + fBlock.size.width - 2;
    double firstLeft = fBlock.offset.dx + 2;
    double secondPosition = fBlock.size.height / 2 + sBlock.size.height / 2 + 8;
    double secondRight = sBlock.offset.dx + sBlock.size.width - 2;
    double secondLeft = sBlock.offset.dx + 2;
    if (lineDirection == "right") {

      setState(() {
        path = Path();
        path.moveTo(firstRight, 0);
        path.lineTo(width - offset - borderRadius, 0);
        path.quadraticBezierTo(width - offset, 0, width - offset, borderRadius);
        path.lineTo(width - offset, secondPosition - borderRadius);
        path.quadraticBezierTo(width - offset, secondPosition, width - offset - borderRadius, secondPosition);
        path.lineTo(secondRight, secondPosition);
        height = secondPosition;
        startA =  Alignment.topRight;
        endA = Alignment.bottomLeft;
      });
    }
    if (lineDirection == "left") {

      setState(() {
        path = Path();
        path.moveTo(firstLeft, 0);
        path.lineTo(offset + borderRadius, 0);
        path.quadraticBezierTo(offset, 0, offset, borderRadius);
        path.lineTo(offset, secondPosition - borderRadius);
        path.quadraticBezierTo(offset, secondPosition, offset + borderRadius, secondPosition);
        path.lineTo(secondLeft, secondPosition);
        height = secondPosition;
        startA =  Alignment.topRight;
        endA = Alignment.bottomLeft;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    value = context.watch<TodayModel?>();
    if (value != null) {
      width = MediaQuery.of(context).size.width;
        ScheduleBlock fBlock = value!.get(id)!;
        ScheduleBlock sBlock = value!.get(id+1)!;
     
        if(startListener == false){
          startListener = true;
          sBlock.decor.addListener(() {
            changePath(fBlock, sBlock);
          });
        }



          return SizedBox(
            width: width,
            height: height,
            child: CustomPaint(
              size: Size.zero,
              painter: CurvePainter(
                path: path,
                color: fBlock.decor.border,
                gradient:
                LinearGradient(
                    begin: startA,
                    end: endA,
                    colors: [
                      TodayColors().get(fBlock.lessonType, fBlock.status=="active"?"inactive":fBlock.status, Theme.of(context).brightness),
                      TodayColors().get(sBlock.lessonType, sBlock.status, Theme.of(context).brightness)
                      ],
                    stops: [0, 1]),
              ),
            ),
          );
        }


    return Container();
  }
}
