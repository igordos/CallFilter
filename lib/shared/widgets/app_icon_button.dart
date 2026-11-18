import 'package:call_filter/app/theme/app_spacing.dart';
import 'package:call_filter/app/theme/app_theme_context.dart';
import 'package:material_ui/material_ui.dart';

enum AppIconButtonVariant { neutral, destructive }

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.icon,
    required this.tooltip,
    this.onPressed,
    this.variant = AppIconButtonVariant.neutral,
    super.key,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final AppIconButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final (foreground, background) = switch (variant) {
      AppIconButtonVariant.neutral => (
        colors.onSurfaceVariant,
        colors.surfaceContainerHigh,
      ),
      AppIconButtonVariant.destructive => (
        colors.onErrorContainer,
        colors.errorContainer,
      ),
    };

    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon, size: AppSizes.icon),
      style: IconButton.styleFrom(
        foregroundColor: foreground,
        backgroundColor: background,
        disabledForegroundColor: colors.onSurface.withValues(alpha: 0.38),
        disabledBackgroundColor: colors.surfaceContainer,
        minimumSize: const Size.square(AppSizes.minTapTarget),
        padding: const EdgeInsets.all(AppSpacing.md),
        shape: const CircleBorder(),
      ),
    );
  }
}
