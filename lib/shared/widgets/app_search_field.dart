import 'package:call_filter/app/theme/app_spacing.dart';
import 'package:call_filter/app/theme/app_theme_context.dart';
import 'package:material_ui/material_ui.dart';

class AppSearchField extends StatefulWidget {
  const AppSearchField({
    required this.hintText,
    required this.clearTooltip,
    this.fieldKey,
    this.controller,
    this.onChanged,
    super.key,
  });

  final String hintText;
  final String clearTooltip;
  final Key? fieldKey;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();
  late final bool _ownsController = widget.controller == null;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final hasText = _controller.text.isNotEmpty;
    return Semantics(
      label: widget.hintText,
      child: TextField(
        key: widget.fieldKey,
        controller: _controller,
        onChanged: widget.onChanged,
        textInputAction: TextInputAction.search,
        style: context.bodyStyle,
        decoration: InputDecoration(
          hintText: widget.hintText,
          filled: true,
          fillColor: colors.surfaceContainerHigh,
          prefixIcon: Icon(
            Icons.search,
            size: AppSizes.icon,
            color: colors.onSurfaceVariant,
          ),
          suffixIcon: hasText
              ? IconButton(
                  tooltip: widget.clearTooltip,
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged?.call('');
                  },
                  icon: const Icon(Icons.close, size: AppSizes.iconSmall),
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          border: const OutlineInputBorder(
            borderRadius: AppRadius.full,
            borderSide: BorderSide.none,
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: AppRadius.full,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.full,
            borderSide: BorderSide(color: colors.primary, width: 1.4),
          ),
        ),
      ),
    );
  }
}
