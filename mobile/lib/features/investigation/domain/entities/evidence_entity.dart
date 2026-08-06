import 'package:equatable/equatable.dart';

/// Evidence item domain entity for digital forensics analysis.
class EvidenceEntity extends Equatable {
  final String id;
  final String title;
  final String
  type; // 'image' | 'pdf' | 'text' | 'log' | 'metadata' | 'history' | 'email'
  final String? fileUrl;
  final String contentText;
  final Map<String, String> metadataMap;
  final bool isReviewed;
  final String timestamp;

  const EvidenceEntity({
    required this.id,
    required this.title,
    required this.type,
    this.fileUrl,
    required this.contentText,
    required this.metadataMap,
    this.isReviewed = false,
    required this.timestamp,
  });

  EvidenceEntity copyWith({bool? isReviewed}) {
    return EvidenceEntity(
      id: id,
      title: title,
      type: type,
      fileUrl: fileUrl,
      contentText: contentText,
      metadataMap: metadataMap,
      isReviewed: isReviewed ?? this.isReviewed,
      timestamp: timestamp,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    type,
    fileUrl,
    contentText,
    metadataMap,
    isReviewed,
    timestamp,
  ];
}
