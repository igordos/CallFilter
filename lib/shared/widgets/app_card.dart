import 'package:call_filter/app/theme/app_spacing.dart';
import 'package:call_filter/app/theme/app_theme_context.dart';
import 'package:material_ui/material_ui.dart';

enum AppCardVariant { surface, secondary, elevated, primary, success, danger }

/// Tonal Material 3 surface used for grouped content.
///
/// Cards are for actual groups, not every list row. The default is a low tonal
/// container with a fine outline; the primary variant is reserved for the
/// protection hero.
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.onTap,
    this.variant = AppCardVariant.surface,
    this.semanticLabel,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final AppCardVariant variant;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final backgroundColor = switch (variant) {
      AppCardVariant.surface => colors.surfaceContainerLow,
      AppCardVariant.secondary => colors.surfaceContainer,
      AppCardVariant.elevated => colors.surfaceContainerHigh,
      AppCardVariant.primary => colors.primaryContainer,
      AppCardVariant.success => colors.successContainer,
      AppCardVariant.danger => colors.errorContainer,
    };
    final borderColor = switch (variant) {
      AppCardVariant.primary => colors.primary.withValues(alpha: 0.28),
      AppCardVariant.success => colors.success.withValues(alpha: 0.24),
      AppCardVariant.danger => colors.error.withValues(alpha: 0.24),
      AppCardVariant.elevated => colors.outlineVariant.withValues(alpha: 0.7),
      _ => colors.outlineVariant.withValues(alpha: 0.55),
    };

    final content = Padding(padding: padding, child: child);
    final material = Material(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.card,
        side: BorderSide(color: borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: onTap == null
          ? content
          : InkWell(onTap: onTap, borderRadius: AppRadius.card, child: content),
    );

    if (semanticLabel == null) {
      return material;
    }
    return Semantics(
      label: semanticLabel,
      button: onTap != null,
      child: material,
    );
  }
}
