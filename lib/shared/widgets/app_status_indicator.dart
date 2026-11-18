import 'package:call_filter/app/theme/app_spacing.dart';
import 'package:call_filter/app/theme/app_theme_context.dart';
import 'package:material_ui/material_ui.dart';

enum AppStatusTone { active, success, error, neutral }

/// Expressive tonal status surface for protection and screening decisions.
///
/// It is intentionally not a generic card: the icon tile, tonal container,
/// live-region semantics and animated state change are the shared status
/// pattern used on the dashboard and in the caller-check sheet.
class AppStatusIndicator extends StatelessWidget {
  const AppStatusIndicator({
    required this.title,
    required this.description,
    required this.icon,
    this.tone = AppStatusTone.active,
    this.trailing,
    this.semanticLabel,
    super.key,
  });

  final String title;
  final String description;
  final IconData icon;
  final AppStatusTone tone;
  final Widget? trailing;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final (
      background,
      foreground,
      tileBackground,
      tileForeground,
      border,
    ) = switch (tone) {
      AppStatusTone.active => (
        colors.primaryContainer,
        colors.onPrimaryContainer,
        colors.primary,
        colors.onPrimary,
        colors.primary.withValues(alpha: 0.24),
      ),
      AppStatusTone.success => (
        colors.successContainer,
        colors.onSuccessContainer,
        colors.success,
        colors.onSuccess,
        colors.success.withValues(alpha: 0.24),
      ),
      AppStatusTone.error => (
        colors.errorContainer,
        colors.onErrorContainer,
        colors.error,
        colors.onError,
        colors.error.withValues(alpha: 0.24),
      ),
      AppStatusTone.neutral => (
        colors.surfaceContainerHigh,
        colors.onSurface,
        colors.surfaceContainerHighest,
        colors.onSurfaceVariant,
        colors.outlineVariant,
      ),
    };
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : AppMotion.normal;

    return Semantics(
      container: true,
      liveRegion: true,
      label: semanticLabel,
      child: AnimatedContainer(
        duration: duration,
        curve: AppMotion.state,
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: background,
          borderRadius: AppRadius.card,
          border: Border.all(color: border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: tileBackground,
                borderRadius: AppRadius.large,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Icon(
                  icon,
                  size: AppSizes.iconHero,
                  color: tileForeground,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedSwitcher(
                    duration: duration,
                    switchInCurve: AppMotion.enter,
                    switchOutCurve: AppMotion.exit,
                    child: Text(
                      title,
                      key: ValueKey(title),
                      style: context.headlineStyle.copyWith(color: foreground),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    description,
                    style: context.bodySmallStyle.copyWith(
                      color: foreground.withValues(alpha: 0.82),
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: AppSpacing.sm),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
