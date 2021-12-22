import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionRequest {
  static Future<bool> requestStoragePermission(BuildContext context) async {
    PermissionStatus status = await Permission.storage.request();

    if(!status.isGranted) { // 허용이 안된 경우
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text("Please check access permission."),
              actions: [
                FlatButton(
                    onPressed: () {
                      openAppSettings(); // 앱 설정으로 이동
                    },
                    child: const Text('Open app settings.')),
              ],
            );
          });
      return false;
    }
    return true;
  }
}