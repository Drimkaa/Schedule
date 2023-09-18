import 'package:flutter/cupertino.dart';
import 'package:schedule/settings/group_select.dart';
import 'package:schedule/settings/scheme_switcher.dart';
import 'package:schedule/shared/appbar/appbar_bloc.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsPage();
}
class _SettingsPage extends State<SettingsPage> {

  @override
  initState() {
    super.initState();
    appBloc.updateTitle('Настройки');
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        physics: const BouncingScrollPhysics(),

        padding: const EdgeInsets.only(top: 100, left: 20, right: 20),

        children:  [
          GroupSelect(),
          Container(height: 16),
          SchemeSwitcher(),

        ]);
  }

}