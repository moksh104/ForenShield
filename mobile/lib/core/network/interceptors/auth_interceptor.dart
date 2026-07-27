import 'dart:async';
import 'package:dio/dio.dart';
import '../../storage/storage_service.dart';
import '../../config/api_config.dart';
import '../../constants/api_endpoints.dart';
import '../../logger/app_logger.dart';

/// JWT auth interceptor for the ForenShield PHP REST API.
///
/// - Injects a Bearer token on every non-auth request.
/// - On 401, exchanges the refresh token for a new access token and retries.
/// - Queues multiple requests if a refresh is already in progress.
/// - Prevents infinite retry loops using an `extra` flag.
class AuthInterceptor extends Interceptor {
  final StorageService _storage;

  AuthInterceptor(this._storage);

  // Dedicated Dio instances for specific tasks to avoid interceptor loops
  final Dio _refreshDio = Dio(BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    connectTimeout: ApiConfig.timeout,
    receiveTimeout: ApiConfig.timeout,
    sendTimeout: ApiConfig.timeout,
  ));
  final Dio _retryDio = Dio(BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    connectTimeout: ApiConfig.timeout,
    receiveTimeout: ApiConfig.timeout,
    sendTimeout: ApiConfig.timeout,
  ));

  bool _isRefreshing = false;
  Completer<String?>? _refreshCompleter;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip token injection for auth endpoints
    if (_isAuthEndpoint(options.path)) {
      return handler.next(options);
    }

    final token = await _storage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final requestOptions = err.requestOptions;

    // Handle 401 Unauthorized - attempt token refresh
    // Prevent infinite loops by checking the 'retried' extra flag
    if (err.response?.statusCode == 401 &&
        !_isAuthEndpoint(requestOptions.path) &&
        requestOptions.extra['retried'] != true) {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        return handler.next(err);
      }

      if (_isRefreshing) {
        // Wait for the ongoing refresh to complete
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
        AppLogger.i('Attempting token refresh...');
        final response = await _refreshDio.post(
          ApiEndpoints.refresh,
          data: {'refreshToken': refreshToken},
        );

        if (response.statusCode == 200 &&
            response.data is Map<String, dynamic>) {
          final data = response.data as Map<String, dynamic>;
          final newAccessToken = data['accessToken'] as String?;
          final newRefreshToken = data['refreshToken'] as String?;

          if (newAccessToken != null && newAccessToken.isNotEmpty) {
            await _storage.saveAccessToken(newAccessToken);
            if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
              await _storage.saveRefreshToken(newRefreshToken);
            }

            _refreshCompleter?.complete(newAccessToken);
            return _retryRequest(requestOptions, newAccessToken, handler);
          }
        }

        // Refresh failed (invalid response format or missing token)
        _refreshCompleter?.complete(null);
        await _storage.clearSession();
      } on DioException catch (e) {
        AppLogger.e('Token refresh failed (API Error)', e);
        _refreshCompleter?.complete(null);
        await _storage.clearSession();
      } catch (e, stackTrace) {
        AppLogger.e('Token refresh failed (Unexpected Error)', e, stackTrace);
        _refreshCompleter?.complete(null);
        await _storage.clearSession();
      } finally {
        _isRefreshing = false;
        _refreshCompleter = null;
      }
    } else {
      handler.next(err);
    }
  }

  Future<void> _retryRequest(
    RequestOptions requestOptions,
    String token,
    ErrorInterceptorHandler handler,
  ) async {
    // Mark this request as retried to prevent infinite loops
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
        path.contains(ApiEndpoints.refresh);
  }
}
