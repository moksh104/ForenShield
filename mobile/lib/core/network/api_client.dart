import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import '../config/api_config.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/retry_interceptor.dart';
import 'interceptors/sanitized_logging_interceptor.dart';
import 'transformers/safe_json_transformer.dart';
import '../storage/storage_service.dart';

/// Dio HTTP client for the ForenShield PHP REST API.
///
/// Configured with:
/// - Base URL from [ApiConfig.baseUrl] (injected via `--dart-define` or .env)
/// - [SafeJsonTransformer] — strips unexpected BOM/whitespace before parsing JSON.
/// - [AuthInterceptor] — attaches the JWT Bearer token to all non-auth requests
///   and automatically retries after a 401 by exchanging the refresh token.
/// - [RetryInterceptor] — retries transient network errors for idempotent requests.
/// - [ErrorInterceptor] — normalises all Dio errors into [ApiException].
/// - [SanitizedLoggingInterceptor] — masks sensitive tokens and credentials (dev builds only).
class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(_baseOptions);
    _dio.transformer = SafeJsonTransformer();
    _setupInterceptors();
  }

  BaseOptions get _baseOptions => BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    connectTimeout: ApiConfig.timeout,
    receiveTimeout: ApiConfig.timeout,
    sendTimeout: ApiConfig.timeout,
    headers: ApiConfig.defaultHeaders,
    validateStatus: (status) {
      // Typically we want Dio to throw for anything >= 300,
      // and our ErrorInterceptor will map it into an AppException.
      return status != null && status >= 200 && status < 300;
    },
  );

  void _setupInterceptors() {
    _dio.interceptors.addAll([
      AuthInterceptor(StorageService()),
      RetryInterceptor(dio: _dio),
      ErrorInterceptor(),
      // Redacts passwords, JWTs, and refresh tokens from debug logs
      if (kDebugMode) SanitizedLoggingInterceptor(),
    ]);
  }

  Dio get dio => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.get<T>(path, queryParameters: queryParameters);
  }

  Future<Response<T>> post<T>(String path, {dynamic data}) async {
    return _dio.post<T>(path, data: data);
  }

  Future<Response<T>> put<T>(String path, {dynamic data}) async {
    return _dio.put<T>(path, data: data);
  }

  Future<Response<T>> delete<T>(String path) async {
    return _dio.delete<T>(path);
  }

  Future<Response<T>> patch<T>(String path, {dynamic data}) async {
    return _dio.patch<T>(path, data: data);
  }

  Future<Response<T>> postMultipart<T>(
    String path, {
    required FormData data,
  }) async {
    return _dio.post<T>(path, data: data);
  }
}
