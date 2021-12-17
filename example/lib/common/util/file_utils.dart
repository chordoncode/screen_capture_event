import 'dart:io';

import 'package:screen_capture_event_example/common/payment/payment_service.dart';

class FileUtils {
  static Directory BASE_DIR = Directory('/storage/emulated/0/DCIM/Screenshots');

  static FileSystemEntity getLastScreenShot() {
    return BASE_DIR.listSync().last;
  }

  static bool isTarget(final String path) {
    if (!PaymentService.instance.isPro()) {
      return path.toLowerCase().contains("instagram");
    }
   return true;
  }

  static String getCurrentApp() {
    final String path = getLastScreenShot().path;
    return path.substring(path.lastIndexOf("_") + 1, path.lastIndexOf("."));
  }
}