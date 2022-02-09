import 'dart:io';

import 'package:bringtoforeground/bringtoforeground.dart';
import 'package:flutter/services.dart';
import 'package:screen_capture_event/screen_capture_event.dart';
import 'package:grab_hashtag/common/detector/hashtag_detector.dart';
import 'package:grab_hashtag/common/notification/app_notification.dart';
import 'package:grab_hashtag/common/util/file_utils.dart';
import 'package:grab_hashtag/main.dart';
import 'package:grab_hashtag/model/hashtag.dart';
import 'package:grab_hashtag/repositories/hashtag_repository.dart';

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

      FileSystemEntity? fileSystemEntity = await FileUtils.getLastScreenShot(filePath);
      if (fileSystemEntity == null) {
        AppNotification().showNotification(-1, 'Grab Hashtag', 'Failed. Please retry!');
        return;
      }
      HashTag? hashTag = await _findHashTagFromScreenShot(fileSystemEntity!);

      if (hashTag != null) {
        AppNotification().showNotification(-1, 'Grab Hashtag', 'Copy tags!');
        /*
        _copyToClipboard(hashTag).then((value) =>
         AppNotification().showNotification(-1, 'Grab Hashtag', 'Paste copied tags!')
        );
        */
      } else {
        AppNotification().showNotification(-1, 'Grab Hashtag', 'No tags. Please retry!');
      }

      //if (!PaymentService.instance.isPro()) {
      Bringtoforeground.bringAppToForeground();
      //}
    });
  }

  Future<HashTag?> _findHashTagFromScreenShot(FileSystemEntity fileSystemEntity) async {
    final List<String> tags = await HashTagDetector().extractHashtagFromFilepath(fileSystemEntity.path);
    if (tags.isNotEmpty) {
      final int id = await _save(tags, fileSystemEntity);
      return HashTag.buildNew(id, tags);
    }
    return Future.value(null);
  }

  Future<int> _save(List<String> tags, FileSystemEntity fileSystemEntity) async {
    // save widget.hashTag to local DB.
    return HashTagRepository.save({
      'tags': tags.join(" "),
      'title': 'grabbed from ' +  await FileUtils.getCurrentApp(fileSystemEntity)
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