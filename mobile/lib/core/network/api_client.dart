import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../config/api_config.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/retry_interceptor.dart';
import '../storage/storage_service.dart';

/// Dio HTTP client for the ForenShield PHP REST API.
///
/// Configured with:
/// - Base URL from [ApiConfig.baseUrl] (injected via `--dart-define` or .env)
/// - [AuthInterceptor] — attaches the JWT Bearer token to all non-auth requests
///   and automatically retries after a 401 by exchanging the refresh token.
/// - [ErrorInterceptor] — normalises all Dio errors into [ApiException].
/// - [PrettyDioLogger] — human-readable request/response log (dev builds only).
class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(_baseOptions);
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
      // PrettyDioLogger is only active in debug builds.
      // Release builds never log request/response bodies.
      if (kDebugMode)
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          error: true,
          compact: true,
        ),
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
    return _dio.post<T>(
      path,
      data: data,
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
    );
  }
}
