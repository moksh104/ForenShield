import '../../../../core/network/api_client.dart';
import '../../models/report_case.dart';
import '../../services/mock_reports_service.dart';

/// Remote Data Source for Security Intelligence Reports API endpoints.
class ReportsRemoteDataSource {
  final ApiClient _apiClient;

  const ReportsRemoteDataSource(this._apiClient);

  /// Fetches reports list from backend API endpoint.
  Future<List<ReportCase>> getReports() async {
    try {
      final response = await _apiClient.get<List<dynamic>>('/reports.php');
      if (response.data != null) {
        return response.data!
            .map((e) => ReportCase.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      // Fallback if offline
    }
    return const MockReportsService().fetchReports();
  }
}
