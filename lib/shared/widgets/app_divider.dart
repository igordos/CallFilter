import 'package:call_filter/app/theme/app_theme_context.dart';
import 'package:material_ui/material_ui.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({this.indent = 0, super.key});

  final double indent;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: indent,
      color: context.appColors.borderSubtle,
    );
  }
}
