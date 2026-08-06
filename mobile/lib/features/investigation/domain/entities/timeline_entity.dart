import 'package:equatable/equatable.dart';

/// Chronological event item in an investigation timeline.
class TimelineEventEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String timestamp;
  final String category;
  final String severity;
  final bool isExpanded;

  const TimelineEventEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.category,
    required this.severity,
    this.isExpanded = false,
  });

  TimelineEventEntity copyWith({bool? isExpanded}) {
    return TimelineEventEntity(
      id: id,
      title: title,
      description: description,
      timestamp: timestamp,
      category: category,
      severity: severity,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    timestamp,
    category,
    severity,
    isExpanded,
  ];
}
