import 'package:call_filter/app/theme/app_spacing.dart';
import 'package:call_filter/app/theme/app_theme_context.dart';
import 'package:material_ui/material_ui.dart';

class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader(this.title, {this.trailing, super.key});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.xxl,
        AppSpacing.page,
        AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: context.labelStyle.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
