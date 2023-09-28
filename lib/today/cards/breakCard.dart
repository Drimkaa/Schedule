import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:schedule/shared/widgets/gradient_outline.dart';
import 'package:schedule/today/today_model.dart';

import '../../services/time.dart';

class BreakCard extends StatefulWidget {
  const BreakCard({Key? key, required this.id}) : super(key: key);
  final int id;
  @override
  State<StatefulWidget> createState() => _BreakCard();
}

class _BreakCard extends State<BreakCard> {
  final TimeService _timeService = TimeService.instance;

  late final int id;
  final GlobalKey _key = GlobalKey();
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
      WidgetsBinding.instance.addPostFrameCallback((_) => afterFirstLayout(context, block.decor));

      Gradient gradient = block.decor.gradient.linearRev;
      if(startListener == false){
        startListener = true;
        block.decor.gradient.addListener(() {
          setState(() {
            gradient = block.decor.gradient.linearRev;
          });

          print("${block.decor.gradient.steps.toString()}");
        });
      }


      return Align(

        alignment: Alignment.center,
        child: GradientOutlineButton(
          key: _key,
          strokeWidth: 8,
          radius: 32,
          gradient: gradient,
          onPressed: () {},
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      block.timing.startText,
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(color: block.decor.time),
                    ),
                  ],
                ),
              ),
              Container(width: 6),
              Text("Перерыв",
                  softWrap: true, style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: block.decor.title)),
              Container(width: 6),
              SizedBox(
                width: 50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      block.timing.endText,
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(color: block.decor.time),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Container();
  }
}
