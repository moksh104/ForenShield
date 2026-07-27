/// Tracks the lifecycle state of a digital investigation.
enum InvestigationStatus {
  notStarted('Not Started'),
  inProgress('In Progress'),
  underReview('Under Review'),
  solved('Solved'),
  failed('Failed');

  final String label;
  const InvestigationStatus(this.label);

  bool get isComplete =>
      this == InvestigationStatus.solved || this == InvestigationStatus.failed;
}
