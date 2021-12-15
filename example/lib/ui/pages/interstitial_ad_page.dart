import 'package:flutter/material.dart';
import 'package:screen_capture_event_example/common/ad/interstitial_ad_widget.dart';
import 'package:screen_capture_event_example/common/lifecycle/lifecycle_watcher_state.dart';

class InterstitialAdPage extends StatefulWidget {
  const InterstitialAdPage({Key? key}) : super(key: key);

  @override
  _InterstitialAdPageState createState() => _InterstitialAdPageState();
}

class _InterstitialAdPageState extends LifecycleWatcherState<InterstitialAdPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance!
        .addPostFrameCallback((_) => _executeAfterWholeBuildProcess(context));

    return const Scaffold(
      backgroundColor: Colors.black,
    );
  }

  _executeAfterWholeBuildProcess(BuildContext context) {
    final InterstitialAdWidget _interstitialAdWidget = InterstitialAdWidget();
    _interstitialAdWidget.init();
    Navigator.pop(context);
  }
}