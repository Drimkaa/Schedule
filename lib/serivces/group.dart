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

  int get group {
    int? gr = prefs.getInt('scheduleGroup');
    if(gr!=null) {
      return gr;
    } else{
      return 1;
    }
  }
  set group(int value){
    prefs.setInt('scheduleGroup',value);

  }

}