
import 'package:schedule/shared/animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:schedule/schedule/schedule_page.dart';
import 'package:schedule/settings/settings_page.dart';
import 'package:schedule/shared/appbar/appbar_bloc.dart';
import 'package:schedule/this_day/this_day.dart';

class NavigationWrapper extends StatefulWidget {
  const NavigationWrapper({super.key});
  static const String id = 'main_screen';

  @override
  createState() => _NavigationWrapper();
}

class _NavigationWrapper extends State<NavigationWrapper>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 2));
    FlutterNativeSplash.remove();
  }

  int _selectedIndex = 0;
  int _lastIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
     SchedulePage(),
     ThisDayPage(),
     SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _lastIndex = _selectedIndex;
      _selectedIndex = index;
    });
  }

  void _moveBack() {
    if (_lastIndex != _selectedIndex) {
      setState(() {
        _selectedIndex = _lastIndex;
        return;
      });
    }
  }
  @override void dispose() {
    appBloc.dispose();
    super.dispose();
  }
  Widget icon = const Icon(Icons.light_mode_outlined);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(

        onWillPop: () async {
          _moveBack;
          return false;
        },
        child: ThemeSwitchingArea(

            child: Scaffold(
              key: Key("fdf"),
              appBar:
              PreferredSize(
                  preferredSize: Size.fromHeight(50.0), // here the desired height
                  child: StreamBuilder<Widget>(
                      stream: appBloc.titleStream,
                      initialData: AppBar(title: Text("Главная")),
                      builder: (context, snapshot) {
                        Widget returned = AppBar(title: Text("Главная"));
                        if(snapshot.hasData && snapshot.data != null){
                          returned = snapshot.data!;

                        }
                        return returned;
                      }
                  ),
              ),

          body:
          _widgetOptions.elementAt(_selectedIndex),
              extendBody: true,

          bottomNavigationBar: Theme(

              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
              ),
              child: Container(
                  decoration:  BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0)),

                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                    child: BottomNavigationBar(
                      showSelectedLabels: true,
                      showUnselectedLabels: false,
                      type: BottomNavigationBarType.fixed,
                      selectedFontSize: 14,
                      unselectedFontSize: 14,
                      currentIndex: _selectedIndex,
                      onTap: _onItemTapped,
                      items: const <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          icon: Icon(
                            Icons.weekend,
                            size: 40,
                          ),
                          label: 'Расписание',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(
                            Icons.event_note,
                            size: 40,
                          ),
                          label: 'Сегодня',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(
                            Icons.settings,
                            size: 40,
                          ),
                          label: 'Настройки',
                        )
                      ],
                    ),
                  ))),
        )));
  }
}
