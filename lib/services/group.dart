

import 'package:shared_preferences/shared_preferences.dart';

class GroupService {
  GroupService._();

  static GroupService? _instance;
  static late SharedPreferences prefs;
  static Future<GroupService> get instance async {
    if (_instance == null) {
      prefs = await SharedPreferences.getInstance();

      _instance = GroupService._();
    }
    return _instance!;
  }

  int get subgroup {
    int? gr = prefs.getInt('scheduleSubgroup');
    if(gr!=null) {
      return gr;
    } else{
      return 1;
    }
  }
  set subgroup(int value){
    prefs.setInt('scheduleSubgroup',value);
  }
  String get group {

    String? gr = prefs.getString('scheduleGroup');

    if(gr!=null) {
      return gr;
    } else{
      return "21-СТ";
    }
  }
  set group(String value){
    prefs.setString('scheduleGroup',value);
  }

}