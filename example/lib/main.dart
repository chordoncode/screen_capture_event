import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grab_tags/common/appversion/app_version.dart';
import 'package:grab_tags/common/detector/hashtag_detector.dart';
import 'package:grab_tags/common/notification/app_notification.dart';
import 'package:grab_tags/common/payment/payment_service.dart';
import 'package:grab_tags/common/permission/permission_request.dart';
import 'package:grab_tags/common/storage/shared_storage_key.dart';
import 'package:grab_tags/ui/pages/main/layout.dart';
import 'package:bringtoforeground/bringtoforeground.dart';
import 'dart:async';

import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:system_alert_window/system_alert_window.dart';

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

    /*
    if (!kReleaseMode) {
      RequestConfiguration configuration = RequestConfiguration(testDeviceIds: ["0FFD109BEDA7014C5C6D41BC6A1B0CFD"]);
      MobileAds.instance.updateRequestConfiguration(configuration);
    }
     */

    await SharedStorage().init();

    runApp(MyApp());

    AppVersion.initPackageInfo(); // It should be called after runApp().
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
    PermissionRequest.requestStoragePermission(context);

    bool? doneOnBoarding = SharedStorage.read(SharedStorageKey.doneOnBoarding);
    doneOnBoarding = doneOnBoarding?? false;

    return ScreenUtilInit(
      designSize: const Size(392, 759),
      builder: () => MaterialApp(
        title: "Grab Tags",
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey.shade900,
          primarySwatch: Colors.blueGrey,
        ),
        home: Layout(fromOnBoardingPage: false), //doneOnBoarding! ? Layout(fromOnBoardingPage: false) : const OnBoardingPage(),
        debugShowCheckedModeBanner: false,
      )
    );
  }

  Future<void> _requestPermissions() async {
    await SystemAlertWindow.requestPermissions(prefMode: SystemWindowPrefMode.OVERLAY);
  }
}
