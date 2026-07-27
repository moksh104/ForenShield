import 'package:flutter/material.dart';

/// Centralized repository for application icons.
/// Abstracting this allows easy switching between Material Icons,
/// Cupertino Icons, or custom SVG assets in the future.
abstract class AppIcons {
  // Navigation
  static const IconData home = Icons.home_rounded;
  static const IconData dashboard = Icons.dashboard_rounded;
  static const IconData settings = Icons.settings_rounded;
  static const IconData profile = Icons.person_rounded;

  // Actions
  static const IconData search = Icons.search_rounded;
  static const IconData filter = Icons.filter_list_rounded;
  static const IconData add = Icons.add_rounded;
  static const IconData edit = Icons.edit_rounded;
  static const IconData delete = Icons.delete_rounded;
  static const IconData close = Icons.close_rounded;
  static const IconData check = Icons.check_rounded;
  static const IconData chevronRight = Icons.chevron_right_rounded;
  static const IconData chevronLeft = Icons.chevron_left_rounded;

  // Status & Feedback
  static const IconData success = Icons.check_circle_rounded;
  static const IconData error = Icons.error_rounded;
  static const IconData warning = Icons.warning_rounded;
  static const IconData info = Icons.info_rounded;

  // Domain Specific (Cybersecurity/Training)
  static const IconData terminal = Icons.terminal_rounded;
  static const IconData security = Icons.security_rounded;
  static const IconData investigation = Icons.policy_rounded;
  static const IconData academy = Icons.school_rounded;
  static const IconData simulation = Icons.science_rounded;
  static const IconData network = Icons.hub_rounded;
  static const IconData bug = Icons.bug_report_rounded;
  static const IconData analysis = Icons.analytics_rounded;
  static const IconData lab = Icons.biotech_rounded;
}
