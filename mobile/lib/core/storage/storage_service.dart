import 'package:shared_preferences/shared_preferences.dart';
import '../constants/storage_keys.dart';

/// A production-grade service for local storage using [SharedPreferences].
///
/// Provides both low-level generic accessors and high-level semantic helpers
/// tied directly to [StorageKeys]. Designed to be lightweight and compatible
/// with Riverpod dependency injection.
///
/// ⚠️ SECURITY CONSIDERATIONS & MIGRATION PATH:
/// - Currently uses [SharedPreferences] for key-value persistence.
/// - Unencrypted SharedPreferences is suitable for user settings (Theme, Locale, Onboarding).
/// - Storing raw JWT Access & Refresh Tokens in SharedPreferences presents security risks
///   on rooted/jailbroken devices as the underlying XML/plist files are stored unencrypted.
///
/// 🔒 Migration Path to `flutter_secure_storage`:
/// When adding production-grade secure credential storage:
/// 1. Add `flutter_secure_storage` to `pubspec.yaml`.
/// 2. Instantiate `FlutterSecureStorage` inside `StorageService`.
/// 3. Redirect `saveAccessToken`, `getAccessToken`, `saveRefreshToken`, `getRefreshToken`,
///    and `clearSession` to read/write via `FlutterSecureStorage` (iOS Keychain / Android EncryptedSharedPreferences).
/// 4. Keep non-sensitive preferences (Theme, Locale, Onboarding) stored in `SharedPreferences`.
class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _preferences;

  StorageService._();

  /// Returns the singleton instance of [StorageService].
  factory StorageService() {
    _instance ??= StorageService._();
    return _instance!;
  }

  /// Initializes the underlying [SharedPreferences] instance.
  ///
  /// This method is idempotent; multiple calls will not re-initialize unless
  /// [reload] is called explicitly.
  static Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  /// Indicates whether the storage service has been initialized.
  static bool get isInitialized => _preferences != null;

  /// Reloads the preferences from disk, useful for syncing across isolates or updates.
  Future<void> reload() async {
    if (_preferences != null) {
      await _preferences!.reload();
    } else {
      await init();
    }
  }

  SharedPreferences get _prefs {
    if (_preferences == null) {
      throw StateError('StorageService not initialized. Call init() first.');
    }
    return _preferences!;
  }

  // ── Generic APIs ────────────────────────────────────────────────────────────

  /// Writes a [String] value to storage.
  Future<bool> write(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  /// Reads a [String] value from storage.
  Future<String?> read(String key) async {
    return _prefs.getString(key);
  }

  /// Writes an [int] value to storage.
  Future<bool> writeInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  /// Reads an [int] value from storage.
  Future<int?> readInt(String key) async {
    return _prefs.getInt(key);
  }

  /// Writes a [bool] value to storage.
  Future<bool> writeBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  /// Reads a [bool] value from storage.
  Future<bool?> readBool(String key) async {
    return _prefs.getBool(key);
  }

  /// Writes a [double] value to storage.
  Future<bool> writeDouble(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }

  /// Reads a [double] value from storage.
  Future<double?> readDouble(String key) async {
    return _prefs.getDouble(key);
  }

  /// Writes a [List<String>] value to storage.
  Future<bool> writeStringList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  /// Reads a [List<String>] value from storage.
  Future<List<String>?> readStringList(String key) async {
    return _prefs.getStringList(key);
  }

  /// Deletes a specific key from storage.
  Future<bool> delete(String key) async {
    return await _prefs.remove(key);
  }

  /// Clears all keys from storage.
  Future<bool> deleteAll() async {
    return await _prefs.clear();
  }

  /// Checks if a key exists in storage.
  Future<bool> containsKey(String key) async {
    return _prefs.containsKey(key);
  }

  // ── Authentication Helpers ──────────────────────────────────────────────────

  /// Saves the JWT access token.
  Future<bool> saveAccessToken(String token) async {
    await writeBool(StorageKeys.isLoggedIn, true);
    return write(StorageKeys.authAccessToken, token);
  }

  /// Retrieves the JWT access token.
  Future<String?> getAccessToken() async {
    return read(StorageKeys.authAccessToken);
  }

  /// Checks if an access token exists.
  Future<bool> hasAccessToken() async {
    return containsKey(StorageKeys.authAccessToken);
  }

  /// Saves the JWT refresh token.
  Future<bool> saveRefreshToken(String token) async {
    return write(StorageKeys.authRefreshToken, token);
  }

  /// Retrieves the JWT refresh token.
  Future<String?> getRefreshToken() async {
    return read(StorageKeys.authRefreshToken);
  }

  /// Checks if a refresh token exists.
  Future<bool> hasRefreshToken() async {
    return containsKey(StorageKeys.authRefreshToken);
  }

  /// Checks if the user is considered logged in.
  Future<bool> isLoggedIn() async {
    final flag = await readBool(StorageKeys.isLoggedIn);
    if (flag != null) return flag;
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Clears all authentication-related keys from storage.
  Future<void> clearSession() async {
    await writeBool(StorageKeys.isLoggedIn, false);
    await delete(StorageKeys.isLoggedIn);
    await delete(StorageKeys.authAccessToken);
    await delete(StorageKeys.authRefreshToken);
    await delete(StorageKeys.userId);
    await delete(StorageKeys.userEmail);
  }

  // ── Preferences Helpers ─────────────────────────────────────────────────────

  /// Saves the selected theme mode (e.g. 'dark', 'light', 'system').
  Future<bool> saveThemeMode(String mode) async {
    return write(StorageKeys.themeMode, mode);
  }

  /// Retrieves the selected theme mode.
  Future<String?> getThemeMode() async {
    return read(StorageKeys.themeMode);
  }

  /// Saves the preferred locale code (e.g. 'en', 'fr').
  Future<bool> saveLocale(String locale) async {
    return write(StorageKeys.preferredLocale, locale);
  }

  /// Retrieves the preferred locale code.
  Future<String?> getLocale() async {
    return read(StorageKeys.preferredLocale);
  }

  // ── Navigation Helpers ──────────────────────────────────────────────────────

  /// Saves the last active route for deep-link restoration.
  Future<bool> saveLastRoute(String route) async {
    return write(StorageKeys.lastRoute, route);
  }

  /// Retrieves the last active route.
  Future<String?> getLastRoute() async {
    return read(StorageKeys.lastRoute);
  }

  // ── Onboarding Helpers ──────────────────────────────────────────────────────

  /// Marks the onboarding flow as complete.
  Future<bool> setOnboardingComplete() async {
    return writeBool(StorageKeys.hasSeenOnboarding, true);
  }

  /// Checks if the user has completed the onboarding flow.
  Future<bool> hasSeenOnboarding() async {
    return await readBool(StorageKeys.hasSeenOnboarding) ?? false;
  }
}
