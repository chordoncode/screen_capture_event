import 'package:flutter/material.dart';
import 'package:screen_capture_event_example/common/notification/app_notification.dart';
import 'package:screen_capture_event_example/common/payment/payment_service.dart';
import 'package:screen_capture_event_example/common/util/file_utils.dart';
import 'package:screen_capture_event_example/main.dart';
import 'package:screen_capture_event_example/ui/pages/interstitial_ad_page.dart';
import 'package:screen_capture_event_example/ui/pages/snapshot_page.dart';

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

    final bool isTarget = FileUtils.isTarget(FileUtils.getLastScreenShot().path);
    if (isTarget && captured) {
      captured = false;

      if (!PaymentService.instance.isPro()) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        await Navigator.push(context,
            MaterialPageRoute(builder: (context) => const InterstitialAdPage()));
      }

      AppNotification().cancelAllNotifications();
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