import '../../domain/entities/timeline_entity.dart';

class TimelineEventModel extends TimelineEventEntity {
  const TimelineEventModel({
    required super.id,
    required super.title,
    required super.description,
    required super.timestamp,
    required super.category,
    required super.severity,
    super.isExpanded,
  });

  factory TimelineEventModel.fromJson(Map<String, dynamic> json) {
    return TimelineEventModel(
      id: (json['id'] ?? '').toString(),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      timestamp: json['timestamp'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      severity: json['severity'] as String? ?? 'Low',
      isExpanded: json['is_expanded'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'timestamp': timestamp,
      'category': category,
      'severity': severity,
      'is_expanded': isExpanded,
    };
  }
}
