import 'package:flutter/material.dart';
import 'package:screen_capture_event_example/ui/pages/oss_license_page.dart';
import 'package:screen_capture_event_example/widgets/app_version_widget.dart';
import 'package:screen_capture_event_example/widgets/footer.dart';
import 'package:screen_capture_event_example/widgets/sub_menu_widget.dart';

class SubMenu {
  Icon icon;
  String title;
  Widget widget;

  SubMenu({required this.icon, required this.title, required this.widget});

}

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingPageState();
}
class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    const double icon_size = 25;

    List<dynamic> _subMenus = [
      SubMenuTile(SubMenu(icon: const Icon(Icons.mode_edit_outline_outlined, size: icon_size, color: Colors.white), title: "Open source license", widget: const OssLicensePage())),
      const AppVersionWidget(),
      const FooterWidget()
    ];

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: _subMenus.length,
              itemBuilder: (context, index) {
                if (_subMenus[index] is SubMenuTile) {
                  return GestureDetector(
                      onTap: () {
                        SubMenuTile subMenuTile = _subMenus[index] as SubMenuTile;
                        Navigator.push(context, MaterialPageRoute(builder: (context) => subMenuTile.getSubMenu().widget));
                      },
                      child: _subMenus[index]
                  );
                } else {
                  return _subMenus[index];
                }
              },
              separatorBuilder: (context, index) {
                return Divider(
                  thickness: (_subMenus[index] is SubMenuTile) ? 1 : 0,
                  color: const Color(0xffeeeeee)
                );
              },
            )
          ),
        ]
      )
    );
  }
}