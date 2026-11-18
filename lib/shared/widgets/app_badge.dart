import 'package:call_filter/app/theme/app_spacing.dart';
import 'package:call_filter/app/theme/app_theme_context.dart';
import 'package:material_ui/material_ui.dart';

enum AppBadgeVariant {
  neutral,
  primary,
  tertiary,
  success,
  warning,
  error,
  info,
}

/// Small tonal status label. The text always carries the meaning; colour is
/// reinforcement only.
class AppBadge extends StatelessWidget {
  const AppBadge({
    required this.label,
    this.variant = AppBadgeVariant.neutral,
    this.icon,
    super.key,
  });

  final String label;
  final AppBadgeVariant variant;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final (foreground, background) = switch (variant) {
      AppBadgeVariant.neutral => (
        colors.onSurfaceVariant,
        colors.surfaceContainerHigh,
      ),
      AppBadgeVariant.primary => (
        colors.onPrimaryContainer,
        colors.primaryContainer,
      ),
      AppBadgeVariant.tertiary => (
        colors.onTertiaryContainer,
        colors.tertiaryContainer,
      ),
      AppBadgeVariant.success => (
        colors.onSuccessContainer,
        colors.successContainer,
      ),
      AppBadgeVariant.warning => (
        colors.onWarningContainer,
        colors.warningContainer,
      ),
      AppBadgeVariant.error => (colors.onErrorContainer, colors.errorContainer),
      AppBadgeVariant.info => (colors.onInfoContainer, colors.infoContainer),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadius.full,
        border: Border.all(color: foreground.withValues(alpha: 0.14)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 3,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 12, color: foreground),
              const SizedBox(width: AppSpacing.xs),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.captionStyle.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
