import 'package:dio/dio.dart';
import '../../storage/storage_service.dart';
import '../../constants/app_constants.dart';

/// Interceptor for JWT token injection and refresh
class AuthInterceptor extends Interceptor {
  final StorageService _storage = StorageService();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip token injection for auth endpoints
    if (_isAuthEndpoint(options.path)) {
      return handler.next(options);
    }

    // Get access token from storage
    final token = await _storage.read(AppConstants.keyAccessToken);
    
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 Unauthorized - attempt token refresh
    if (err.response?.statusCode == 401) {
      try {
        final refreshToken = await _storage.read(AppConstants.keyRefreshToken);
        
        if (refreshToken == null || refreshToken.isEmpty) {
          return handler.next(err);
        }

        // Attempt to refresh token
        final dio = Dio();
        final response = await dio.post(
          '${AppConstants.apiBaseUrl}/auth/refresh',
          data: {'refreshToken': refreshToken},
        );

        if (response.statusCode == 200) {
          final newAccessToken = response.data['accessToken'] as String?;
          final newRefreshToken = response.data['refreshToken'] as String?;

          if (newAccessToken != null) {
            await _storage.write(AppConstants.keyAccessToken, newAccessToken);
            if (newRefreshToken != null) {
              await _storage.write(AppConstants.keyRefreshToken, newRefreshToken);
            }

            // Retry original request
            final options = err.requestOptions;
            options.headers['Authorization'] = 'Bearer $newAccessToken';
            final retryResponse = await dio.fetch(options);
            return handler.resolve(retryResponse);
          }
        }
      } catch (e) {
        await _storage.deleteAll();
      }
    }

    handler.next(err);
  }

  bool _isAuthEndpoint(String path) {
    return path.contains('/auth/login') ||
        path.contains('/auth/register') ||
        path.contains('/auth/refresh');
  }
}
