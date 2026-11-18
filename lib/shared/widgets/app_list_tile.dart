import 'package:call_filter/app/theme/app_spacing.dart';
import 'package:call_filter/app/theme/app_theme_context.dart';
import 'package:material_ui/material_ui.dart';

/// Compact Material 3 list row used inside tonal surfaces or directly on the
/// page. It deliberately has no card decoration of its own.
class AppListTile extends StatelessWidget {
  const AppListTile({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.enabled = true,
    this.semanticLabel,
    super.key,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool enabled;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final content = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Row(
          children: [
            if (leading != null) ...[
              IconTheme(
                data: IconThemeData(
                  color: enabled
                      ? colors.onSurfaceVariant
                      : colors.onSurface.withValues(alpha: 0.38),
                  size: AppSizes.iconLarge,
                ),
                child: leading!,
              ),
              const SizedBox(width: AppSpacing.lg),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  DefaultTextStyle(
                    style: context.bodyStyle.copyWith(
                      fontWeight: FontWeight.w500,
                      color: enabled
                          ? colors.onSurface
                          : colors.onSurface.withValues(alpha: 0.38),
                    ),
                    child: title,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    DefaultTextStyle(
                      style: context.bodySmallStyle.copyWith(
                        color: enabled
                            ? colors.onSurfaceVariant
                            : colors.onSurface.withValues(alpha: 0.38),
                      ),
                      child: subtitle!,
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: AppSpacing.md),
              trailing!,
            ],
          ],
        ),
      ),
    );

    final tappable = onTap != null && enabled;
    final child = Material(
      color: Colors.transparent,
      child: tappable
          ? InkWell(
              onTap: onTap,
              borderRadius: AppRadius.control,
              child: content,
            )
          : content,
    );

    return Semantics(
      button: tappable,
      enabled: enabled,
      label: semanticLabel,
      child: child,
    );
  }
}
