import 'package:flutter/material.dart';
import 'package:screen_capture_event_example/ui/pages/subscription_page.dart';
import 'package:screen_capture_event_example/ui/pages/tag_list_page.dart';
import 'package:screen_capture_event_example/widgets/appbar/custom_app_bar.dart';
import 'dart:io';

import 'home_page.dart';

class Layout extends StatefulWidget {
  final int? currentIndex;

  Layout([this.currentIndex]);

  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout> with WidgetsBindingObserver {

  int _currentIndex = 0;
  final List<BottomNavigationBarItem> _bottomNavigationBarItems = const [
    BottomNavigationBarItem(
      label: 'Home',
      icon: Icon(Icons.home),
    ),
    BottomNavigationBarItem(
      label: 'My Tags',
      icon: Icon(Icons.tag),
    ),
    BottomNavigationBarItem(
      label: 'Subscription',
      icon: Icon(Icons.subscriptions),
    ),
  ];
  final List<Widget> _widgetOptions = [
    const HomePage(),
    const TagListPage(),
    const SubscriptionPage()
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
        appBar: const CustomAppBar(hasActions: true,),
        body: _widgetOptions[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            currentIndex: _currentIndex,
            items: _bottomNavigationBarItems
        )
      )
    );
  }
}