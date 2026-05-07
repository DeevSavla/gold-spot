import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEnv {
  AppEnv._();

  static String get apiBaseUrl {
    final String value = dotenv.env['API_BASE_URL']?.trim() ?? '';
    if (value.isNotEmpty) {
      return value;
    }

    return _defaultApiBaseUrl;
  }

  static String get _defaultApiBaseUrl {
    if (kIsWeb) {
      return 'http://localhost:5000';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:5000';
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return 'http://localhost:5000';
      case TargetPlatform.fuchsia:
        return 'http://localhost:5000';
    }
  }

  static String get apiBaseUrlHint {
    final String value = dotenv.env['API_BASE_URL']?.trim() ?? '';
    if (value.isEmpty) {
      return 'Using platform default: $apiBaseUrl';
    }
    return 'Configured in .env: $value';
  }
}
