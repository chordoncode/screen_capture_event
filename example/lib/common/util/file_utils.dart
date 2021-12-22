import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:screen_capture_event_example/common/permission/permission_request.dart';

class FileUtils {
  // LG
  // /storage/emulated/0/Pictures/Screenshots/Screenshot_20211222-103340.png
  // /storage/emulated/0/DCIM/Camera/Screenshot_20211222-103340.png

  // SAMSUNG
  // /storage/emulated/0/DCIM/Screenshots/.pending-1640741877-Screenshot_20211222-103757_Gallery.jpg

  static String _lastScreenShotPath = "";

  static Future<FileSystemEntity> getLastScreenShot(String path) async {

    Directory baseDir = Directory(path.substring(0, path.lastIndexOf("/")));
    FileSystemEntity fileSystemEntity = baseDir.listSync().last;

    for (int i = 0; i < 3; i++) {
      if (fileSystemEntity.path == _lastScreenShotPath) {
        fileSystemEntity = await Future.delayed(const Duration(milliseconds: 100), () {
          return baseDir.listSync().last;
        });
        break;
      }
    }
    _lastScreenShotPath = fileSystemEntity.path;
    return fileSystemEntity;
  }

  static Future<String> getCurrentApp(String path) async {
    FileSystemEntity fileSystemEntity = await getLastScreenShot(path);
    final String filePath = fileSystemEntity.path;
    return filePath.substring(filePath.lastIndexOf("_") + 1, filePath.lastIndexOf("."));
  }
}