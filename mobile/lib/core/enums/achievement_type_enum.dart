/// Categorizes achievements and badges within the platform.
enum AchievementType {
  coursework('Coursework'),
  investigation('Investigation'),
  speed('Speed Run'),
  accuracy('Flawless'),
  streak('Daily Streak'),
  special('Special Event');

  final String label;
  const AchievementType(this.label);
}
