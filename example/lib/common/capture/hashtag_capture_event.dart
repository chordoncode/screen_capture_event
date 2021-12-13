import 'package:bringtoforeground/bringtoforeground.dart';
import 'package:screen_capture_event/screen_capture_event.dart';
import 'package:screen_capture_event_example/common/util/file_utils.dart';
import 'package:screen_capture_event_example/main.dart';

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
        Bringtoforeground.bringAppToForeground();
        captured = true;
      }
    });
  }
}