import 'package:google_ml_kit_for_korean/google_ml_kit_for_korean.dart';

class HashTagDetector {
  static final HashTagDetector _instance = HashTagDetector._internal();

  factory HashTagDetector() {
    return _instance;
  }

  final TextDetector _textDetector = GoogleMlKit.vision.textDetector();
  TextDetector get textDetector => _textDetector;

  HashTagDetector._internal();
}