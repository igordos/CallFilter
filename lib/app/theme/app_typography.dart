import 'package:call_filter/app/theme/app_colors.dart';
import 'package:material_ui/material_ui.dart';

/// Material 3 expressive type scale.
///
/// The platform font is intentional. Character comes from weight, size and
/// letter-spacing rather than a bundled font dependency.
abstract final class AppTypography {
  static TextTheme textTheme(AppColors colors) {
    final onSurface = colors.onSurface;
    final onSurfaceVariant = colors.onSurfaceVariant;
    return TextTheme(
      displayLarge: TextStyle(
        color: onSurface,
        fontSize: 45,
        height: 1.12,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.2,
      ),
      displayMedium: TextStyle(
        color: onSurface,
        fontSize: 36,
        height: 1.15,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.9,
      ),
      displaySmall: TextStyle(
        color: onSurface,
        fontSize: 30,
        height: 1.2,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.6,
      ),
      headlineLarge: TextStyle(
        color: onSurface,
        fontSize: 28,
        height: 1.2,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
      ),
      headlineMedium: TextStyle(
        color: onSurface,
        fontSize: 24,
        height: 1.22,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      headlineSmall: TextStyle(
        color: onSurface,
        fontSize: 22,
        height: 1.25,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
      ),
      titleLarge: TextStyle(
        color: onSurface,
        fontSize: 20,
        height: 1.28,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
      ),
      titleMedium: TextStyle(
        color: onSurface,
        fontSize: 16,
        height: 1.35,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: TextStyle(
        color: onSurface,
        fontSize: 14,
        height: 1.35,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: onSurface,
        fontSize: 16,
        height: 1.5,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        color: onSurface,
        fontSize: 14,
        height: 1.45,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        color: onSurfaceVariant,
        fontSize: 13,
        height: 1.4,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: TextStyle(
        color: onSurface,
        fontSize: 14,
        height: 1.35,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
      labelMedium: TextStyle(
        color: onSurfaceVariant,
        fontSize: 12,
        height: 1.35,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
      ),
      labelSmall: TextStyle(
        color: onSurfaceVariant,
        fontSize: 11,
        height: 1.35,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
      ),
    );
  }
}
