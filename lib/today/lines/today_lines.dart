
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule/today/lines/BlockLine.dart';
import 'package:schedule/today/lines/endLine.dart';
import 'package:schedule/today/lines/startLine.dart';
import 'package:schedule/today/today_model.dart';

import '../../services/time.dart';

class TodayLines extends StatefulWidget {
  const TodayLines({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TodayLines();
}

class _TodayLines extends State<TodayLines> {
  final TimeService _timeService = TimeService.instance;

  @override
  initState() {
    super.initState();
    init();
  }

  init() async {

  }
  @override void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final value = context.watch<TodayModel?>();
    if(value!=null){
      List<Widget> children = [];
      if(value.length>0){
        children.add(StartLine());
        String lineDirection = "right";
        for(int i = 0; i < value.length-1;i++){
          children.add(BlockLine(id: i,count: value.length,lineDirection:lineDirection));
          if(lineDirection == "right"){
            lineDirection = "left";
          }
          else{
            lineDirection = "right";
          }
        }
        children.add(EndLine(lineDirection: lineDirection));
        return Column(
          children: children,
        );
      }
    }
    return Container();
  }
}
