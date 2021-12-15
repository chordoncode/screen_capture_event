import 'dart:io';

import 'package:bringtoforeground/bringtoforeground.dart';
import 'package:flutter/services.dart';
import 'package:screen_capture_event/screen_capture_event.dart';
import 'package:screen_capture_event_example/common/detector/hashtag_detector.dart';
import 'package:screen_capture_event_example/common/notification/app_notification.dart';
import 'package:screen_capture_event_example/common/payment/payment_service.dart';
import 'package:screen_capture_event_example/common/util/file_utils.dart';
import 'package:screen_capture_event_example/main.dart';
import 'package:screen_capture_event_example/model/hashtag.dart';
import 'package:screen_capture_event_example/repositories/hashtag_repository.dart';

class HashTagCaptureEvent {
  static final HashTagCaptureEvent _instance = HashTagCaptureEvent._internal();

  factory HashTagCaptureEvent() {
    return _instance;
  }

  final ScreenCaptureEvent _screenCaptureEvent = ScreenCaptureEvent();
  ScreenCaptureEvent get screenCaptureEvent => _screenCaptureEvent;

  HashTagCaptureEvent._internal() {
    _addScreenShotListener();
  }

  void _addScreenShotListener() {
    _screenCaptureEvent.addScreenShotListener((filePath) async {

      if (FileUtils.isTarget(filePath)) {
        //Bringtoforeground.bringAppToForeground();
        captured = true;

        if (!PaymentService.instance.isPro()) {
          Bringtoforeground.bringAppToForeground();
        }

        HashTag? hashTag = await _findHashTagFromScreenShot();
        if (hashTag != null) {
          _copyToClipboard(hashTag);
          AppNotification().showNotification(-1, 'Grab tags', 'Paste copied tags!');


        } else {
          AppNotification().showNotification(-1, 'Grab tags', 'No tags. Please retry!');
        }
      }
    });
  }

  Future<HashTag?> _findHashTagFromScreenShot() async {
    FileSystemEntity fileSystemEntity = FileUtils.getLastScreenShot();

    final List<String> tags = await HashTagDetector().extractHashtagFromFilepath(fileSystemEntity.path);
    if (tags.isNotEmpty) {
      final int id = await _save(tags);
      return HashTag.buildNew(id, tags);
    }
    return Future.value(null);
  }

  Future<int> _save(List<String> tags) async {
    // save widget.hashTag to local DB.
    return HashTagRepository.save({
      'tags': tags.join(" ")
    });
  }

  Future<void> _copyToClipboard(HashTag hashTag) {
    return Future.delayed(const Duration(milliseconds: 3000), () {
      return Clipboard.setData(ClipboardData(text: hashTag.tags));
    });
  }
}