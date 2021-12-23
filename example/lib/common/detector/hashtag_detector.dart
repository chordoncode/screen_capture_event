import 'dart:io';

import 'package:google_ml_kit_for_korean/google_ml_kit_for_korean.dart';
import 'package:image/image.dart' as img;

class HashTagDetector {
  static RegExp regexp = RegExp(r"(#+[a-zA-Z0-9(_)ㄱ-ㅎㅏ-ㅣ가-힣]{1,})");

  static final HashTagDetector _instance = HashTagDetector._internal();

  factory HashTagDetector() {
    return _instance;
  }

  final TextDetector _textDetector = GoogleMlKit.vision.textDetector();

  HashTagDetector._internal();

  void close() {
    _textDetector.close();
  }

  Future<List<String>> extractHashtagFromFilepath(String filePath) async {
    /*
    final file = await File(filePath).readAsBytes();
    final img.Image? capturedImage = img.decodeImage(file);
    final img.Image? orientedImage = img.bakeOrientation(capturedImage!);
    final finalResultFile = await File(filePath).writeAsBytes(img.encodeJpg(orientedImage!));
     */
    var inputImage = InputImage.fromFilePath(filePath);

    final RecognisedText recognisedText = await _textDetector.processImage(inputImage);
    return _extractedHashtagList(recognisedText.text);
  }

  List<String> _extractedHashtagList(String hashtagText) {
    var allMatches = regexp.allMatches(hashtagText);
    return allMatches.map((m) => m.group(0)!).toSet().toList();
  }
}