import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'env_config.dart';

/// Centralized API configuration for platform-aware URLs, timeouts, and headers.
class ApiConfig {
  ApiConfig._();

  static const String _prodBaseUrl = 'https://api.forenshield.com/api/v1';

  /// Returns whether to use offline mock repositories instead of remote REST API endpoints.
  static bool get useMockApi {
    const definedMock = String.fromEnvironment('USE_MOCK_API');
    if (definedMock.isNotEmpty) {
      return definedMock.toLowerCase() == 'true';
    }
    if (EnvConfig.isInitialized) {
      final envMock = dotenv.env['USE_MOCK_API']?.trim().toLowerCase();
      if (envMock != null) {
        return envMock == 'true' || envMock == '1';
      }
    }
    return true;
  }

  /// Resolves the base URL automatically based on the platform and environment.
  static String get baseUrl {
    // 1. Build-time override (--dart-define)
    const definedUrl = String.fromEnvironment('API_BASE_URL');
    if (definedUrl.isNotEmpty) {
      return definedUrl;
    }

    // 2. Production environment check
    if (kReleaseMode || (EnvConfig.isInitialized && EnvConfig.isProduction)) {
      if (EnvConfig.isInitialized) {
        final envUrl = dotenv.env['API_BASE_URL']?.trim();
        if (envUrl != null && envUrl.isNotEmpty) {
          return envUrl;
        }
      }
      return _prodBaseUrl;
    }

    // 3. Custom development URL via .env (if distinct from prod placeholder)
    if (EnvConfig.isInitialized) {
      final envUrl = dotenv.env['API_BASE_URL']?.trim();
      if (envUrl != null && envUrl.isNotEmpty && envUrl != _prodBaseUrl) {
        return envUrl;
      }
    }

    // 4. Local Development Platform Fallbacks
    if (kIsWeb) {
      return 'http://localhost:8000/api/v1';
    }

    if (Platform.isAndroid) {
      // 10.0.2.2 maps to host machine on Android emulator
      return 'http://10.0.2.2:8000/api/v1';
    }

    // iOS Simulator, macOS, Windows, Linux
    return 'http://127.0.0.1:8000/api/v1';
  }

  /// Resolves the API timeout.
  static Duration get timeout {
    if (EnvConfig.isInitialized) {
      final envTimeoutStr = dotenv.env['API_TIMEOUT'];
      if (envTimeoutStr != null) {
        final parsed = int.tryParse(envTimeoutStr);
        if (parsed != null) {
          return Duration(milliseconds: parsed);
        }
      }
    }
    return const Duration(seconds: 30);
  }

  /// Default headers to include in all API requests.
  static Map<String, String> get defaultHeaders => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };
}
