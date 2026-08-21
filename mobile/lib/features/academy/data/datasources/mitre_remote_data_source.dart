import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../models/mitre_technique_model.dart';

class MitreRemoteDataSource {
  final ApiClient _apiClient;

  MitreRemoteDataSource(this._apiClient);

  Future<List<MitreTechniqueModel>> getMitreTechniques() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.mitreAttack,
    );
    final responseData = response.data;

    if (responseData != null &&
        responseData['success'] == true &&
        responseData['data'] != null) {
      final dataList = responseData['data'] as List<dynamic>;
      return dataList
          .map(
            (json) =>
                MitreTechniqueModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } else {
      throw Exception(
        responseData?['error'] ??
            'Failed to load live MITRE ATT&CK techniques.',
      );
    }
  }
}
