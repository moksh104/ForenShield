import 'package:shared_preferences/shared_preferences.dart';

/// Service for local storage using SharedPreferences
class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _preferences;

  StorageService._();

  factory StorageService() {
    _instance ??= StorageService._();
    return _instance!;
  }

  static Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get _prefs {
    if (_preferences == null) {
      throw Exception('StorageService not initialized. Call init() first.');
    }
    return _preferences!;
  }

  Future<bool> write(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  Future<String?> read(String key) async {
    return _prefs.getString(key);
  }

  Future<bool> writeInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  Future<int?> readInt(String key) async {
    return _prefs.getInt(key);
  }

  Future<bool> writeBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  Future<bool?> readBool(String key) async {
    return _prefs.getBool(key);
  }

  Future<bool> delete(String key) async {
    return await _prefs.remove(key);
  }

  Future<bool> deleteAll() async {
    return await _prefs.clear();
  }

  Future<bool> containsKey(String key) async {
    return _prefs.containsKey(key);
  }
}
