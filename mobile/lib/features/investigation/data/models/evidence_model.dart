import '../../domain/entities/evidence_entity.dart';

class EvidenceModel extends EvidenceEntity {
  const EvidenceModel({
    required super.id,
    required super.title,
    required super.type,
    super.fileUrl,
    required super.contentText,
    required super.metadataMap,
    super.isReviewed,
    required super.timestamp,
  });

  factory EvidenceModel.fromJson(Map<String, dynamic> json) {
    // PHP APIs return 'metadata_map' (matching the DB column name).
    // Support both 'metadata_map' (API response) and 'metadata' (legacy/fallback).
    final rawMeta =
        (json['metadata_map'] as Map<String, dynamic>?) ??
        (json['metadata'] as Map<String, dynamic>?) ??
        const <String, dynamic>{};

    return EvidenceModel(
      id: (json['id'] ?? '').toString(),
      title: json['title'] as String? ?? '',
      type: json['type'] as String? ?? 'text',
      fileUrl: json['file_url'] as String?,
      contentText: json['content_text'] as String? ?? '',
      metadataMap: rawMeta.map((k, v) => MapEntry(k, v.toString())),
      isReviewed: json['is_reviewed'] as bool? ?? false,
      timestamp: json['timestamp'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'file_url': fileUrl,
      'content_text': contentText,
      'metadata_map': metadataMap,
      'is_reviewed': isReviewed,
      'timestamp': timestamp,
    };
  }
}
