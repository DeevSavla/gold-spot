import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEnv {
  AppEnv._();

  static const String _apiBaseUrlFromDefine = String.fromEnvironment('API_BASE_URL');

  static String get apiBaseUrl {
    return apiBaseUrlCandidates.first;
  }

  static List<String> get apiBaseUrlCandidates {
    final List<String> candidates = <String>[
      _apiBaseUrlFromDefine,
      dotenv.env['API_BASE_URL']?.trim() ?? '',
      ..._configuredFallbacks,
      ..._platformDefaults,
    ];

    final Set<String> seen = <String>{};
    return candidates
        .map(_normalizeBaseUrl)
        .where((String value) => value.isNotEmpty)
        .where((String value) => seen.add(value))
        .toList(growable: false);
  }

  static List<String> get _configuredFallbacks {
    final String value = dotenv.env['API_FALLBACK_URLS']?.trim() ?? '';
    if (value.isEmpty) {
      return const <String>[];
    }

    return value.split(',').map((String url) => url.trim()).toList(growable: false);
  }

  static List<String> get _platformDefaults {
    if (kIsWeb) {
      return const <String>['http://localhost:5000'];
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return const <String>[
          'http://10.0.2.2:5000',
          'http://localhost:5000',
        ];
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return const <String>['http://localhost:5000'];
      case TargetPlatform.fuchsia:
        return const <String>['http://localhost:5000'];
    }
  }

  static String get apiBaseUrlHint {
    if (_apiBaseUrlFromDefine.trim().isNotEmpty) {
      return 'Configured at build time: $apiBaseUrl';
    }

    final String value = dotenv.env['API_BASE_URL']?.trim() ?? '';
    if (value.isNotEmpty) {
      return 'Configured in .env: ${_normalizeBaseUrl(value)}';
    }

    return 'Using platform default: $apiBaseUrl';
  }

  static Uri uriFor(String baseUrl, String path) {
    final String normalizedBase = _normalizeBaseUrl(baseUrl);
    final String normalizedPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$normalizedBase$normalizedPath');
  }

  static String _normalizeBaseUrl(String value) {
    return value.trim().replaceAll(RegExp(r'/+$'), '');
  }
}
