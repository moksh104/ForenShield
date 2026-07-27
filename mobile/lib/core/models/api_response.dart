import 'package:equatable/equatable.dart';

/// A generic wrapper for standard API responses.
/// Useful for parsing standardized JSON envelopes (e.g., `{ "data": ..., "message": "Success", "status": 200 }`).
class ApiResponse<T> extends Equatable {
  /// The generic payload of the response.
  final T? data;

  /// A message provided by the server, often used for user-facing feedback.
  final String? message;

  /// The HTTP or application-specific status code.
  final int status;

  /// Determines if the response was successful (status code 200-299).
  bool get isSuccess => status >= 200 && status < 300;

  const ApiResponse({this.data, this.message, required this.status});

  /// Creates a new [ApiResponse] by parsing JSON.
  /// A [fromJsonT] function must be provided to parse the generic [T] data field.
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return ApiResponse<T>(
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      message: json['message'] as String?,
      status: json['status'] as int? ?? 200,
    );
  }

  /// Converts the [ApiResponse] to JSON.
  /// A [toJsonT] function must be provided to serialize the generic [T] data field.
  Map<String, dynamic> toJson(dynamic Function(T?) toJsonT) {
    return {'data': toJsonT(data), 'message': message, 'status': status};
  }

  /// Creates a copy of this [ApiResponse] but with the given fields replaced with the new values.
  ApiResponse<T> copyWith({T? data, String? message, int? status}) {
    return ApiResponse<T>(
      data: data ?? this.data,
      message: message ?? this.message,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [data, message, status];
}
