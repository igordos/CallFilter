import 'package:call_filter/app/theme/app_spacing.dart';
import 'package:call_filter/app/theme/app_theme_context.dart';
import 'package:material_ui/material_ui.dart';

/// Selectable Material 3 filter chip with tonal selected state.
class AppChip extends StatelessWidget {
  const AppChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    this.icon,
    this.semanticLabel,
    super.key,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;
  final IconData? icon;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final foreground = selected
        ? colors.onSecondaryContainer
        : colors.onSurfaceVariant;
    final background = selected
        ? colors.secondaryContainer
        : colors.surfaceContainerHigh;
    final border = selected
        ? colors.secondary.withValues(alpha: 0.28)
        : colors.outlineVariant;

    return Semantics(
      button: true,
      selected: selected,
      label: semanticLabel ?? label,
      child: Material(
        color: background,
        shape: StadiumBorder(side: BorderSide(color: border)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => onSelected(!selected),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (selected || icon != null) ...[
                    Icon(
                      selected ? Icons.check : icon,
                      size: AppSizes.iconSmall,
                      color: foreground,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                  ],
                  Text(
                    label,
                    style: context.labelStyle.copyWith(color: foreground),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
