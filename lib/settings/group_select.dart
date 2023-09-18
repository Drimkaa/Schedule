import 'package:flutter/material.dart';
import 'package:schedule/serivces/group.dart';
import 'package:schedule/theme_config.dart';

class GroupSelect extends StatefulWidget {
  const GroupSelect({Key? key}) : super(key: key);
  @override
  State<GroupSelect> createState() => _GroupSelect();
}

/// This is the private State class that goes with MyStatefulWidget.
class _GroupSelect extends State<GroupSelect>  {
 late int value = 1;

  @override
  void initState() {
    getGroup();


    super.initState();
  }
  getGroup() async{
    GroupService groupService = await GroupService.instance;
    setState(()  {
      value = groupService.group;

    });

  }
  changeGroup(int index) async {
    GroupService groupService = await GroupService.instance;
    groupService.group = index;
    setState(()  {
      value = index;

    });
  }
  Widget CustomRadioButton(String text, int index) {
    return OutlinedButton(
        onPressed: () => changeGroup(index),
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
                side: BorderSide(
                  width: 2,
                    color: (value == index) ? Theme.of(context).extension<MyColors>()!.active ?? Colors.black : Theme.of(context).bottomNavigationBarTheme.unselectedItemColor ?? Colors.black),
                borderRadius: BorderRadius.circular(30.0)),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: (value == index) ? Theme.of(context).extension<MyColors>()!.active ?? Colors.black : Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return
      Container(
        padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
    color: Theme.of(context).extension<MyColors>()!.dayCard??Color(0xffffffff),
    borderRadius: BorderRadius.circular(24),
    border: Border.all(color:Theme.of(context).extension<MyColors>()!.dayCardBorder??Color(0xffffffff),width: 2),

    //_stops.map((s) => s + animation!.value).toList())
    ),
    child:
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[

        Text("Ваша группа:",style: Theme.of(context).textTheme.labelMedium,),
        Row(
          children: [
            CustomRadioButton("первая".toUpperCase(), 1),
            Container(width: 16,),
            CustomRadioButton("вторая".toUpperCase(), 2),
          ],
        )


      ],
    ));
  }
}
