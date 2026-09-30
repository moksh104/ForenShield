import '../../../../core/network/api_client.dart';
import '../../models/report_case.dart';

/// Remote Data Source for Security Intelligence Reports API endpoints.
class ReportsRemoteDataSource {
  final ApiClient _apiClient;

  const ReportsRemoteDataSource(this._apiClient);

  /// Fetches reports list from backend API endpoint for authenticated user.
  Future<List<ReportCase>> getReports({String? category, String? search}) async {
    final queryParams = <String, dynamic>{};
    if (category != null && category.isNotEmpty && category != 'All') {
      queryParams['category'] = category;
    }
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    final response = await _apiClient.get<List<dynamic>>(
      '/reports.php',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    if (response.data != null) {
      return response.data!
          .map((e) => ReportCase.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  /// Fetches single report detail by ID.
  Future<ReportCase> getReportById(String reportId) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/reports.php',
      queryParameters: {'id': reportId},
    );

    if (response.data != null) {
      return ReportCase.fromJson(response.data!);
    }
    throw Exception('Failed to load incident report');
  }

  /// Authoritatively generates an incident report for a completed investigation case.
  Future<ReportCase> generateReport(String caseId) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/reports.php',
      data: {'case_id': caseId},
    );

    if (response.data != null) {
      final reportMap = response.data!['report'] as Map<String, dynamic>? ?? response.data!;
      return ReportCase.fromJson(reportMap);
    }
    throw Exception('Failed to generate incident report');
  }
}
