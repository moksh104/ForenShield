/// ForenShield Design System v1.0 — ThemeData
///
/// Wires the Foundation tokens (app_tokens.dart, app_typography.dart)
/// into Flutter's Material 3 ThemeData for both Light (primary) and
/// Dark (secondary) themes. Feature-accent colors are exposed via a
/// custom ThemeExtension (ForenColors) since Material's ColorScheme
/// only has slots for one primary/secondary/tertiary — not five
/// independent feature identities.
///
/// Light mode is the primary ForenShield experience.
library;

import 'package:flutter/material.dart';
import 'app_tokens.dart';
import 'app_typography.dart';

/// Custom theme extension carrying everything Material's
/// ColorScheme doesn't have a slot for: the five feature accents,
/// the four semantic status colors, and elevation surface steps.
///
/// Usage in a widget:
///   `final foren = Theme.of(context).extension<ForenColors>()!;`
///   `final accent = foren.forFeature(ForenFeature.investigation).t500;`

@immutable
class ForenColors extends ThemeExtension<ForenColors> {
  final ForenAccentRamp missionControl;
  final ForenAccentRamp academy;
  final ForenAccentRamp investigation;
  final ForenAccentRamp simulation;
  final ForenAccentRamp profile;

  final ForenAccentRamp success;
  final ForenAccentRamp warning;
  final ForenAccentRamp critical;
  final ForenAccentRamp info;

  final Color surfaceRaised1;
  final Color surfaceRaised2;
  final Color surfaceRaised3;
  final Color borderSubtle;
  final Color borderDefault;
  final Color textSecondary;
  final Color textDisabled;
  final Color codeBlockBackground;
  final Color codeBlockForeground;
  final Color codeBlockMuted;

  const ForenColors({
    required this.missionControl,
    required this.academy,
    required this.investigation,
    required this.simulation,
    required this.profile,
    required this.success,
    required this.warning,
    required this.critical,
    required this.info,
    required this.surfaceRaised1,
    required this.surfaceRaised2,
    required this.surfaceRaised3,
    required this.borderSubtle,
    required this.borderDefault,
    required this.textSecondary,
    required this.textDisabled,
    required this.codeBlockBackground,
    required this.codeBlockForeground,
    required this.codeBlockMuted,
  });

  ForenAccentRamp forFeature(ForenFeature feature) {
    switch (feature) {
      case ForenFeature.missionControl:
        return missionControl;
      case ForenFeature.academy:
        return academy;
      case ForenFeature.investigation:
        return investigation;
      case ForenFeature.simulation:
        return simulation;
      case ForenFeature.profile:
        return profile;
    }
  }

  static const ForenColors dark = ForenColors(
    missionControl: ForenFeatureColors.missionControl,
    academy: ForenFeatureColors.academy,
    investigation: ForenFeatureColors.investigation,
    simulation: ForenFeatureColors.simulation,
    profile: ForenFeatureColors.profile,
    success: ForenSemanticColors.success,
    warning: ForenSemanticColors.warning,
    critical: ForenSemanticColors.critical,
    info: ForenSemanticColors.info,
    surfaceRaised1: ForenNeutralDark.bgSurfaceRaised1,
    surfaceRaised2: ForenNeutralDark.bgSurfaceRaised2,
    surfaceRaised3: ForenNeutralDark.bgSurfaceRaised3,
    borderSubtle: ForenNeutralDark.borderSubtle,
    borderDefault: ForenNeutralDark.borderDefault,
    textSecondary: ForenNeutralDark.textSecondary,
    textDisabled: ForenNeutralDark.textDisabled,
    codeBlockBackground: ForenNeutralDark.bgBase,
    codeBlockForeground: ForenNeutralDark.textPrimary,
    codeBlockMuted: ForenNeutralDark.textSecondary,
  );

  static const ForenColors light = ForenColors(
    missionControl: ForenFeatureColors.missionControl,
    academy: ForenFeatureColors.academy,
    investigation: ForenFeatureColors.investigation,
    simulation: ForenFeatureColors.simulation,
    profile: ForenFeatureColors.profile,
    success: ForenSemanticColors.success,
    warning: ForenSemanticColors.warning,
    critical: ForenSemanticColors.critical,
    info: ForenSemanticColors.info,
    surfaceRaised1: ForenNeutralLight.bgSurfaceRaised1,
    surfaceRaised2: ForenNeutralLight.bgSurfaceRaised2,
    surfaceRaised3: ForenNeutralLight.bgSurfaceRaised3,
    borderSubtle: ForenNeutralLight.borderSubtle,
    borderDefault: ForenNeutralLight.borderDefault,
    textSecondary: ForenNeutralLight.textSecondary,
    textDisabled: ForenNeutralLight.textDisabled,
    codeBlockBackground: ForenNeutralDark.bgBase,
    codeBlockForeground: ForenNeutralDark.textPrimary,
    codeBlockMuted: ForenNeutralDark.textSecondary,
  );

  @override
  ForenColors copyWith({
    ForenAccentRamp? missionControl,
    ForenAccentRamp? academy,
    ForenAccentRamp? investigation,
    ForenAccentRamp? simulation,
    ForenAccentRamp? profile,
    ForenAccentRamp? success,
    ForenAccentRamp? warning,
    ForenAccentRamp? critical,
    ForenAccentRamp? info,
    Color? surfaceRaised1,
    Color? surfaceRaised2,
    Color? surfaceRaised3,
    Color? borderSubtle,
    Color? borderDefault,
    Color? textSecondary,
    Color? textDisabled,
    Color? codeBlockBackground,
    Color? codeBlockForeground,
    Color? codeBlockMuted,
  }) {
    return ForenColors(
      missionControl: missionControl ?? this.missionControl,
      academy: academy ?? this.academy,
      investigation: investigation ?? this.investigation,
      simulation: simulation ?? this.simulation,
      profile: profile ?? this.profile,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      critical: critical ?? this.critical,
      info: info ?? this.info,
      surfaceRaised1: surfaceRaised1 ?? this.surfaceRaised1,
      surfaceRaised2: surfaceRaised2 ?? this.surfaceRaised2,
      surfaceRaised3: surfaceRaised3 ?? this.surfaceRaised3,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      borderDefault: borderDefault ?? this.borderDefault,
      textSecondary: textSecondary ?? this.textSecondary,
      textDisabled: textDisabled ?? this.textDisabled,
      codeBlockBackground: codeBlockBackground ?? this.codeBlockBackground,
      codeBlockForeground: codeBlockForeground ?? this.codeBlockForeground,
      codeBlockMuted: codeBlockMuted ?? this.codeBlockMuted,
    );
  }

  @override
  ForenColors lerp(ThemeExtension<ForenColors>? other, double t) {
    // Feature/semantic identity colors don't interpolate meaningfully
    // between two brand palettes — snap instead of blend.
    if (other is! ForenColors) return this;
    return t < 0.5 ? this : other;
  }
}

class ForenTheme {
  ForenTheme._();

  /// Dark theme — secondary experience.
  static ThemeData get dark {
    final colorScheme = ColorScheme.dark(
      brightness: Brightness.dark,
      primary: ForenFeatureColors.missionControl.t500,
      onPrimary: Colors.white,
      secondary: ForenFeatureColors.investigation.t500,
      onSecondary: Colors.white,
      tertiary: ForenFeatureColors.academy.t500,
      onTertiary: const Color(0xFF1A1300),
      error: ForenSemanticColors.critical.t500,
      onError: Colors.white,
      surface: ForenNeutralDark.bgSurface,
      onSurface: ForenNeutralDark.textPrimary,
      outline: ForenNeutralDark.borderDefault,
      outlineVariant: ForenNeutralDark.borderSubtle,
    );

    return _buildTheme(
      colorScheme: colorScheme,
      neutralBgBase: ForenNeutralDark.bgBase,
      neutralTextPrimary: ForenNeutralDark.textPrimary,
      neutralTextSecondary: ForenNeutralDark.textSecondary,
      neutralBorderDefault: ForenNeutralDark.borderDefault,
      extension: ForenColors.dark,
      brightness: Brightness.dark,
    );
  }

  /// Light theme — primary ForenShield experience.
  static ThemeData get light {
    final colorScheme = ColorScheme.light(
      brightness: Brightness.light,
      primary: ForenFeatureColors.missionControl.t500,
      onPrimary: Colors.white,
      secondary: ForenFeatureColors.investigation.t700,
      onSecondary: Colors.white,
      tertiary: ForenFeatureColors.academy.t700,
      onTertiary: Colors.white,
      error: ForenSemanticColors.critical.t700,
      onError: Colors.white,
      surface: ForenNeutralLight.bgSurface,
      onSurface: ForenNeutralLight.textPrimary,
      outline: ForenNeutralLight.borderDefault,
      outlineVariant: ForenNeutralLight.borderSubtle,
    );

    return _buildTheme(
      colorScheme: colorScheme,
      neutralBgBase: ForenNeutralLight.bgBase,
      neutralTextPrimary: ForenNeutralLight.textPrimary,
      neutralTextSecondary: ForenNeutralLight.textSecondary,
      neutralBorderDefault: ForenNeutralLight.borderDefault,
      extension: ForenColors.light,
      brightness: Brightness.light,
    );
  }

  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required Color neutralBgBase,
    required Color neutralTextPrimary,
    required Color neutralTextSecondary,
    required Color neutralBorderDefault,
    required ForenColors extension,
    required Brightness brightness,
  }) {
    final textTheme = ForenTypography.buildTextTheme(neutralTextPrimary);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: neutralBgBase,
      textTheme: textTheme,
      extensions: [extension],

      appBarTheme: AppBarTheme(
        backgroundColor: neutralBgBase,
        foregroundColor: neutralTextPrimary,
        elevation: ForenElevation.level0,
        centerTitle: false,
        titleTextStyle: textTheme.headlineSmall,
      ),

      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: ForenElevation.level1,
        shape: ForenRadius.cardShape,
        margin: EdgeInsets.zero,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: extension.surfaceRaised3,
        shape: ForenRadius.dialogShape,
        elevation: ForenElevation.level3,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: ForenSpace.lg,
            vertical: ForenSpace.md,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(ForenRadius.button)),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: neutralTextPrimary,
          side: BorderSide(
            color: neutralBorderDefault,
            width: ForenBorderWidth.defaultWidth,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: ForenSpace.lg,
            vertical: ForenSpace.md,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(ForenRadius.button)),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: ForenSpace.md,
            vertical: ForenSpace.sm,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(ForenRadius.button)),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: extension.surfaceRaised1,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: ForenSpace.md,
          vertical: ForenSpace.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: extension.borderDefault,
            width: ForenBorderWidth.defaultWidth,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: extension.borderDefault,
            width: ForenBorderWidth.defaultWidth,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: ForenBorderWidth.focus,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: ForenBorderWidth.error,
          ),
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: extension.textDisabled,
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: extension.surfaceRaised1,
        labelStyle: textTheme.labelMedium,
        padding: const EdgeInsets.symmetric(
          horizontal: ForenSpace.sm,
          vertical: ForenSpace.xs,
        ),
        shape: const StadiumBorder(),
        side: BorderSide.none,
      ),

      dividerTheme: DividerThemeData(
        color: extension.borderSubtle,
        thickness: ForenBorderWidth.hairline,
        space: ForenSpace.md,
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: neutralBgBase,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.16),
        elevation: 0,
        labelTextStyle: WidgetStateProperty.all(textTheme.labelSmall),
      ),

      // ── Missing component themes (Phase 1) ──
      snackBarTheme: SnackBarThemeData(
        backgroundColor: extension.surfaceRaised3,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
        actionTextColor: colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ForenRadius.cardSmall),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: ForenElevation.level2,
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(ForenRadius.dialog),
          ),
        ),
        elevation: ForenElevation.level3,
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onPrimary;
          }
          return neutralTextSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return extension.surfaceRaised2;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.transparent;
          }
          return extension.borderDefault;
        }),
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(colorScheme.onPrimary),
        side: BorderSide(
          color: extension.borderDefault,
          width: ForenBorderWidth.defaultWidth,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return extension.borderDefault;
        }),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: extension.surfaceRaised1,
        circularTrackColor: extension.surfaceRaised1,
      ),

      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: brightness == Brightness.dark
              ? extension.surfaceRaised3
              : colorScheme.onSurface,
          borderRadius: BorderRadius.circular(ForenRadius.button),
        ),
        textStyle: textTheme.bodySmall?.copyWith(
          color: brightness == Brightness.dark
              ? colorScheme.onSurface
              : colorScheme.surface,
        ),
      ),

      popupMenuTheme: PopupMenuThemeData(
        color: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: ForenElevation.level2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ForenRadius.cardSmall),
        ),
        textStyle: textTheme.bodyMedium,
      ),

      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
        size: ForenIconSize.defaultSize,
      ),

      listTileTheme: ListTileThemeData(
        textColor: colorScheme.onSurface,
        iconColor: neutralTextSecondary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: ForenSpace.lg,
          vertical: ForenSpace.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ForenRadius.cardSmall),
        ),
      ),

      tabBarTheme: TabBarThemeData(
        labelColor: colorScheme.primary,
        unselectedLabelColor: neutralTextSecondary,
        indicatorColor: colorScheme.primary,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: textTheme.labelLarge,
        unselectedLabelStyle: textTheme.labelLarge,
      ),

      drawerTheme: DrawerThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: ForenElevation.level2,
      ),

      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: _ForenSoftFadeThroughBuilder(),
          TargetPlatform.iOS: _ForenSoftFadeThroughBuilder(),
          TargetPlatform.macOS: _ForenSoftFadeThroughBuilder(),
        },
      ),
    );
  }
}

class _ForenSoftFadeThroughBuilder extends PageTransitionsBuilder {
  const _ForenSoftFadeThroughBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Soft scale-up and fade, replicating SharedAxis/FadeThrough organic feel.
    final CurveTween easeInTween = CurveTween(curve: Curves.easeIn);

    return FadeTransition(
      opacity: animation.drive(easeInTween),
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.96, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCirc),
        ),
        child: child,
      ),
    );
  }
}
