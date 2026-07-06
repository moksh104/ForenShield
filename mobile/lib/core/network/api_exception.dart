/// Custom API exception types
enum ApiExceptionType {
  timeout,
  noInternet,
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  serverError,
  unknown,
}

/// Custom API exception class
class ApiException implements Exception {
  final String message;
  final int statusCode;
  final ApiExceptionType type;
  final Map<String, dynamic>? data;

  const ApiException({
    required this.message,
    required this.statusCode,
    required this.type,
    this.data,
  });

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';

  bool get isNetworkError =>
      type == ApiExceptionType.timeout || type == ApiExceptionType.noInternet;

  bool get isAuthError =>
      type == ApiExceptionType.unauthorized || type == ApiExceptionType.forbidden;

  String get userMessage {
    switch (type) {
      case ApiExceptionType.timeout:
        return 'Request timed out. Please try again.';
      case ApiExceptionType.noInternet:
        return 'No internet connection. Please check your network.';
      case ApiExceptionType.unauthorized:
        return 'Session expired. Please log in again.';
      case ApiExceptionType.notFound:
        return 'Resource not found.';
      case ApiExceptionType.serverError:
        return 'Server error. Please try again later.';
      default:
        return message.isNotEmpty ? message : 'An error occurred.';
    }
  }
}
