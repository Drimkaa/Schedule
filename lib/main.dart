import 'package:schedule/navigation/navigation.dart';
import 'package:schedule/shared/animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';


import 'package:flutter/services.dart';

import 'package:schedule/services/theme.dart';
void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();


  final themeService = await ThemeService.instance;

  var initTheme = themeService.initial;
  runApp(MyApp(theme: initTheme));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key,required this.theme}) : super(key: key);
  final ThemeData theme;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(

      initTheme: theme,
      builder: (context, theme) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays:  [SystemUiOverlay.top, SystemUiOverlay.bottom]);
        return MaterialApp(

          title: 'Расписание НГТУ',
          debugShowCheckedModeBanner: false,
          theme: theme,
          home:   const NavigationWrapper(),
        );
      },
    );

  }
}