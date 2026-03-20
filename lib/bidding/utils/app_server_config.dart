import 'package:flutter/foundation.dart';

class AppServerConfig {
  static String get baseUrl {
    if (kReleaseMode) {
      return 'https://hub.veloxi.fr';
    } else if (kProfileMode) {
      return 'https://hub.veloxi.fr';
    } else {
      return 'https://hub.veloxi.fr';
    }
  }
}
