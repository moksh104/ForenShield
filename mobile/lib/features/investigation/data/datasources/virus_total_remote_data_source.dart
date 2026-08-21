import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../models/virus_total_model.dart';

class VirusTotalRemoteDataSource {
  final ApiClient _apiClient;

  const VirusTotalRemoteDataSource(this._apiClient);

  Future<VirusTotalModel> getAnalysis(String query) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.virusTotal,
      queryParameters: {'query': query},
    );

    final responseData = response.data;
    if (responseData != null &&
        responseData['success'] == true &&
        responseData['data'] != null) {
      return VirusTotalModel.fromJson(
        responseData['data'] as Map<String, dynamic>,
      );
    } else {
      throw Exception(
        responseData?['error'] ??
            'Live VirusTotal analysis is currently unavailable.',
      );
    }
  }
}
