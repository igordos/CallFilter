import 'package:call_filter/app/theme/app_colors.dart';
import 'package:call_filter/app/theme/app_spacing.dart';
import 'package:call_filter/app/theme/app_theme_context.dart';
import 'package:material_ui/material_ui.dart';

enum AppButtonVariant { primary, secondary, tertiary, destructive }

/// Material 3 Expressive button.
///
/// Primary/destructive actions use a full pill; tonal and text actions use the
/// softer control shape. The label can wrap to two lines so long Russian
/// translations do not overflow the minimum tap target.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.expand = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isEnabled = onPressed != null && !isLoading;
    final foreground = switch (variant) {
      AppButtonVariant.primary => colors.onPrimary,
      AppButtonVariant.secondary => colors.onSecondaryContainer,
      AppButtonVariant.tertiary => colors.primary,
      AppButtonVariant.destructive => colors.onError,
    };
    final disabledForeground = colors.onSurface.withValues(alpha: 0.38);
    final labelWidget = Text(
      label,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          SizedBox.square(
            dimension: AppSizes.iconSmall,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: isEnabled ? foreground : disabledForeground,
            ),
          )
        else if (icon != null)
          Icon(icon, size: AppSizes.icon),
        if (isLoading || icon != null) const SizedBox(width: AppSpacing.sm),
        Flexible(child: labelWidget),
      ],
    );

    final style = _style(
      context: context,
      colors: colors,
      foreground: foreground,
      disabledForeground: disabledForeground,
    );

    final button = switch (variant) {
      AppButtonVariant.primary || AppButtonVariant.destructive => FilledButton(
        onPressed: isEnabled ? onPressed : null,
        style: style,
        child: content,
      ),
      AppButtonVariant.secondary => FilledButton.tonal(
        onPressed: isEnabled ? onPressed : null,
        style: style,
        child: content,
      ),
      AppButtonVariant.tertiary => TextButton(
        onPressed: isEnabled ? onPressed : null,
        style: style,
        child: content,
      ),
    };

    final sized = expand
        ? SizedBox(width: double.infinity, child: button)
        : button;

    return Semantics(
      button: true,
      enabled: isEnabled,
      label: label,
      child: sized,
    );
  }

  ButtonStyle _style({
    required BuildContext context,
    required AppColors colors,
    required Color foreground,
    required Color disabledForeground,
  }) {
    final background = switch (variant) {
      AppButtonVariant.primary => colors.primary,
      AppButtonVariant.secondary => colors.secondaryContainer,
      AppButtonVariant.tertiary => Colors.transparent,
      AppButtonVariant.destructive => colors.error,
    };
    final shape = switch (variant) {
      AppButtonVariant.primary ||
      AppButtonVariant.destructive => const StadiumBorder(),
      _ => const RoundedRectangleBorder(borderRadius: AppRadius.control),
    };

    return ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.disabled)
            ? disabledForeground
            : foreground,
      ),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (!states.contains(WidgetState.disabled)) {
          return background;
        }
        return variant == AppButtonVariant.tertiary
            ? Colors.transparent
            : colors.surfaceContainerHighest;
      }),
      overlayColor: WidgetStatePropertyAll(foreground.withValues(alpha: 0.10)),
      side: const WidgetStatePropertyAll(BorderSide.none),
      elevation: const WidgetStatePropertyAll(0),
      minimumSize: const WidgetStatePropertyAll(
        Size(0, AppSizes.controlHeight),
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      ),
      shape: WidgetStatePropertyAll(shape),
      textStyle: WidgetStatePropertyAll(context.labelStyle),
    );
  }
}
