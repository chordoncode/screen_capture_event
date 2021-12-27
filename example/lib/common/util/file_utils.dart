import 'dart:io';

class FileUtils {
  // LG
  // /storage/emulated/0/Pictures/Screenshots/Screenshot_20211222-103340.png
  // /storage/emulated/0/DCIM/Camera/Screenshot_20211222-103340.png

  // SAMSUNG
  // /storage/emulated/0/DCIM/Screenshots/.pending-1640741877-Screenshot_20211222-103757_Gallery.jpg
  // /storage/emulated/0/DCIM/Screenshots/.pending-1641176466-Screenshot_20211227-112106_Instagram.jpg

  static Future<FileSystemEntity?> getLastScreenShot(String path) async {

    Directory baseDir = Directory(path.substring(0, path.lastIndexOf("/")));
    String expectedFileName = path.substring(path.lastIndexOf("Screenshot"));

    print("expectedFileName: " + expectedFileName);

    FileSystemEntity fileSystemEntity = baseDir.listSync().last;

    int duration = 100;
    for (int i = 0; i < 6; i++) {
      if (fileSystemEntity.path.contains("/" + expectedFileName)) {
        return fileSystemEntity;
      }

      duration = duration * (i + 1);
      fileSystemEntity = await Future.delayed(Duration(milliseconds: duration), () {
        return baseDir.listSync().last;
      });
    }
    return null;
  }

  static Future<String> getCurrentApp(FileSystemEntity fileSystemEntity) async {
    final String filePath = fileSystemEntity.path;
    return filePath.substring(filePath.lastIndexOf("_") + 1, filePath.lastIndexOf("."));
  }
}