import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:screen_capture_event_example/common/detector/hashtag_detector.dart';
import 'package:screen_capture_event_example/common/notification/app_notification.dart';
import 'package:screen_capture_event_example/common/payment/payment_service.dart';
import 'package:screen_capture_event_example/common/permission/permission_request.dart';
import 'package:screen_capture_event_example/common/sqlite/hashtag_db.dart';
import 'package:screen_capture_event_example/common/storage/shared_storage_key.dart';
import 'package:screen_capture_event_example/ui/pages/layout.dart';
import 'package:screen_capture_event_example/ui/pages/on_boarding_page.dart';
import 'package:system_alert_window/models/system_window_header.dart';
import 'package:system_alert_window/system_alert_window.dart';
import 'package:bringtoforeground/bringtoforeground.dart';
import 'dart:async';

import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import 'common/storage/shared_storage.dart';

bool activated = false;
bool captured = false;

void main() {
  // FlutterError.onError
  runZonedGuarded(() async {

    WidgetsFlutterBinding.ensureInitialized();

    if (defaultTargetPlatform == TargetPlatform.android) {
      // For play billing library 2.0 on Android, it is mandatory to call
      // [enablePendingPurchases](https://developer.android.com/reference/com/android/billingclient/api/BillingClient.Builder.html#enablependingpurchases)
      // as part of initializing the app.
      InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
    }

    await PaymentService.instance.init();
    await MobileAds.instance.initialize();

    if (!kReleaseMode) {
      RequestConfiguration configuration = RequestConfiguration(testDeviceIds: ["0FFD109BEDA7014C5C6D41BC6A1B0CFD"]);
      MobileAds.instance.updateRequestConfiguration(configuration);
    }

    await SharedStorage().init();

    runApp(MyApp());
    //HashTagDb().init();
  }, (Object error, StackTrace trace) {
    print(error);
    print(trace);
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();

    AppNotification().requestPermissions();
    _requestPermissions();

    //SystemAlertWindow.registerOnClickListener(callBack);
  }

  @override
  void dispose() {
    PaymentService.instance.dispose();
    HashTagDetector().close();
    AppNotification().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PermissionRequest.requestCameraPermission(context);

    bool? doneOnBoarding = SharedStorage.read(SharedStorageKey.doneOnBoarding);
    doneOnBoarding = doneOnBoarding?? false;

    return ScreenUtilInit(
      designSize: const Size(392, 759),
      builder: () => MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey.shade900,
          primarySwatch: Colors.grey,
        ),
        home: doneOnBoarding! ? Layout(fromOnBoardingPage: false) : const OnBoardingPage(),
        debugShowCheckedModeBanner: false,
      )
    );
  }

  Future<void> _requestPermissions() async {
    await SystemAlertWindow.requestPermissions(prefMode: SystemWindowPrefMode.OVERLAY);
  }

  void _showOverlayWindow() {
    SystemWindowHeader header = SystemWindowHeader(
      title: SystemWindowText(text: "ⓒ Code Play Corp.", fontSize: 8, textColor: Colors.black45),
      padding: SystemWindowPadding(left: 12, right: 0, bottom: 0, top: 0), //SystemWindowPadding.setSymmetricPadding(12, 12),
      //subTitle: SystemWindowText(text: "9898989899", fontSize: 14, fontWeight: FontWeight.BOLD, textColor: Colors.black87),
      decoration: SystemWindowDecoration(startColor: Colors.transparent),
    );
    SystemWindowFooter footer = SystemWindowFooter(
        buttons: [
          SystemWindowButton(
            text: SystemWindowText(text: "move to grab_tags tags", fontSize: 10, textColor: Color.fromRGBO(250, 139, 97, 1)),
            tag: "grab_tags",
            //padding: SystemWindowPadding(left: 10, right: 10, bottom: 10, top: 10),
            width: SystemWindowButton.MATCH_PARENT,
            height: 30,
            decoration: SystemWindowDecoration(startColor: Colors.white.withOpacity(0.2), endColor: Colors.white.withOpacity(0.2), borderWidth: 0, borderRadius: 30.0),
          ),
          SystemWindowButton(
            text: SystemWindowText(text: "close", fontSize: 10, textColor: Colors.white),
            tag: "close",
            //padding: SystemWindowPadding(left: 10, right: 10, bottom: 10, top: 10),
            width: SystemWindowButton.WRAP_CONTENT,
            height: 30, //SystemWindowButton.WRAP_CONTENT,
            decoration: SystemWindowDecoration(
                startColor: Color.fromRGBO(250, 139, 97, 1).withOpacity(0.2), endColor: Color.fromRGBO(247, 28, 88, 1).withOpacity(0.2), borderWidth: 0, borderRadius: 30.0),
          )
        ],
        padding: SystemWindowPadding(left: 16, right: 16, bottom: 12),
        //decoration: SystemWindowDecoration(startColor: Colors.white),
        buttonsPosition: ButtonPosition.CENTER);


    SystemAlertWindow.showSystemWindow(
        height: 50,
        header: header,
        footer: footer,
        margin: SystemWindowMargin(left: 8, right: 8, top: 1200, bottom: 0),
        gravity: SystemWindowGravity.TOP,
        notificationTitle: "Incoming Call",
        notificationBody: "+1 646 980 4741",
        prefMode: SystemWindowPrefMode.OVERLAY
    );
    //MoveToBackground.moveTaskToBack();
  }
}


///
/// Whenever a button is clicked, this method will be invoked with a tag (As tag is unique for every button, it helps in identifying the button).
/// You can check for the tag value and perform the relevant action for the button click
///
void callBack(String tag) {
  print(tag);
  switch (tag) {
    case "grab_tags":
    //SystemAlertWindow.closeSystemWindow(prefMode: SystemWindowPrefMode.OVERLAY);
      Bringtoforeground.bringAppToForeground();
      break;
    case "close":
      SystemAlertWindow.closeSystemWindow(prefMode: SystemWindowPrefMode.OVERLAY);
      break;

    default:
      print("OnClick event of $tag");
  }
}
