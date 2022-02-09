import 'package:flutter/material.dart';
import 'package:grab_hashtag/main.dart';

abstract class LifecycleWatcherState<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResumed();
        break;
      case AppLifecycleState.inactive:
        onPaused();
        break;
      case AppLifecycleState.paused:
        onInactive();
        break;
      case AppLifecycleState.detached:
        onDetached();
        break;
    }
  }

  Future<void> onResumed() async {

    if (captured) {
      captured = false;
      //AppNotification().cancelAllNotifications();
    }
    setState(() {
    });
  }
  void onPaused() {
  }
  void onInactive() {
  }
  void onDetached() {
  }
}