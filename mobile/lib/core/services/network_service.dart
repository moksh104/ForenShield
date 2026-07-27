import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Standardized representation of a network response.
/// Decouples the app from specific library response objects (like Dio.Response).
class NetworkResponse<T> {
  final T? data;
  final int? statusCode;
  final String? errorMessage;
  final bool isSuccess;

  NetworkResponse({
    this.data,
    this.statusCode,
    this.errorMessage,
    required this.isSuccess,
  });
}

/// Interface for executing HTTP/REST operations.
abstract class NetworkService {
  Future<NetworkResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });
  Future<NetworkResponse<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });
  Future<NetworkResponse<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });
  Future<NetworkResponse<T>> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  });
}

/// Default empty implementation for architectural completeness.
class DefaultNetworkService implements NetworkService {
  @override
  Future<NetworkResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    return NetworkResponse(isSuccess: false, errorMessage: 'Not implemented');
  }

  @override
  Future<NetworkResponse<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    return NetworkResponse(isSuccess: false, errorMessage: 'Not implemented');
  }

  @override
  Future<NetworkResponse<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    return NetworkResponse(isSuccess: false, errorMessage: 'Not implemented');
  }

  @override
  Future<NetworkResponse<T>> delete<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    return NetworkResponse(isSuccess: false, errorMessage: 'Not implemented');
  }
}

/// Riverpod provider for dependency injection.
final networkServiceProvider = Provider<NetworkService>((ref) {
  return DefaultNetworkService();
});
