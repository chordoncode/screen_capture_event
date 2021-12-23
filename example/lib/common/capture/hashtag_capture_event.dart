import 'dart:io';

import 'package:bringtoforeground/bringtoforeground.dart';
import 'package:flutter/services.dart';
import 'package:screen_capture_event/screen_capture_event.dart';
import 'package:grab_tags/common/detector/hashtag_detector.dart';
import 'package:grab_tags/common/notification/app_notification.dart';
import 'package:grab_tags/common/util/file_utils.dart';
import 'package:grab_tags/main.dart';
import 'package:grab_tags/model/hashtag.dart';
import 'package:grab_tags/repositories/hashtag_repository.dart';

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
      captured = true;

      HashTag? hashTag = await _findHashTagFromScreenShot(filePath);

      if (hashTag != null) {
        AppNotification().showNotification(-1, 'Grab Tags', 'Copy tags!');
        /*
        _copyToClipboard(hashTag).then((value) =>
         AppNotification().showNotification(-1, 'Grab tags', 'Paste copied tags!')
        );
        */
      } else {
        AppNotification().showNotification(-1, 'Grab Tags', 'No tags. Please retry!');
      }

      //if (!PaymentService.instance.isPro()) {
      Bringtoforeground.bringAppToForeground();
      //}
    });
  }

  Future<HashTag?> _findHashTagFromScreenShot(String path) async {
    FileSystemEntity fileSystemEntity = await FileUtils.getLastScreenShot(path);

    final List<String> tags = await HashTagDetector().extractHashtagFromFilepath(fileSystemEntity.path);
    if (tags.isNotEmpty) {
      final int id = await _save(tags, path);
      return HashTag.buildNew(id, tags);
    }
    return Future.value(null);
  }

  Future<int> _save(List<String> tags, String path) async {
    // save widget.hashTag to local DB.
    return HashTagRepository.save({
      'tags': tags.join(" "),
      'title': 'grabbed from ' +  await FileUtils.getCurrentApp(path)
    });
  }

  Future<void> _copyToClipboard(HashTag hashTag) {
    return Clipboard.setData(ClipboardData(text: hashTag.tags)).then((value) {
      if (Clipboard.getData('text/plain') != hashTag.tags) {
        Future.delayed(const Duration(milliseconds: 3000), () {
          Clipboard.setData(ClipboardData(text: hashTag.tags));
        });
      }

    });
  }
}