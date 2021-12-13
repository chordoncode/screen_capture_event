import 'package:flutter/material.dart';
import 'package:screen_capture_event_example/common/lifecycle/lifecycle_watcher_state.dart';
import 'package:screen_capture_event_example/common/payment/payment_service.dart';
import 'package:screen_capture_event_example/main.dart';
import 'package:screen_capture_event_example/ui/pages/tag_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends LifecycleWatcherState<HomePage> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
     onTap: () {
     },
     child: PaymentService.instance.isPro() ? const Text('YOU are a PRO user') : const Text('Please subscribe the product!')
    );
  }
}