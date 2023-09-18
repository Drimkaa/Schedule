import 'package:flutter/material.dart';

import 'package:schedule/serivces/theme.dart';
import 'package:schedule/shared/animated_theme_switcher/animated_theme_switcher.dart';
import 'package:schedule/theme_config.dart';

class SchemeSwitcher extends StatefulWidget {
  const SchemeSwitcher({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SchemeSwitcher();
}
class _SchemeSwitcher extends State<SchemeSwitcher> {

  @override
  void initState() {
    super.initState();
  }

  changeColor(BuildContext context) async{
    final themeSwitcher = ThemeSwitcher.of(context);
    final themeName = ThemeModelInheritedNotifier.of(context)
        .theme.brightness == Brightness.light ? 'dark' : 'light';

    final service = await ThemeService.instance
      ..save(themeName);
    final theme = service.getByName(themeName);
    themeSwitcher.changeTheme(theme: theme,isReversed:themeName=="dark"?true:false);
  }
  @override

  Widget build(BuildContext context) {
    return   Container(
      padding: const EdgeInsets.only(left: 16,right: 16,top: 8,bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).extension<MyColors>()!.dayCard??Color(0xffffffff),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color:Theme.of(context).extension<MyColors>()!.dayCardBorder??Color(0xffffffff),width: 2),

        //_stops.map((s) => s + animation!.value).toList())
      ),
      child:

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Цветовая схема:",style: Theme.of(context).textTheme.labelMedium),
              ThemeSwitcher.switcher(

                builder: (context,switcher) {
                  return IconButton(
                      onPressed: () => changeColor(context)
                      ,
                      icon:
                      Theme.of(context).brightness==Brightness.light?
                      Icon( Icons.sunny, size: 32):
                      Icon( Icons.brightness_2_sharp, size: 32)

                  );
                },
              ),
            ],
          )


    );
  }
}