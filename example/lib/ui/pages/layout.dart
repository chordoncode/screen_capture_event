import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:screen_capture_event_example/ui/pages/setting_page.dart';
import 'package:screen_capture_event_example/ui/pages/subscription_page.dart';
import 'package:screen_capture_event_example/ui/pages/tag_list_page.dart';
import 'package:screen_capture_event_example/widgets/appbar/custom_app_bar.dart';
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
    SalomonBottomBarItem(
      title: const Text('Subscription'),
      icon: const Icon(Icons.subscriptions),
      unselectedColor: Colors.white,
      selectedColor: Colors.greenAccent,
    ),
    SalomonBottomBarItem(
      title: const Text('Setting'),
      icon: const Icon(Icons.settings),
      unselectedColor: Colors.white,
      selectedColor: Colors.blueGrey,
    ),
  ];
  final List<Widget> _widgetOptions = [
    const TagListPage(),
    const SubscriptionPage(),
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
    exit(0);
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
          margin: const EdgeInsets.only(left:50.0, right: 50.0, top:8.0, bottom:8.0),
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