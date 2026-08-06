/// Plain models used by Academy widgets.
/// Keep these simple data holders so the UI remains presentation-only.

class Course {
  final String id;
  final String title;
  final String subtitle;
  final String? author;
  final double progress; // 0.0 - 1.0
  final bool locked;

  const Course({
    required this.id,
    required this.title,
    required this.subtitle,
    this.author,
    this.progress = 0.0,
    this.locked = false,
  });
}

class Category {
  final String id;
  final String name;

  const Category({required this.id, required this.name});
}

class Lesson {
  final String id;
  final String title;
  final String courseId;

  const Lesson({required this.id, required this.title, required this.courseId});
}

class Achievement {
  final String id;
  final String name;
  final String description;
  final double progress; // 0.0 - 1.0

  const Achievement({required this.id, required this.name, required this.description, this.progress = 0.0});
}
