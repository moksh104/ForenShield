/// Base application exception.
///
/// All domain-specific exceptions extend this class to provide a unified
/// error-handling surface across the ForenShield networking layer.
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, [this.statusCode]);

  /// A user-friendly message suitable for display in the UI.
  ///
  /// Subclasses override this to provide context-specific messages.
  /// Defaults to [message] if not overridden.
  String get userMessage => message.isNotEmpty ? message : 'An error occurred.';

  @override
  String toString() =>
      '$runtimeType: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

/// Generic API exception for unmapped HTTP status codes.
class ApiException extends AppException {
  const ApiException(super.message, [super.statusCode]);
}

/// Network/connection exception (offline, DNS failure, connection refused).
class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection.']);

  @override
  String get userMessage => 'No internet connection. Please check your network.';
}

/// Timeout exception (connect, send, or receive timeout).
class TimeoutException extends AppException {
  const TimeoutException([super.message = 'Request timed out.']);

  @override
  String get userMessage => 'Request timed out. Please try again.';
}

/// 401 Unauthorized exception.
class UnauthorizedException extends AppException {
  const UnauthorizedException([
    String message = 'Session expired. Please log in again.',
  ]) : super(message, 401);

  @override
  String get userMessage => 'Session expired. Please log in again.';
}

/// 403 Forbidden exception.
class ForbiddenException extends AppException {
  const ForbiddenException([
    String message = 'You do not have permission to perform this action.',
  ]) : super(message, 403);

  @override
  String get userMessage =>
      'You do not have permission to perform this action.';
}

/// Validation exception (400 or 422 with field-level errors).
class ValidationException extends AppException {
  final Map<String, dynamic>? errors;

  const ValidationException(
    super.message, [
    this.errors,
    super.statusCode = 422,
  ]);

  @override
  String get userMessage {
    if (errors != null && errors!.isNotEmpty) {
      // Return the first field error for a concise UI message.
      final firstError = errors!.values.first;
      if (firstError is List && firstError.isNotEmpty) {
        return firstError.first.toString();
      }
      return firstError.toString();
    }
    return message.isNotEmpty ? message : 'Please check your input.';
  }
}

/// Not Found exception (404).
class NotFoundException extends AppException {
  const NotFoundException([String message = 'Resource not found.'])
      : super(message, 404);

  @override
  String get userMessage => 'Resource not found.';
}

/// Conflict exception (409).
class ConflictException extends AppException {
  const ConflictException([String message = 'A conflict occurred.'])
      : super(message, 409);

  @override
  String get userMessage => message.isNotEmpty ? message : 'A conflict occurred.';
}

/// Server Error exception (500+).
class ServerException extends AppException {
  const ServerException([
    super.message = 'Server error. Please try again later.',
    super.statusCode = 500,
  ]);

  @override
  String get userMessage => 'Server error. Please try again later.';
}

/// Serialization exception for malformed JSON or unexpected payload shapes.
class SerializationException extends AppException {
  const SerializationException([
    super.message = 'Failed to process server response.',
  ]);

  @override
  String get userMessage => 'Failed to process server response.';
}
