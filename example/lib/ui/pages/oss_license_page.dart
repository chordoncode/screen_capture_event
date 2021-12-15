import 'package:flutter/material.dart';
import 'package:screen_capture_event_example/common/lifecycle/lifecycle_watcher_state.dart';

class OssLicensePage extends StatefulWidget {
  const OssLicensePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OssLicensePageState();
}
class _OssLicensePageState extends LifecycleWatcherState<OssLicensePage> {

  @override
  Widget build(BuildContext context) {
    return const LicensePage();
  }
}