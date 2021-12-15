import 'dart:io';
import 'package:flutter/material.dart';
import 'package:screen_capture_event_example/common/appversion/app_version.dart';
import 'package:url_launcher/url_launcher.dart';

class AppVersionWidget extends StatelessWidget {
  const AppVersionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "Current Ver.  ${AppVersion.get().version}",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.grey)
              )
            )
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () {
                  _moveToDownloadPage(context);
                },
                child: const Text(
                    "Update to the latest",
                    style: TextStyle(color: Colors.blueAccent, fontSize: 10)
                )
              )
            )
          )
        ])
    );
  }

  void _moveToDownloadPage(context) async {
    String? url; // FIX: update link
    if (Platform.isAndroid) {
      url = "https://play.google.com/store/apps/details?id=com.coupang.mobile";
    } else if (Platform.isIOS) {
      url = "http://apps.apple.com/KR/app/com.coupang.mobile/id11111";
    }

    if (await canLaunch(url!)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('There is something wrong to update. Please try again.'),
              duration: Duration(seconds: 2)
          ));
    }
  }
}