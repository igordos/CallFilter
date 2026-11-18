import 'package:call_filter/app/theme/app_spacing.dart';
import 'package:call_filter/app/theme/app_theme_context.dart';
import 'package:call_filter/shared/widgets/app_icon_button.dart';
import 'package:material_ui/material_ui.dart';

Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: context.appColors.foreground.withValues(alpha: 0.36),
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
        ),
        child: AppSheetSurface(child: builder(sheetContext)),
      );
    },
  );
}

class AppSheetSurface extends StatelessWidget {
  const AppSheetSurface({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: AppSizes.sheetMaxWidth,
          maxHeight: MediaQuery.sizeOf(context).height * 0.92,
        ),
        child: Material(
          color: colors.surfaceContainerLow,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.sheet,
            side: BorderSide(color: colors.outlineVariant),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.outlineVariant,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
                ),
                Flexible(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppSheetHeader extends StatelessWidget {
  const AppSheetHeader({required this.title, this.subtitle, super.key});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final l10nClose = MaterialLocalizations.of(context).closeButtonLabel;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.headlineStyle),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(subtitle!, style: context.bodySmallStyle),
                ],
              ],
            ),
          ),
          AppIconButton(
            icon: Icons.close,
            tooltip: l10nClose,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
