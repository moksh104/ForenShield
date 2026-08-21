import 'package:equatable/equatable.dart';

// ── NvdRecentCve ─────────────────────────────────────────────────────────────

/// A recently published CVE entry from the NVD feed.
class NvdRecentCve extends Equatable {
  final String cveId;
  final String description;
  final String severity;
  final String published;

  const NvdRecentCve({
    required this.cveId,
    required this.description,
    required this.severity,
    required this.published,
  });

  factory NvdRecentCve.fromJson(Map<String, dynamic> json) {
    return NvdRecentCve(
      cveId: json['cve_id'] as String? ?? 'N/A',
      description:
          json['description'] as String? ?? 'No description available.',
      severity: json['severity'] as String? ?? 'N/A',
      published: json['published'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [cveId, description, severity, published];
}

// ── NvdStats ──────────────────────────────────────────────────────────────────

/// Aggregated NVD vulnerability statistics returned by `api/nvd.php`.
class NvdStats extends Equatable {
  /// Total CVEs across all severity levels.
  final int totalCves;

  /// Number of CVEs with CVSS v3 severity = CRITICAL.
  final int critical;

  /// Number of CVEs with CVSS v3 severity = HIGH.
  final int high;

  /// Number of CVEs with CVSS v3 severity = MEDIUM.
  final int medium;

  /// Number of CVEs with CVSS v3 severity = LOW.
  final int low;

  /// Most recently published CVEs (up to 5).
  final List<NvdRecentCve> recentCves;

  /// True when the response was served from the PHP file cache.
  final bool fromCache;

  /// Age of the cache in seconds (0 when freshly fetched).
  final int cacheAgeSeconds;

  const NvdStats({
    required this.totalCves,
    required this.critical,
    required this.high,
    required this.medium,
    required this.low,
    required this.recentCves,
    required this.fromCache,
    required this.cacheAgeSeconds,
  });

  /// Zero-value placeholder used during loading or on error.
  factory NvdStats.empty() => const NvdStats(
    totalCves: 0,
    critical: 0,
    high: 0,
    medium: 0,
    low: 0,
    recentCves: [],
    fromCache: false,
    cacheAgeSeconds: 0,
  );

  @override
  List<Object?> get props => [
    totalCves,
    critical,
    high,
    medium,
    low,
    recentCves,
    fromCache,
    cacheAgeSeconds,
  ];
}

// ── NvdModel (data layer) ─────────────────────────────────────────────────────

/// Data model that deserialises the JSON response from `api/nvd.php`.
///
/// Extends [NvdStats] so the repository can return the domain type directly.
class NvdModel extends NvdStats {
  const NvdModel({
    required super.totalCves,
    required super.critical,
    required super.high,
    required super.medium,
    required super.low,
    required super.recentCves,
    required super.fromCache,
    required super.cacheAgeSeconds,
  });

  factory NvdModel.fromJson(Map<String, dynamic> json) {
    final rawRecent = json['recent_cves'] as List<dynamic>? ?? [];
    final recentCves = rawRecent
        .whereType<Map<String, dynamic>>()
        .map(NvdRecentCve.fromJson)
        .toList();

    return NvdModel(
      totalCves: json['total_cves'] as int? ?? 0,
      critical: json['critical'] as int? ?? 0,
      high: json['high'] as int? ?? 0,
      medium: json['medium'] as int? ?? 0,
      low: json['low'] as int? ?? 0,
      recentCves: recentCves,
      fromCache: json['from_cache'] as bool? ?? false,
      cacheAgeSeconds: json['cache_age_seconds'] as int? ?? 0,
    );
  }
}
