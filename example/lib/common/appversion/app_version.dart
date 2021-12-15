import 'package:package_info_plus/package_info_plus.dart';

class AppVersion {
  static PackageInfo _PACKAGE_INFO = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  static PackageInfo get() {
    return _PACKAGE_INFO;
  }

  static Future<void> initPackageInfo() async {
    PackageInfo.fromPlatform().then((value) => _PACKAGE_INFO = value);
  }
}