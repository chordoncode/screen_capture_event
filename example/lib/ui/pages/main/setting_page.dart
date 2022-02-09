import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:grab_hashtag/common/ad/banner_ad_widget.dart';
import 'package:grab_hashtag/common/lifecycle/lifecycle_watcher_state.dart';
import 'package:grab_hashtag/common/payment/payment_service.dart';
import 'package:grab_hashtag/ui/pages/about/oss_license_page.dart';
import 'package:grab_hashtag/ui/pages/about/subscription_page.dart';
import 'package:grab_hashtag/widgets/app_version_widget.dart';
import 'package:grab_hashtag/widgets/sub_menu_widget.dart';
import 'package:grab_hashtag/widgets/subscribe_promotion.dart';

class SubMenu {
  Icon icon;
  Widget title;
  Widget widget;

  SubMenu({required this.icon, required this.title, required this.widget});

}

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingPageState();
}
class _SettingPageState extends LifecycleWatcherState<SettingPage> {
  @override
  Widget build(BuildContext context) {
    const double icon_size = 25;

    List<dynamic> _subMenus = [
      //fixme: 사업자 등록 후 주석 제거
      /*
      SubMenuTile(SubMenu(
        icon: const Icon(Icons.shopping_cart, size: icon_size, color: Colors.white),
        title: Row(
          children: [
            Badge(
              shape: BadgeShape.square,
              badgeColor: Colors.pinkAccent,
              borderRadius: BorderRadius.circular(8),
              badgeContent: const Text(
                  'PRO', style: TextStyle(fontSize: 8, color: Colors.white)),
            ),
            const SizedBox(width: 5,),
            const Text("Subscription", style: TextStyle(fontSize: 14, color: Colors.white)),
          ],
        ),
        widget: const SubscriptionPage())),
       */
      SubMenuTile(SubMenu(
        icon: const Icon(Icons.mode_edit_outline_outlined, size: icon_size, color: Colors.white),
        title: const Text("Open source license", style: TextStyle(fontSize: 14, color: Colors.white)),
        widget: const OssLicensePage())),
      const AppVersionWidget(),
      //const FooterWidget()
    ];

    return Scaffold(
      body: Column(
        children: _buildWidgets(_subMenus)
      )
    );
  }

  List<Widget> _buildWidgets(List<dynamic> subMenus) {
    List<Widget> widgets = [];
    widgets.add(const SizedBox(height: 10,));

    if (!PaymentService.instance.isPro()) {
      widgets.add(const BannerAdWidget());
      widgets.add(const SizedBox(height: 20,));
      //fixme: 사업자 등록 후 주석 제거
      //widgets.add(const SubscribePromotion(clickable: true));
      //widgets.add(const SizedBox(height: 20,));
    }
    widgets.add(
      Expanded(
        child: ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: subMenus.length,
          itemBuilder: (context, index) {
            if (subMenus[index] is SubMenuTile) {
              return GestureDetector(
                  onTap: () {
                    SubMenuTile subMenuTile = subMenus[index] as SubMenuTile;
                    Navigator.push(context, MaterialPageRoute(builder: (context) => subMenuTile.getSubMenu().widget));
                  },
                  child: subMenus[index]
              );
            } else {
              return subMenus[index];
            }
          },
          separatorBuilder: (context, index) {
            return const Divider(
                thickness: 0,
            );
          },
        )
      )
    );
    return widgets;
  }
}