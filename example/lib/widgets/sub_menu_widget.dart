import 'package:flutter/material.dart';
import 'package:screen_capture_event_example/ui/pages/main/setting_page.dart';

class SubMenuTile extends StatelessWidget {
  const SubMenuTile(this._subMenu, {Key? key}) : super(key: key);

  final SubMenu _subMenu;

  SubMenu getSubMenu() {
    return _subMenu;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(children: [
        _subMenu.icon,
        const SizedBox(width: 5),
        _subMenu.title,
      ]),
      trailing: const Icon(
        Icons.keyboard_arrow_right,
        color: Colors.white)
    );
  }
}