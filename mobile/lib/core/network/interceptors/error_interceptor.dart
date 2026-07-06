import 'package:dio/dio.dart';
import '../../utils/logger.dart';
import '../api_exception.dart';

/// Interceptor for centralized error handling
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final apiException = _handleError(err);
    AppLogger.error('API Error', error: apiException);

    final modifiedError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: apiException,
    );

    handler.next(modifiedError);
  }

  ApiException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException(
          message: 'Connection timeout',
          statusCode: 0,
          type: ApiExceptionType.timeout,
        );

      case DioExceptionType.connectionError:
        return const ApiException(
          message: 'No internet connection',
          statusCode: 0,
          type: ApiExceptionType.noInternet,
        );

      case DioExceptionType.badResponse:
        return _handleResponseError(error.response);

      default:
        return const ApiException(
          message: 'An unexpected error occurred',
          statusCode: 0,
          type: ApiExceptionType.unknown,
        );
    }
  }

  ApiException _handleResponseError(Response? response) {
    if (response == null) {
      return const ApiException(
        message: 'No response from server',
        statusCode: 0,
        type: ApiExceptionType.unknown,
      );
    }

    final statusCode = response.statusCode ?? 0;
    final data = response.data;

    String message = 'An error occurred';
    if (data is Map<String, dynamic>) {
      message = data['message'] as String? ?? message;
    }

    ApiExceptionType type;
    switch (statusCode) {
      case 400:
        type = ApiExceptionType.badRequest;
        break;
      case 401:
        type = ApiExceptionType.unauthorized;
        break;
      case 403:
        type = ApiExceptionType.forbidden;
        break;
      case 404:
        type = ApiExceptionType.notFound;
        break;
      case 500:
      case 502:
      case 503:
        type = ApiExceptionType.serverError;
        break;
      default:
        type = ApiExceptionType.unknown;
    }

    return ApiException(
      message: message,
      statusCode: statusCode,
      type: type,
      data: data is Map<String, dynamic> ? data : null,
    );
  }
}
