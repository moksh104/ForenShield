import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/logger/app_logger.dart';
import '../../../models/user_model.dart';

/// Secure JWT token and user session storage service using FlutterSecureStorage.
class TokenService {
  static const _accessTokenKey = 'jwt_access_token';
  static const _refreshTokenKey = 'jwt_refresh_token';
  static const _userKey = 'authenticated_user_data';

  final FlutterSecureStorage _secureStorage;

  TokenService({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// Persists the JWT access token securely using FlutterSecureStorage.
  Future<void> saveToken(String token) async {
    AppLogger.d('[TokenService] Saving Access Token securely...');
    await _secureStorage.write(key: _accessTokenKey, value: token);
  }

  /// Retrieves the stored JWT access token from FlutterSecureStorage.
  Future<String?> getToken() async {
    final token = await _secureStorage.read(key: _accessTokenKey);
    AppLogger.d(
      '[TokenService] Get Access Token -> ${token != null && token.isNotEmpty ? 'FOUND' : 'NOT FOUND'}',
    );
    return token;
  }

  /// Persists the JWT refresh token securely using FlutterSecureStorage.
  Future<void> saveRefreshToken(String token) async {
    AppLogger.d('[TokenService] Saving Refresh Token securely...');
    await _secureStorage.write(key: _refreshTokenKey, value: token);
  }

  /// Retrieves the stored JWT refresh token from FlutterSecureStorage.
  Future<String?> getRefreshToken() async {
    final token = await _secureStorage.read(key: _refreshTokenKey);
    AppLogger.d(
      '[TokenService] Get Refresh Token -> ${token != null && token.isNotEmpty ? 'FOUND' : 'NOT FOUND'}',
    );
    return token;
  }

  /// Persists the authenticated [UserModel] securely using FlutterSecureStorage.
  Future<void> saveUser(UserModel user) async {
    AppLogger.d('[TokenService] Saving UserModel securely for: ${user.email}');
    final userJson = jsonEncode(user.toJson());
    await _secureStorage.write(key: _userKey, value: userJson);
  }

  /// Retrieves the stored [UserModel] object from FlutterSecureStorage.
  Future<UserModel?> getUser() async {
    final rawJson = await _secureStorage.read(key: _userKey);
    if (rawJson == null || rawJson.isEmpty) return null;
    try {
      final map = jsonDecode(rawJson) as Map<String, dynamic>;
      return UserModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  /// Removes all stored tokens and user session data from FlutterSecureStorage.
  Future<void> removeToken() async {
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
    await _secureStorage.delete(key: _userKey);
  }

  /// Returns whether a valid access token exists in FlutterSecureStorage.
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
