import 'package:equatable/equatable.dart';

/// Represents a standardized error/failure object across the app architecture.
class Failure extends Equatable implements Exception {
  /// A developer-friendly or user-facing message describing the failure.
  final String message;

  /// Optional HTTP or domain-specific error code.
  final String? code;

  /// The original underlying exception, if any.
  final dynamic exception;

  /// Original stack trace, if available.
  final StackTrace? stackTrace;

  const Failure({
    required this.message,
    this.code,
    this.exception,
    this.stackTrace,
  });

  /// Factory for parsing a Failure from a standard JSON error response.
  factory Failure.fromJson(Map<String, dynamic> json) {
    return Failure(
      message: json['message'] as String? ?? 'An unexpected error occurred.',
      code: json['code']?.toString(),
    );
  }

  /// Converts the [Failure] into a JSON representation for logging or forwarding.
  Map<String, dynamic> toJson() {
    return {'message': message, 'code': code};
  }

  /// Creates a copy of this [Failure] with given fields replaced.
  Failure copyWith({
    String? message,
    String? code,
    dynamic exception,
    StackTrace? stackTrace,
  }) {
    return Failure(
      message: message ?? this.message,
      code: code ?? this.code,
      exception: exception ?? this.exception,
      stackTrace: stackTrace ?? this.stackTrace,
    );
  }

  @override
  String toString() => 'Failure(message: $message, code: $code)';

  @override
  List<Object?> get props => [message, code, exception];
}
