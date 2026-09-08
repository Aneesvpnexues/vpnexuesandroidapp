import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  ApiConfig._();

  static String? _overrideUrl;

  static void setOverride(String? url) {
    _overrideUrl = url;
  }

  static String get baseUrl {
    if (_overrideUrl != null) return _overrideUrl!;

    const envUrl = String.fromEnvironment('API_BASE_URL', defaultValue: '');
    if (envUrl.isNotEmpty) return envUrl;

    if (kIsWeb) {
      try {
        final origin = Uri.base.origin;
        if (origin.isNotEmpty) {
          final currentHost = Uri.base.host;
          final isLocalhost = currentHost == 'localhost' || currentHost == '127.0.0.1';
          final port = isLocalhost ? '8080' : (Uri.base.port.toString());
          final scheme = isLocalhost ? 'http' : 'https';
          if (isLocalhost) {
            return '$scheme://$currentHost:8080/api';
          }
          return '$scheme://$currentHost:$port/api';
        }
      } catch (_) {}
      return 'http://localhost:8080/api';
    }

    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080/api';
    }
    return 'http://localhost:8080/api';
  }
}
