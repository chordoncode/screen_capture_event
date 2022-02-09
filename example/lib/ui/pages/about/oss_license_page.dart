import 'package:flutter/material.dart';
import 'package:grab_hashtag/common/lifecycle/lifecycle_watcher_state.dart';

class OssLicensePage extends StatefulWidget {
  const OssLicensePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OssLicensePageState();
}
class _OssLicensePageState extends LifecycleWatcherState<OssLicensePage> {

  @override
  Widget build(BuildContext context) {
    return LicensePage(
      applicationName: "Grab Hashtag",
      applicationIcon: Image.asset('assets/images/app_icon.png', width: 30),
    );
  }
}