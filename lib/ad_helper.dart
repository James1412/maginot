import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3496653110999581/7972303832';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3496653110999581/1093719075';
    }
    throw UnsupportedError("Unsupported platform");
  }
}
