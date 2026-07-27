import 'package:dio/dio.dart';
import '../../logger/app_logger.dart';
import '../../exceptions/app_exceptions.dart';

/// Interceptor for centralized error handling
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final appException = _handleError(err);
    AppLogger.e('API Error', appException);

    final modifiedError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: appException,
    );

    handler.next(modifiedError);
  }

  AppException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();

      case DioExceptionType.connectionError:
        return const NetworkException('No internet connection');

      case DioExceptionType.badResponse:
        return _handleResponseError(error.response);

      case DioExceptionType.badCertificate:
        return const NetworkException('Invalid certificate');

      case DioExceptionType.unknown:
        // Commonly thrown for SocketExceptions (No internet) or parsing errors
        if (error.error != null && error.error.toString().contains('SocketException')) {
          return const NetworkException();
        }
        if (error.error != null && error.error is FormatException) {
          return const SerializationException();
        }
        return const ApiException('An unexpected error occurred');

      default:
        return const ApiException('An unexpected error occurred');
    }
  }

  AppException _handleResponseError(Response? response) {
    if (response == null) {
      return const ApiException('No response from server');
    }

    final statusCode = response.statusCode ?? 0;
    final data = response.data;

    String message = 'An error occurred';
    if (data is Map<String, dynamic>) {
      message = data['message'] as String? ?? message;
    }

    switch (statusCode) {
      case 400:
        return ValidationException(
          message,
          data is Map<String, dynamic> ? data : null,
          400,
        );
      case 401:
        return const UnauthorizedException();
      case 403:
        return const ForbiddenException();
      case 404:
        return const NotFoundException();
      case 409:
        return ConflictException(message);
      case 422:
        return ValidationException(
          message,
          data is Map<String, dynamic> ? data : null,
          422,
        );
      case 500:
      case 502:
      case 503:
        return const ServerException();
      default:
        return ApiException(message, statusCode);
    }
  }
}
