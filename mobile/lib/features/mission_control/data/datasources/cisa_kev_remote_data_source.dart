import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/cisa_kev_model.dart';

/// Remote data source responsible for calling the PHP `/cisa_kev.php` endpoint.
///
/// Reuses the shared [ApiClient] — does NOT create a second Dio instance.
class CisaKevRemoteDataSource {
  final ApiClient _apiClient;

  const CisaKevRemoteDataSource(this._apiClient);

  /// Fetches the latest KEV entries from the PHP backend.
  ///
  /// Throws [ApiException] if the server returns an error payload or
  /// if the response cannot be parsed.
  Future<CisaKevResponse> getKevFeed() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        ApiEndpoints.cisaKev,
      );

      final data = response.data;
      if (data == null) {
        throw const ApiException('Empty response from CISA KEV endpoint.');
      }

      // Check for server-side error payload
      final success = data['success'] as bool? ?? false;
      if (!success) {
        final errorMsg =
            data['error'] as String? ??
            'Unable to load live threat intelligence.';
        throw ApiException(errorMsg);
      }

      return CisaKevResponse.fromJson(data);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to fetch CISA KEV feed: $e');
    }
  }
}
