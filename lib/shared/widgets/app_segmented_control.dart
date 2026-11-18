import 'package:call_filter/app/theme/app_spacing.dart';
import 'package:call_filter/app/theme/app_theme_context.dart';
import 'package:material_ui/material_ui.dart';

class AppSegmentedOption<T> {
  const AppSegmentedOption({
    required this.value,
    required this.label,
    this.key,
    this.icon,
  });

  final T value;
  final String label;
  final Key? key;
  final IconData? icon;
}

/// Single-choice Material 3 segmented control.
///
/// Use it for a small, mutually exclusive filter set. It is intentionally
/// typed and smaller than a generic segmented-button abstraction.
class AppSegmentedControl<T> extends StatelessWidget {
  const AppSegmentedControl({
    required this.options,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final List<AppSegmentedOption<T>> options;
  final T selected;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<T>(
      segments: [
        for (final option in options)
          ButtonSegment<T>(
            value: option.value,
            icon: option.icon == null ? null : Icon(option.icon),
            label: Text(option.label, key: option.key),
          ),
      ],
      selected: {selected},
      onSelectionChanged: (values) {
        if (values.isNotEmpty) {
          onSelected(values.first);
        }
      },
      style: ButtonStyle(
        textStyle: WidgetStatePropertyAll(
          context.labelStyle.copyWith(fontSize: 12),
        ),
        minimumSize: const WidgetStatePropertyAll(Size(0, 48)),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        ),
      ),
    );
  }
}
