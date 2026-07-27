import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/report_case.dart';
import '../services/mock_reports_service.dart';

final mockReportsServiceProvider = Provider<MockReportsService>((ref) {
  return const MockReportsService();
});

final reportsProvider = Provider<List<ReportCase>>((ref) {
  final service = ref.watch(mockReportsServiceProvider);
  return service.fetchReports();
});

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
