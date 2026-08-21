import '../../domain/entities/cisa_kev_entity.dart';

/// Data model that deserialises a single CISA KEV vulnerability entry from
/// the JSON response produced by `api/cisa_kev.php`.
class CisaKevModel extends CisaKevEntry {
  const CisaKevModel({
    required super.cveId,
    required super.vendor,
    required super.product,
    required super.vulnerabilityName,
    required super.severity,
    required super.dateAdded,
    required super.requiredAction,
    required super.dueDate,
    required super.knownRansomware,
  });

  /// Constructs a [CisaKevModel] from a JSON map returned by the PHP backend.
  ///
  /// All fields are null-safe with sensible placeholder defaults, so a missing
  /// field never causes a runtime error.
  factory CisaKevModel.fromJson(Map<String, dynamic> json) {
    return CisaKevModel(
      cveId: json['cve_id'] as String? ?? 'N/A',
      vendor: json['vendor'] as String? ?? 'Unknown Vendor',
      product: json['product'] as String? ?? 'Unknown Product',
      vulnerabilityName:
          json['vulnerability_name'] as String? ?? 'Unknown Vulnerability',
      severity: json['severity'] as String? ?? 'N/A',
      dateAdded: json['date_added'] as String? ?? '',
      requiredAction:
          json['required_action'] as String? ?? 'Refer to vendor advisory.',
      dueDate: json['due_date'] as String? ?? '',
      knownRansomware: json['known_ransomware'] as String? ?? 'Unknown',
    );
  }
}

/// Response wrapper for the full `/cisa_kev.php` JSON response.
class CisaKevResponse {
  final bool success;
  final int total;
  final int count;
  final int cacheAgeSeconds;
  final bool fromCache;
  final List<CisaKevModel> vulnerabilities;

  const CisaKevResponse({
    required this.success,
    required this.total,
    required this.count,
    required this.cacheAgeSeconds,
    required this.fromCache,
    required this.vulnerabilities,
  });

  factory CisaKevResponse.fromJson(Map<String, dynamic> json) {
    final rawList = json['vulnerabilities'] as List<dynamic>? ?? [];
    final vulns = rawList
        .whereType<Map<String, dynamic>>()
        .map(CisaKevModel.fromJson)
        .toList();

    return CisaKevResponse(
      success: json['success'] as bool? ?? false,
      total: json['total'] as int? ?? 0,
      count: json['count'] as int? ?? 0,
      cacheAgeSeconds: json['cache_age_seconds'] as int? ?? 0,
      fromCache: json['from_cache'] as bool? ?? false,
      vulnerabilities: vulns,
    );
  }
}
