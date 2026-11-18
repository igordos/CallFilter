import 'dart:async';

import 'package:call_filter/app/theme/app_spacing.dart';
import 'package:call_filter/app/theme/app_theme_context.dart';
import 'package:call_filter/shared/widgets/app_bottom_sheet.dart';
import 'package:call_filter/shared/widgets/app_list_tile.dart';
import 'package:material_ui/material_ui.dart';

class AppSelectOption<T> {
  const AppSelectOption({required this.value, required this.label});

  final T value;
  final String label;
}

class AppSelectTile<T> extends StatelessWidget {
  const AppSelectTile({
    required this.title,
    required this.value,
    required this.options,
    required this.onSelected,
    this.subtitle,
    this.icon,
    this.semanticLabel,
    super.key,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final T value;
  final List<AppSelectOption<T>> options;
  final Future<void> Function(T value) onSelected;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final selectedLabel = options
        .firstWhere(
          (option) => option.value == value,
          orElse: () => options.first,
        )
        .label;
    return AppListTile(
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle!),
      leading: icon == null ? null : Icon(icon),
      semanticLabel: semanticLabel ?? title,
      onTap: () => unawaited(_choose(context)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 150),
            child: Text(
              selectedLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: context.bodySmallStyle,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Icon(
            Icons.chevron_right,
            size: AppSizes.icon,
            color: context.appColors.foregroundMuted,
          ),
        ],
      ),
    );
  }

  Future<void> _choose(BuildContext context) async {
    final selected = await showAppBottomSheet<AppSelectOption<T>>(
      context: context,
      builder: (sheetContext) => SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppSheetHeader(title: title),
            for (final option in options)
              AppListTile(
                title: Text(option.label),
                trailing: option.value == value
                    ? Icon(
                        Icons.check,
                        size: AppSizes.icon,
                        color: context.appColors.primary,
                      )
                    : null,
                onTap: () => Navigator.of(sheetContext).pop(option),
              ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
    if (selected != null && selected.value != value) {
      await onSelected(selected.value);
    }
  }
}
