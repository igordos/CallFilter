import 'package:call_filter/app/theme/app_spacing.dart';
import 'package:call_filter/app/theme/app_theme_context.dart';
import 'package:call_filter/core/errors/app_exception.dart';
import 'package:material_ui/material_ui.dart';

void showAppMessage(BuildContext context, String message) {
  _show(context, message: message, isError: false);
}

void showAppError(BuildContext context, Object error, String fallback) {
  final message = error is AppException ? error.message : fallback;
  _show(context, message: message, isError: true);
}

void _show(
  BuildContext context, {
  required String message,
  required bool isError,
}) {
  final colors = context.appColors;
  final icon = isError ? Icons.error_outline : Icons.check_circle_outline;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, size: AppSizes.iconSmall, color: colors.background),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: context.bodySmallStyle.copyWith(
                  color: colors.background,
                ),
              ),
            ),
          ],
        ),
      ),
    );
}
