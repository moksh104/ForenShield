import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../data/datasources/reports_remote_data_source.dart';
import '../models/report_case.dart';

final reportsRemoteDataSourceProvider = Provider<ReportsRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ReportsRemoteDataSource(apiClient);
});

final reportsProvider =
    StateNotifierProvider.autoDispose<ReportsNotifier, List<ReportCase>>((ref) {
      final dataSource = ref.watch(reportsRemoteDataSourceProvider);
      return ReportsNotifier(dataSource);
    });

class ReportsNotifier extends StateNotifier<List<ReportCase>> {
  final ReportsRemoteDataSource _dataSource;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ReportsNotifier(this._dataSource) : super(const []) {
    loadReports();
  }

  Future<void> loadReports({String? category, String? search}) async {
    _isLoading = true;
    try {
      final fetched = await _dataSource.getReports(category: category, search: search);
      if (mounted) {
        state = fetched;
      }
    } catch (_) {
      // Keep existing state on error
    } finally {
      _isLoading = false;
    }
  }

  Future<ReportCase?> generateReport(String caseId) async {
    try {
      final report = await _dataSource.generateReport(caseId);
      if (mounted) {
        final existingIndex = state.indexWhere((r) => r.id == report.id);
        if (existingIndex >= 0) {
          final updated = List<ReportCase>.from(state);
          updated[existingIndex] = report;
          state = updated;
        } else {
          state = [report, ...state];
        }
      }
      return report;
    } catch (_) {
      return null;
    }
  }

  Future<ReportCase?> fetchSingleReport(String reportId) async {
    try {
      final report = await _dataSource.getReportById(reportId);
      if (mounted) {
        final existingIndex = state.indexWhere((r) => r.id == report.id);
        if (existingIndex >= 0) {
          final updated = List<ReportCase>.from(state);
          updated[existingIndex] = report;
          state = updated;
        } else {
          state = [report, ...state];
        }
      }
      return report;
    } catch (_) {
      return null;
    }
  }
}

final reportByIdProvider = Provider.family<ReportCase?, String>((ref, reportId) {
  final reports = ref.watch(reportsProvider);
  for (final report in reports) {
    if (report.id == reportId) return report;
  }
  return null;
});

final reportDetailAsyncProvider = FutureProvider.family<ReportCase, String>((ref, reportId) async {
  final cached = ref.read(reportByIdProvider(reportId));
  if (cached != null && cached.timeline.isNotEmpty) return cached;

  final dataSource = ref.watch(reportsRemoteDataSourceProvider);
  final fetched = await dataSource.getReportById(reportId);
  ref.read(reportsProvider.notifier).fetchSingleReport(reportId);
  return fetched;
});
