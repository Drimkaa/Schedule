import 'package:flutter/material.dart';
import 'package:schedule/services/group.dart';
import 'package:schedule/theme_config.dart';

class GroupSelect extends StatefulWidget {
  const GroupSelect({Key? key}) : super(key: key);
  @override
  State<GroupSelect> createState() => _GroupSelect();
}

/// This is the private State class that goes with MyStatefulWidget.
class _GroupSelect extends State<GroupSelect> {
  late int value = 0;
  late GroupService _groupService;
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    _groupService = await GroupService.instance;
    setState(() {
      value = _groupService.subgroup;
    });
  }

  changeGroup(int index) async {
    _groupService.subgroup = index;
    setState(() {
      value = index;
    });
  }

  Widget CustomRadioButton(String text, int index) {
    Color color = ((value == index)
            ? Theme.of(context).extension<MyColors>()!.active
            : Theme.of(context).bottomNavigationBarTheme.unselectedItemColor) ??
        Colors.black;
    return OutlinedButton(
        onPressed: () => changeGroup(index),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          side: BorderSide(width: 1.5, color: color),
        ),
        child: Text(text,  style: Theme.of(context).textTheme.labelSmall!.copyWith( color: color)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 16,top:8,bottom: 8,right: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).extension<MyColors>()!.dayCard ?? Color(0xffffffff),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Theme.of(context).extension<MyColors>()!.dayCardBorder ?? Color(0xffffffff), width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Ваша группа:",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Wrap(
              direction: Axis.horizontal,
              spacing: 16, // <-- Spacing between children
              children: [
                CustomRadioButton("первая".toUpperCase(), 1),
                CustomRadioButton("вторая".toUpperCase(), 2),
              ],
            )
          ],
        ));
  }
}
