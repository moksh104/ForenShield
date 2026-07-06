import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppShadows {
  AppShadows._();

  static const List<BoxShadow> none = [];

  static final List<BoxShadow> subtle = [
    BoxShadow(
      color: AppColors.shadow.withValues(alpha: 0.1),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static final List<BoxShadow> small = [
    BoxShadow(
      color: AppColors.shadow.withValues(alpha: 0.15),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static final List<BoxShadow> medium = [
    BoxShadow(
      color: AppColors.shadow.withValues(alpha: 0.2),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];

  static final List<BoxShadow> large = [
    BoxShadow(
      color: AppColors.shadow.withValues(alpha: 0.3),
      blurRadius: 24,
      offset: const Offset(0, 12),
    ),
  ];

  static final List<BoxShadow> glass = [
    BoxShadow(
      color: AppColors.shadow.withValues(alpha: 0.05),
      blurRadius: 30,
      offset: const Offset(0, 10),
    ),
  ];
}
