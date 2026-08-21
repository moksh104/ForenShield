import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/nvd_model.dart';

/// Remote data source for the NVD vulnerability statistics endpoint.
///
/// Delegates all HTTP work to the shared [ApiClient] — no duplicate Dio.
class NvdRemoteDataSource {
  final ApiClient _apiClient;

  const NvdRemoteDataSource(this._apiClient);

  /// Fetches aggregated NVD vulnerability statistics from `api/nvd.php`.
  ///
  /// Throws [ApiException] on network failure, HTTP error, or parse error.
  Future<NvdModel> getNvdStats() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        ApiEndpoints.nvd,
      );

      final data = response.data;
      if (data == null) {
        throw const ApiException('Empty response from NVD endpoint.');
      }

      final success = data['success'] as bool? ?? false;
      if (!success) {
        final errMsg =
            data['error'] as String? ??
            'Unable to load live vulnerability reports.';
        throw ApiException(errMsg);
      }

      return NvdModel.fromJson(data);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to fetch NVD statistics: $e');
    }
  }
}
