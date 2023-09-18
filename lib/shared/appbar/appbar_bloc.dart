import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/widgets.dart';
import 'package:schedule/shared/appbar/appbar.dart';

final appBloc = AppPropertiesBloc();

class AppPropertiesBloc{
  final _title = BehaviorSubject<Widget>();

  Stream<Widget> get titleStream => _title.stream;

  updateTitle(String pageName, [Function? func]){
    switch (pageName){
      case "Настройки":
        _title.sink.add(SettingsAppBar());
        break;
      case "Сегодня":
        _title.sink.add(TodayAppBar());
        break;
      case "Расписание":
        _title.sink.add(ScheduleAppBar(press:func));
        break;
    }

  }

  dispose() {
    _title.close();
  }
}