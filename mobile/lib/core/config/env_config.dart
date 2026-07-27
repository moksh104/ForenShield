import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuration class for managing environment variables securely.
class EnvConfig {
  EnvConfig._();

  static bool _isInitialized = false;

  /// Returns whether the environment configuration has been initialized.
  static bool get isInitialized => _isInitialized;

  /// Initializes the environment configuration by loading the `.env` file.
  ///
  /// This method is idempotent; multiple calls will not reload the file.
  /// Throws a [StateError] if required variables (like `API_BASE_URL`) are missing.
  static Future<void> init() async {
    if (_isInitialized) return;

    await dotenv.load(fileName: '.env');

    // API configuration has been moved to ApiConfig

    _isInitialized = true;
  }

  static void _ensureInitialized() {
    if (!_isInitialized) {
      throw StateError(
        'EnvConfig has not been initialized. Call EnvConfig.init() first.',
      );
    }
  }


  /// Returns true if the application is running in debug mode.
  static bool get isDebug => kDebugMode;

  /// Returns true if the application is running in a development environment.
  static bool get isDevelopment {
    _ensureInitialized();
    final env = dotenv.env['APP_ENV']?.toLowerCase();
    return env == 'dev' || env == 'development' || isDebug;
  }

  /// Returns true if the application is running in a production environment.
  static bool get isProduction {
    _ensureInitialized();
    final env = dotenv.env['APP_ENV']?.toLowerCase();
    return env == 'prod' || env == 'production' || kReleaseMode;
  }
}
