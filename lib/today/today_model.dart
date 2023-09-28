import 'dart:math';

import 'package:flutter/material.dart';
import 'package:schedule/services/data/lesson.dart';

class BlockDecorationGradient with ChangeNotifier {
  late List<double> _steps = [0, 0];
  late List<Color> _colors = [Colors.white, Colors.white];
  List<double> get steps => _steps;
  List<Color> get colors => _colors;
  set steps(List<double> steps) {
    _steps = steps;
    notifyListeners();
  }

  set colors(List<Color> colors) {
    _colors = colors;
    notifyListeners();
  }

  Gradient get linear {
    if (_steps.length == _colors.length) {
      return LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: _colors, stops: _steps);
    } else {
      var minLen = min(_steps.length, _colors.length);
      return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: _colors.sublist(0, minLen),
          stops: _steps.sublist(0, minLen));
    }
  }
  Gradient get linearRev {
    if (_steps.length == _colors.length) {
      return LinearGradient(begin: Alignment.centerRight, end: Alignment.centerLeft, colors: _colors, stops: _steps);
    } else {
      var minLen = min(_steps.length, _colors.length);
      return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: _colors.sublist(0, minLen),
          stops: _steps.sublist(0, minLen));
    }
  }
}

class BlockSize with ChangeNotifier {
  late Size size = const Size(0, 0);
  late Offset offset = const Offset(0, 0);
}

class BlockDecoration with ChangeNotifier {
  BlockDecorationGradient gradient = BlockDecorationGradient();
  final BlockSize _block = BlockSize();
  BlockSize get block => _block;
  set block(BlockSize block) {
    if(_block.size != block.size && _block.offset != block.offset){
      _block.size = block.size;
      _block.offset = block.offset;
      print("${_block.offset.toString()} ${_block.size.toString()} ");
      notifyListeners();
    }
  }

  Color _border = Colors.white;
  Color _time = Colors.white;
  Color _title = Colors.white;
  Color _label = Colors.white;
  Color _auditory = Colors.white;
  Color get border => _border;
  Color get time => _time;
  Color get title => _title;
  Color get label => _label;
  Color get auditory => _auditory;
  set border(Color color) {
    if (_border != color) {
      _border = color;
      notifyListeners();
    }
  }

  set time(Color color) {
    if (_time != color) {
      _time = color;
      notifyListeners();
    }
  }

  set title(Color color) {
    if (_title != color) {
      _title = color;
      notifyListeners();
    }
  }

  set label(Color color) {
    if (_label != color) {
      _label = color;
      notifyListeners();
    }
  }

  set auditory(Color color) {
    if (_auditory != color) {
      _auditory = color;
      notifyListeners();
    }
  }
}

class Timing {
  int start;
  int end;
  String startText;
  String endText;
  Timing(this.startText, this.endText, this.start, this.end);
}

class ScheduleBlock with ChangeNotifier {
  final int id;
  final String type; //"lesson", "break"
  final String lessonType; // "lecture", "practice", "lab", "break"
  late String _status = " "; // "active" "finished" "inactive"
  String get status => _status;
  set status(String st){
    if(_status != st){
      _status = st;
      notifyListeners();
    }

  }
  final Timing timing;
  late LessonSchedule lesson;
  BlockDecoration decor = BlockDecoration();
  ScheduleBlock(this.type, this.lessonType, this.timing, this.id);
}

class TodayModel with ChangeNotifier {
  int length = 0;
  late Map<int, ScheduleBlock> _map = {};
  Map<int, ScheduleBlock> get map => _map;
  set map(Map<int, ScheduleBlock> map) {
    _map = map;
    length = map.length;
    notifyListeners();
  }

  add(ScheduleBlock block) {
    length += 1;
    _map[block.id] = block;
    notifyListeners();
  }

  ScheduleBlock? get(int id) {
    return _map[id];
  }
}

class TodayColors {
  Color get(String type, String status, Brightness brightness) {
    if(brightness ==Brightness.light){
      if(status == "inactive"){
        return const Color(0xffa2a2a2) ;
      }
      switch (type) {
        case "Лекция":
          return Colors.black;
        case "Практика":
          return Colors.black ;
        case "Лабораторная работа":
          return Colors.black;
        case "break":
          return Colors.black;
      }
    } else{
      if(status == "inactive"){
        return const Color(0xFF282828) ;
      }
      switch (type) {
        case "Лекция":
          return const Color(0xFFdeff38);
        case "Практика":
          return const Color(0xFF6bbfff) ;
        case "Лабораторная работа":
          return const Color(0xFFFF4DB8);
        case "break":
          return const Color(0xff33ff77);
      }
    }

    return Colors.white;
  }
}
