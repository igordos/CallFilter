import 'package:call_filter/app/theme/app_spacing.dart';
import 'package:call_filter/app/theme/app_theme_context.dart';
import 'package:call_filter/shared/widgets/app_button.dart';
import 'package:material_ui/material_ui.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    required this.title,
    required this.content,
    required this.actions,
    super.key,
  });

  final String title;
  final Widget content;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Dialog(
      backgroundColor: colors.surfaceContainerHigh,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.all(AppSpacing.xxl),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.dialog,
        side: BorderSide(color: colors.outlineVariant),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: AppSizes.dialogMaxWidth,
          maxHeight: MediaQuery.sizeOf(context).height * 0.82,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: context.headlineStyle),
              const SizedBox(height: AppSpacing.md),
              Flexible(child: SingleChildScrollView(child: content)),
              const SizedBox(height: AppSpacing.xl),
              Wrap(
                alignment: WrapAlignment.end,
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: actions,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> showAppConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String confirmLabel,
  required String cancelLabel,
  bool destructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AppDialog(
      title: title,
      content: Text(message, style: dialogContext.bodyStyle),
      actions: [
        AppButton(
          label: cancelLabel,
          variant: AppButtonVariant.secondary,
          onPressed: () => Navigator.of(dialogContext).pop(false),
        ),
        AppButton(
          label: confirmLabel,
          variant: destructive
              ? AppButtonVariant.destructive
              : AppButtonVariant.primary,
          onPressed: () => Navigator.of(dialogContext).pop(true),
        ),
      ],
    ),
  );
  return result ?? false;
}
