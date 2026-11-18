import 'package:material_ui/material_ui.dart';

class AppSwitch extends StatelessWidget {
  const AppSwitch({
    required this.value,
    required this.onChanged,
    required this.semanticLabel,
    super.key,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      toggled: value,
      child: ExcludeSemantics(
        child: Switch.adaptive(value: value, onChanged: onChanged),
      ),
    );
  }
}
