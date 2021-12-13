import 'dart:io';

class FileUtils {
  static Directory BASE_DIR = Directory('/storage/emulated/0/DCIM/Screenshots');

  static FileSystemEntity getLastScreenShot() {
    return BASE_DIR.listSync().last;
  }

  static bool isTarget(final String path) {
     return path.contains("Instagram");
  }
}