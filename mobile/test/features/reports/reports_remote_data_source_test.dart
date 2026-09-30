import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forenshield/core/network/api_client.dart';
import 'package:forenshield/features/reports/data/datasources/reports_remote_data_source.dart';

class FakeApiClient extends ApiClient {
  final Map<String, dynamic> responses;

  FakeApiClient(this.responses);

  @override
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final key = queryParameters != null && queryParameters.isNotEmpty
        ? '$path?${queryParameters.entries.map((e) => "${e.key}=${e.value}").join("&")}'
        : path;
    final data = responses[key] ?? responses[path];
    return Response<T>(
      requestOptions: RequestOptions(path: path),
      data: data as T,
      statusCode: 200,
    );
  }

  @override
  Future<Response<T>> post<T>(String path, {dynamic data}) async {
    final resp = responses['POST:$path'] ?? responses[path];
    return Response<T>(
      requestOptions: RequestOptions(path: path),
      data: resp as T,
      statusCode: 200,
    );
  }
}

void main() {
  group('ReportsRemoteDataSource Tests', () {
    test('getReports parses list of ReportCase from API response', () async {
      final sampleList = [
        {
          'id': 'rep_001',
          'case_number': '#FSC-0091',
          'title': 'NovaCorp Incident',
          'category': 'Incidents',
          'severity': 'Critical',
          'status': 'FINALIZED',
          'generated_at': '2026-09-30',
          'analyst': 'Lead Analyst',
          'summary': 'Ransomware detected',
          'findings': <String>[],
          'remediation_actions': <String>[],
          'artifacts': <String>[],
        }
      ];

      final fakeClient = FakeApiClient({
        '/reports.php': sampleList,
      });

      final dataSource = ReportsRemoteDataSource(fakeClient);
      final reports = await dataSource.getReports();

      expect(reports.length, 1);
      expect(reports.first.id, 'rep_001');
      expect(reports.first.caseNumber, '#FSC-0091');
      expect(reports.first.title, 'NovaCorp Incident');
    });

    test('generateReport calls POST /reports.php and returns ReportCase', () async {
      final sampleReport = {
        'id': 'rep_case_101_1',
        'case_number': '#FSC-0101',
        'case_id': 'case_101',
        'title': 'Account Takeover Incident Report',
        'category': 'Identity',
        'severity': 'High',
        'status': 'FINALIZED',
        'generated_at': '2026-09-30',
        'analyst': 'Analyst',
        'summary': 'Compromised creds',
        'score': 100,
        'xp_earned': 200,
        'findings': <String>[],
        'remediation_actions': <String>[],
        'artifacts': <String>[],
        'timeline': <dynamic>[],
        'evidence': <dynamic>[],
      };

      final fakeClient = FakeApiClient({
        'POST:/reports.php': {'success': true, 'report': sampleReport},
      });

      final dataSource = ReportsRemoteDataSource(fakeClient);
      final report = await dataSource.generateReport('case_101');

      expect(report.id, 'rep_case_101_1');
      expect(report.caseId, 'case_101');
      expect(report.severity, 'High');
      expect(report.score, 100);
      expect(report.xpEarned, 200);
    });

    test('getReportById retrieves single report by id', () async {
      final sampleReport = {
        'id': 'rep_case_101_1',
        'case_number': '#FSC-0101',
        'title': 'Account Takeover Incident Report',
        'category': 'Identity',
        'severity': 'High',
        'status': 'FINALIZED',
        'generated_at': '2026-09-30',
        'analyst': 'Analyst',
        'summary': 'Compromised creds',
        'score': 100,
        'xp_earned': 200,
        'findings': <String>[],
        'remediation_actions': <String>[],
        'artifacts': <String>[],
        'timeline': <dynamic>[],
        'evidence': <dynamic>[],
      };

      final fakeClient = FakeApiClient({
        '/reports.php?id=rep_case_101_1': sampleReport,
      });

      final dataSource = ReportsRemoteDataSource(fakeClient);
      final report = await dataSource.getReportById('rep_case_101_1');

      expect(report.id, 'rep_case_101_1');
      expect(report.title, 'Account Takeover Incident Report');
    });
  });
}
