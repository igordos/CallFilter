import 'package:material_ui/material_ui.dart';

/// Semantic Material 3 colour roles shared by the whole application.
///
/// The legacy short names (`foreground`, `surfaceSecondary`, `border`, ...) are
/// kept as aliases so existing widgets and tests stay focused on intent rather
/// than on a particular Material version.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.surface,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.info,
    required this.onInfo,
    required this.infoContainer,
    required this.onInfoContainer,
  });

  /// Cobalt + teal identity. The primary is deliberately not Flutter's default
  /// Material seed purple; tertiary adds a calm signal accent for protection.
  static const AppColors light = AppColors(
    background: Color(0xFFF8F9FF),
    surface: Color(0xFFF8F9FF),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFF2F3FA),
    surfaceContainer: Color(0xFFECEEF5),
    surfaceContainerHigh: Color(0xFFE6E8EF),
    surfaceContainerHighest: Color(0xFFE0E2E9),
    onSurface: Color(0xFF191C20),
    onSurfaceVariant: Color(0xFF44474F),
    outline: Color(0xFF74777F),
    outlineVariant: Color(0xFFC4C6D0),
    primary: Color(0xFF2956D9),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFDCE1FF),
    onPrimaryContainer: Color(0xFF00174B),
    secondary: Color(0xFF5A5D72),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFDFE1F9),
    onSecondaryContainer: Color(0xFF171A2C),
    tertiary: Color(0xFF00696E),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFB0ECEE),
    onTertiaryContainer: Color(0xFF002021),
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    success: Color(0xFF146C43),
    onSuccess: Color(0xFFFFFFFF),
    successContainer: Color(0xFFC8F0D8),
    onSuccessContainer: Color(0xFF00210E),
    warning: Color(0xFF8A5A00),
    onWarning: Color(0xFFFFFFFF),
    warningContainer: Color(0xFFFFDEA6),
    onWarningContainer: Color(0xFF2B1700),
    info: Color(0xFF315DAF),
    onInfo: Color(0xFFFFFFFF),
    infoContainer: Color(0xFFD8E2FF),
    onInfoContainer: Color(0xFF001A42),
  );

  static const AppColors dark = AppColors(
    background: Color(0xFF111318),
    surface: Color(0xFF111318),
    surfaceContainerLowest: Color(0xFF0C0E13),
    surfaceContainerLow: Color(0xFF191C20),
    surfaceContainer: Color(0xFF1D2024),
    surfaceContainerHigh: Color(0xFF282A2F),
    surfaceContainerHighest: Color(0xFF33353A),
    onSurface: Color(0xFFE2E2E9),
    onSurfaceVariant: Color(0xFFC4C6D0),
    outline: Color(0xFF8E9099),
    outlineVariant: Color(0xFF44474F),
    primary: Color(0xFFB4C5FF),
    onPrimary: Color(0xFF002E6A),
    primaryContainer: Color(0xFF1B459F),
    onPrimaryContainer: Color(0xFFDCE1FF),
    secondary: Color(0xFFC3C5DD),
    onSecondary: Color(0xFF2D2F42),
    secondaryContainer: Color(0xFF434659),
    onSecondaryContainer: Color(0xFFDFE1F9),
    tertiary: Color(0xFF82D5D7),
    onTertiary: Color(0xFF003739),
    tertiaryContainer: Color(0xFF005053),
    onTertiaryContainer: Color(0xFF9EF1F3),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    success: Color(0xFF7DDBA6),
    onSuccess: Color(0xFF00391F),
    successContainer: Color(0xFF00522F),
    onSuccessContainer: Color(0xFFC8F0D8),
    warning: Color(0xFFF5BD52),
    onWarning: Color(0xFF452B00),
    warningContainer: Color(0xFF624000),
    onWarningContainer: Color(0xFFFFDEA6),
    info: Color(0xFFADC6FF),
    onInfo: Color(0xFF002D6A),
    infoContainer: Color(0xFF16478F),
    onInfoContainer: Color(0xFFD8E2FF),
  );

  final Color background;
  final Color surface;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
  final Color onSurface;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color onWarningContainer;
  final Color info;
  final Color onInfo;
  final Color infoContainer;
  final Color onInfoContainer;

  Color get surfaceSecondary => surfaceContainer;
  Color get surfaceElevated => surfaceContainerLowest;
  Color get foreground => onSurface;
  Color get foregroundSecondary => onSurfaceVariant;
  Color get foregroundMuted => outline;
  Color get border => outlineVariant;
  Color get borderSubtle => surfaceContainerHigh;
  Color get primaryForeground => onPrimary;
  Color get primarySurface => primaryContainer;
  Color get successSurface => successContainer;
  Color get warningSurface => warningContainer;
  Color get errorSurface => errorContainer;
  Color get infoSurface => infoContainer;

  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceContainerLowest,
    Color? surfaceContainerLow,
    Color? surfaceContainer,
    Color? surfaceContainerHigh,
    Color? surfaceContainerHighest,
    Color? onSurface,
    Color? onSurfaceVariant,
    Color? outline,
    Color? outlineVariant,
    Color? primary,
    Color? onPrimary,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? secondary,
    Color? onSecondary,
    Color? secondaryContainer,
    Color? onSecondaryContainer,
    Color? tertiary,
    Color? onTertiary,
    Color? tertiaryContainer,
    Color? onTertiaryContainer,
    Color? error,
    Color? onError,
    Color? errorContainer,
    Color? onErrorContainer,
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? info,
    Color? onInfo,
    Color? infoContainer,
    Color? onInfoContainer,
  }) {
    return AppColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceContainerLowest:
          surfaceContainerLowest ?? this.surfaceContainerLowest,
      surfaceContainerLow: surfaceContainerLow ?? this.surfaceContainerLow,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh ?? this.surfaceContainerHigh,
      surfaceContainerHighest:
          surfaceContainerHighest ?? this.surfaceContainerHighest,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
      outline: outline ?? this.outline,
      outlineVariant: outlineVariant ?? this.outlineVariant,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      secondaryContainer: secondaryContainer ?? this.secondaryContainer,
      onSecondaryContainer: onSecondaryContainer ?? this.onSecondaryContainer,
      tertiary: tertiary ?? this.tertiary,
      onTertiary: onTertiary ?? this.onTertiary,
      tertiaryContainer: tertiaryContainer ?? this.tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer ?? this.onTertiaryContainer,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      errorContainer: errorContainer ?? this.errorContainer,
      onErrorContainer: onErrorContainer ?? this.onErrorContainer,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      infoContainer: infoContainer ?? this.infoContainer,
      onInfoContainer: onInfoContainer ?? this.onInfoContainer,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceContainerLowest: Color.lerp(
        surfaceContainerLowest,
        other.surfaceContainerLowest,
        t,
      )!,
      surfaceContainerLow: Color.lerp(
        surfaceContainerLow,
        other.surfaceContainerLow,
        t,
      )!,
      surfaceContainer: Color.lerp(
        surfaceContainer,
        other.surfaceContainer,
        t,
      )!,
      surfaceContainerHigh: Color.lerp(
        surfaceContainerHigh,
        other.surfaceContainerHigh,
        t,
      )!,
      surfaceContainerHighest: Color.lerp(
        surfaceContainerHighest,
        other.surfaceContainerHighest,
        t,
      )!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      onSurfaceVariant: Color.lerp(
        onSurfaceVariant,
        other.onSurfaceVariant,
        t,
      )!,
      outline: Color.lerp(outline, other.outline, t)!,
      outlineVariant: Color.lerp(outlineVariant, other.outlineVariant, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      primaryContainer: Color.lerp(
        primaryContainer,
        other.primaryContainer,
        t,
      )!,
      onPrimaryContainer: Color.lerp(
        onPrimaryContainer,
        other.onPrimaryContainer,
        t,
      )!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t)!,
      secondaryContainer: Color.lerp(
        secondaryContainer,
        other.secondaryContainer,
        t,
      )!,
      onSecondaryContainer: Color.lerp(
        onSecondaryContainer,
        other.onSecondaryContainer,
        t,
      )!,
      tertiary: Color.lerp(tertiary, other.tertiary, t)!,
      onTertiary: Color.lerp(onTertiary, other.onTertiary, t)!,
      tertiaryContainer: Color.lerp(
        tertiaryContainer,
        other.tertiaryContainer,
        t,
      )!,
      onTertiaryContainer: Color.lerp(
        onTertiaryContainer,
        other.onTertiaryContainer,
        t,
      )!,
      error: Color.lerp(error, other.error, t)!,
      onError: Color.lerp(onError, other.onError, t)!,
      errorContainer: Color.lerp(errorContainer, other.errorContainer, t)!,
      onErrorContainer: Color.lerp(
        onErrorContainer,
        other.onErrorContainer,
        t,
      )!,
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      successContainer: Color.lerp(
        successContainer,
        other.successContainer,
        t,
      )!,
      onSuccessContainer: Color.lerp(
        onSuccessContainer,
        other.onSuccessContainer,
        t,
      )!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      warningContainer: Color.lerp(
        warningContainer,
        other.warningContainer,
        t,
      )!,
      onWarningContainer: Color.lerp(
        onWarningContainer,
        other.onWarningContainer,
        t,
      )!,
      info: Color.lerp(info, other.info, t)!,
      onInfo: Color.lerp(onInfo, other.onInfo, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      onInfoContainer: Color.lerp(onInfoContainer, other.onInfoContainer, t)!,
    );
  }
}
