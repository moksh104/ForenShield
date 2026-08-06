import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../data/datasources/reports_remote_data_source.dart';
import '../models/report_case.dart';
import '../services/mock_reports_service.dart';

final reportsRemoteDataSourceProvider = Provider<ReportsRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ReportsRemoteDataSource(apiClient);
});

final reportsProvider = StateNotifierProvider<ReportsNotifier, List<ReportCase>>((ref) {
  final dataSource = ref.watch(reportsRemoteDataSourceProvider);
  return ReportsNotifier(dataSource);
});

class ReportsNotifier extends StateNotifier<List<ReportCase>> {
  final ReportsRemoteDataSource _dataSource;

  ReportsNotifier(this._dataSource) : super(const MockReportsService().fetchReports()) {
    loadReports();
  }

  Future<void> loadReports() async {
    final fetched = await _dataSource.getReports();
    if (mounted && fetched.isNotEmpty) {
      state = fetched;
    }
  }
}

final reportByIdProvider = Provider.family<ReportCase?, String>((
  ref,
  reportId,
) {
  final reports = ref.watch(reportsProvider);
  for (final report in reports) {
    if (report.id == reportId) return report;
  }
  return null;
});
