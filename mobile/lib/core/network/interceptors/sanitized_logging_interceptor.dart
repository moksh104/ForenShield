import 'dart:convert';
import 'package:dio/dio.dart';
import '../../logger/app_logger.dart';

/// Interceptor that logs network traffic in debug mode while strictly masking sensitive data
/// such as passwords, JWT access tokens, refresh tokens, and FCM tokens.
class SanitizedLoggingInterceptor extends Interceptor {
  static const Set<String> _sensitiveKeys = {
    'password',
    'current_password',
    'new_password',
    'accessToken',
    'access_token',
    'refreshToken',
    'refresh_token',
    'fcm_token',
    'session_token',
    'token',
    'otp',
    'otpCode',
    'otp_code',
  };

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final sanitizedHeaders = Map<String, dynamic>.from(options.headers);
    if (sanitizedHeaders.containsKey('Authorization')) {
      sanitizedHeaders['Authorization'] = 'Bearer [REDACTED]';
    }

    final sanitizedData = _sanitize(options.data);
    AppLogger.d(
      '--> ${options.method.toUpperCase()} ${options.uri}\n'
      'Headers: $sanitizedHeaders\n'
      'Body: $sanitizedData',
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final sanitizedData = _sanitize(response.data);
    AppLogger.d(
      '<-- ${response.statusCode} ${response.requestOptions.uri}\n'
      'Response: $sanitizedData',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final sanitizedData = _sanitize(err.response?.data);
    AppLogger.w(
      '<-- ERROR ${err.response?.statusCode ?? 0} ${err.requestOptions.uri} (${err.type})\n'
      'Error: ${err.message}\n'
      'Response: $sanitizedData',
    );
    handler.next(err);
  }

  dynamic _sanitize(dynamic data) {
    if (data == null) return null;
    if (data is Map) {
      final sanitized = <String, dynamic>{};
      for (final entry in data.entries) {
        final key = entry.key.toString();
        if (_sensitiveKeys.contains(key)) {
          sanitized[key] = '[REDACTED]';
        } else {
          sanitized[key] = _sanitize(entry.value);
        }
      }
      return sanitized;
    }
    if (data is List) {
      return data.map(_sanitize).toList();
    }
    if (data is String) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map || decoded is List) {
          return jsonEncode(_sanitize(decoded));
        }
      } catch (_) {}
    }
    return data;
  }
}
