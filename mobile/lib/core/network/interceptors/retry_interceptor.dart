import 'dart:async';
import 'package:dio/dio.dart';
import '../../logger/app_logger.dart';

/// Interceptor to automatically retry failed network requests with exponential backoff.
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final List<String> safeMethods = const ['GET', 'HEAD', 'OPTIONS'];

  RetryInterceptor({required this.dio, this.maxRetries = 3});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final requestOptions = err.requestOptions;

    // Only retry on specific network or server errors, and only for safe HTTP methods
    if (_shouldRetry(err) &&
        safeMethods.contains(requestOptions.method.toUpperCase())) {
      final attemptCount = (requestOptions.extra['retry_attempt'] as int?) ?? 0;

      if (attemptCount < maxRetries) {
        requestOptions.extra['retry_attempt'] = attemptCount + 1;

        // Exponential backoff: 1s, 2s, 4s...
        final delay = Duration(seconds: 1 << attemptCount);
        AppLogger.w(
          'Request failed. Retrying ${requestOptions.path} '
          '(Attempt ${attemptCount + 1}/$maxRetries) in ${delay.inSeconds}s...',
        );

        await Future.delayed(delay);

        try {
          // Clone the options
          final options = Options(
            method: requestOptions.method,
            headers: requestOptions.headers,
            extra: requestOptions.extra,
            responseType: requestOptions.responseType,
            contentType: requestOptions.contentType,
            validateStatus: requestOptions.validateStatus,
            receiveDataWhenStatusError:
                requestOptions.receiveDataWhenStatusError,
            followRedirects: requestOptions.followRedirects,
            maxRedirects: requestOptions.maxRedirects,
            persistentConnection: requestOptions.persistentConnection,
            requestEncoder: requestOptions.requestEncoder,
            responseDecoder: requestOptions.responseDecoder,
            listFormat: requestOptions.listFormat,
          );

          // Execute the retry
          final response = await dio.request<dynamic>(
            requestOptions.path,
            data: requestOptions.data,
            queryParameters: requestOptions.queryParameters,
            options: options,
            cancelToken: requestOptions.cancelToken,
            onReceiveProgress: requestOptions.onReceiveProgress,
            onSendProgress: requestOptions.onSendProgress,
          );

          return handler.resolve(response);
        } on DioException catch (e) {
          // If the retry also throws a DioException, let the onError flow continue
          // which will eventually hit this interceptor again if retries aren't exhausted.
          return handler.next(e);
        } catch (e) {
          return handler.reject(
            DioException(requestOptions: requestOptions, error: e),
          );
        }
      }
    }

    // If we shouldn't retry or we've exhausted retries, pass the error down the chain
    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        _isServerError(err.response?.statusCode);
  }

  bool _isServerError(int? statusCode) {
    return statusCode != null &&
        (statusCode == 500 ||
            statusCode == 502 ||
            statusCode == 503 ||
            statusCode == 504);
  }
}
