import 'package:flutter/material.dart';

import '../widgets/academy_header.dart';
import '../models/academy_models.dart';
import '../widgets/learning_statistics_card.dart';
import '../widgets/continue_learning_card.dart';
import '../widgets/course_category_grid.dart';
import '../widgets/featured_courses_section.dart';
import '../widgets/recommended_courses_section.dart';
import '../widgets/recent_lessons_section.dart';
import '../widgets/achievement_progress_card.dart';
import '../widgets/daily_goal_card.dart';
import '../widgets/learning_streak_card.dart';
import '../widgets/bottom_spacing.dart';

class CyberAcademyScreen extends StatelessWidget {
  const CyberAcademyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const SliverToBoxAdapter(child: AcademyHeader()),

          // Learning statistics
          const SliverToBoxAdapter(child: LearningStatisticsCard(totalHours: 42, completedCourses: 6, activePaths: 3)),

          // Continue learning (placeholder course)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              child: ContinueLearningCard(
                course: const Course(id: 'c1', title: 'Intro to Threat Modeling', subtitle: 'Attack Surface Analysis', progress: 0.38),
              ),
            ),
          ),

          // Course categories
          SliverToBoxAdapter(child: CourseCategoryGrid(categories: const [Category(id: 'net', name: 'Network'), Category(id: 'mal', name: 'Malware'), Category(id: 'for', name: 'Forensics')])),

          // Featured courses
          const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.only(top: 12, bottom: 8), child: FeaturedCoursesSection(courses: [Course(id: 'f1', title: 'Offensive Techniques', subtitle: 'Hands-on labs & simulations'), Course(id: 'f2', title: 'Cloud Hardening', subtitle: 'Protect modern infra')] ))),

          // Recommended
          SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20), child: Text('Recommended for you', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)))) ,
          const SliverToBoxAdapter(child: RecommendedCoursesSection(courses: [Course(id: 'r1', title: 'Malware Analysis Crashcourse', subtitle: 'Reverse engineering', author: 'ForenShield Team')])) ,

          // Recently completed
          SliverPadding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            sliver: SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Text('Recently completed', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)))),
          ),
          const SliverToBoxAdapter(child: RecentLessonsSection(lessons: [Lesson(id: 'l1', title: 'Packet analysis basics', courseId: 'Network Forensics')])) ,

          // Achievement and daily goal side by side on wide screens
          SliverToBoxAdapter(
            child: LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth > 700) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: AchievementProgressCard(achievement: const Achievement(id: 'a1', name: 'Badges', description: 'Earn badges by completing labs', progress: 0.54))),
                      const SizedBox(width: 12),
                      SizedBox(width: 320, child: Column(children: const [DailyGoalCard(minutesTarget: 30, minutesCompleted: 18), SizedBox(height: 12), LearningStreakCard(days: 12)])),
                    ],
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  children: const [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 0), child: AchievementProgressCard(achievement: Achievement(id: 'a1', name: 'Badges', description: 'Earn badges by completing labs', progress: 0.54))),
                    SizedBox(height: 12),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 0), child: DailyGoalCard(minutesTarget: 30, minutesCompleted: 18)),
                    SizedBox(height: 12),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 0), child: LearningStreakCard(days: 12)),
                  ],
                ),
              );
            }),
          ),

          // Recommended footer spacing
          const SliverToBoxAdapter(child: BottomSpacing()),
        ],
      ),
    );
  }
}
