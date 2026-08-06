import 'dart:async';
import 'package:dio/dio.dart';
import '../../config/api_config.dart';
import '../../constants/api_endpoints.dart';
import '../../logger/app_logger.dart';
import '../../storage/storage_service.dart';
import '../../../features/authentication/services/token_service.dart';

/// JWT auth interceptor for the ForenShield PHP REST API using Dio and FlutterSecureStorage.
///
/// Features:
/// - Injects the Bearer access token from [TokenService] (FlutterSecureStorage) into headers for non-auth requests.
/// - On 401 Unauthorized responses, automatically sends a `POST /refresh_token.php` request to renew the token.
/// - Stores the new access token (and refresh token, if returned) securely via [TokenService].
/// - Retries the original failed HTTP request with the new access token.
/// - If token refresh fails (or refresh token is expired/invalid), clears secure storage and triggers session cleanup.
class AuthInterceptor extends Interceptor {
  final StorageService _storage;
  final TokenService _tokenService;
  final void Function()? _onSessionExpired;

  AuthInterceptor(
    this._storage, {
    TokenService? tokenService,
    this._onSessionExpired,
  })  : _tokenService = tokenService ?? TokenService();

  final Dio _refreshDio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.timeout,
      receiveTimeout: ApiConfig.timeout,
      sendTimeout: ApiConfig.timeout,
    ),
  );

  final Dio _retryDio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.timeout,
      receiveTimeout: ApiConfig.timeout,
      sendTimeout: ApiConfig.timeout,
    ),
  );

  bool _isRefreshing = false;
  Completer<String?>? _refreshCompleter;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip token injection for public auth endpoints
    if (_isAuthEndpoint(options.path)) {
      return handler.next(options);
    }

    final token = await _tokenService.getToken() ?? await _storage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final requestOptions = err.requestOptions;

    // Intercept 401 Unauthorized errors on non-auth requests
    if (err.response?.statusCode == 401 &&
        !_isAuthEndpoint(requestOptions.path) &&
        requestOptions.extra['retried'] != true) {
      
      final refreshToken = await _tokenService.getRefreshToken() ?? await _storage.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        await _handleSessionExpired();
        return handler.next(err);
      }

      if (_isRefreshing) {
        final newToken = await _refreshCompleter?.future;
        if (newToken != null) {
          return _retryRequest(requestOptions, newToken, handler);
        } else {
          return handler.next(err);
        }
      }

      _isRefreshing = true;
      _refreshCompleter = Completer<String?>();

      try {
        AppLogger.i('Attempting automatic JWT refresh via POST /refresh_token.php...');

        final response = await _refreshDio.post(
          ApiEndpoints.refresh,
          data: {'refreshToken': refreshToken},
        );

        if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
          final data = response.data as Map<String, dynamic>;
          final newAccessToken = data['accessToken'] as String?;
          final newRefreshToken = data['refreshToken'] as String?;

          if (newAccessToken != null && newAccessToken.isNotEmpty) {
            // Save newly issued tokens securely via FlutterSecureStorage & StorageService
            await _tokenService.saveToken(newAccessToken);
            await _storage.saveAccessToken(newAccessToken);

            if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
              await _tokenService.saveRefreshToken(newRefreshToken);
              await _storage.saveRefreshToken(newRefreshToken);
            }

            AppLogger.i('Token refresh successful. Replacing expired token.');
            _refreshCompleter?.complete(newAccessToken);
            return _retryRequest(requestOptions, newAccessToken, handler);
          }
        }

        // Refresh token failed or returned unexpected payload
        _refreshCompleter?.complete(null);
        await _handleSessionExpired();
        return handler.next(err);

      } catch (e, stackTrace) {
        AppLogger.e('Automatic token refresh failed', e, stackTrace);
        _refreshCompleter?.complete(null);
        await _handleSessionExpired();
        return handler.next(err);
      } finally {
        _isRefreshing = false;
        _refreshCompleter = null;
      }
    } else {
      handler.next(err);
    }
  }

  Future<void> _handleSessionExpired() async {
    AppLogger.w('Refresh token expired or invalid. Clearing session and redirecting to login.');
    await _tokenService.removeToken();
    await _storage.clearSession();
    _onSessionExpired?.call();
  }

  Future<void> _retryRequest(
    RequestOptions requestOptions,
    String token,
    ErrorInterceptorHandler handler,
  ) async {
    requestOptions.extra['retried'] = true;
    requestOptions.headers['Authorization'] = 'Bearer $token';

    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
      extra: requestOptions.extra,
    );

    try {
      final response = await _retryDio.request<dynamic>(
        requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options,
      );
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    } catch (e) {
      handler.reject(DioException(requestOptions: requestOptions, error: e));
    }
  }

  bool _isAuthEndpoint(String path) {
    return path.contains(ApiEndpoints.login) ||
        path.contains(ApiEndpoints.register) ||
        path.contains(ApiEndpoints.refresh) ||
        path.contains(ApiEndpoints.verifyOtp) ||
        path.contains(ApiEndpoints.forgotPassword);
  }
}
