import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:grab_tags/ui/pages/main/setting_page.dart';
import 'package:grab_tags/ui/pages/main/tag_list_page.dart';
import 'package:grab_tags/widgets/appbar/custom_app_bar.dart';
import 'dart:io';

class Layout extends StatefulWidget {
  int? currentIndex;
  final bool fromOnBoardingPage;

  Layout({Key? key, this.currentIndex, required this.fromOnBoardingPage}) : super(key: key);

  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout> with WidgetsBindingObserver {

  int _currentIndex = 0;
  final List<SalomonBottomBarItem> _bottomNavigationBarItems = [
    SalomonBottomBarItem(
      title: const Text('My Tags'),
      icon: const Icon(Icons.tag),
      unselectedColor: Colors.white,
      selectedColor: Colors.lightBlueAccent,
    ),
    /*
    SalomonBottomBarItem(
      title: const Text('Subscription'),
      icon: const Icon(Icons.shopping_cart),
      unselectedColor: Colors.white,
      selectedColor: Colors.greenAccent,
    ),

     */
    SalomonBottomBarItem(
      title: const Text('About'),
      icon: const Icon(Icons.info_outline),
      unselectedColor: Colors.white,
      selectedColor: Colors.blueGrey,
    ),
  ];
  final List<Widget> _widgetOptions = [
    const TagListPage(),
    //const SubscriptionPage(),
    const SettingPage()
  ];

  Future<bool> _onBackPressed(BuildContext context) async {
    const int homeIndex = 0;
    if (_currentIndex != homeIndex) {
      setState(() {
        _currentIndex = homeIndex;
      });
      return false;
    }

    showPlatformDialog(
      context: context,
      builder: (context) => BasicDialogAlert(
        title: const Text("Do you want to exit?", style: TextStyle(fontSize: 18, color: Colors.blueGrey)),
        content: const Text("Please re-activate next time. See you later!", style: TextStyle(fontSize: 15, color: Colors.blueGrey)),
        actions: <Widget>[
          BasicDialogAction(
            title: const Text("Cancel"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          BasicDialogAction(
            title: const Text("Exit"),
            onPressed: () {
              exit(0);
            },
          ),
        ],
      ),
    );
    return true;
  }

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.currentIndex??0;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
        appBar: CustomAppBar(hasActions: true, fromOnBoardingPage: widget.fromOnBoardingPage),
        body: _widgetOptions[_currentIndex],
        bottomNavigationBar: SalomonBottomBar(
          margin: const EdgeInsets.only(left:10.0, right: 10.0, top:8.0, bottom:8.0),
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          // dotIndicatorColor: Colors.black,
          items: _bottomNavigationBarItems
        ),
      )
    );
  }
}