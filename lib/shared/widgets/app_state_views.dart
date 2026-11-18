import 'package:call_filter/app/theme/app_spacing.dart';
import 'package:call_filter/app/theme/app_theme_context.dart';
import 'package:call_filter/l10n/gen/app_localizations.dart';
import 'package:call_filter/shared/widgets/app_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    required this.icon,
    required this.title,
    required this.body,
    this.action,
    super.key,
  });

  final IconData icon;
  final String title;
  final String body;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.primarySurface,
                borderRadius: AppRadius.card,
                border: Border.all(
                  color: colors.primary.withValues(alpha: 0.18),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Icon(icon, size: 28, color: colors.primary),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: context.headlineStyle,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              body,
              textAlign: TextAlign.center,
              style: context.bodySmallStyle,
            ),
            if (action != null) ...[
              const SizedBox(height: AppSpacing.xl),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

class AppLoadingState extends StatelessWidget {
  const AppLoadingState({this.rows = 4, super.key});

  final int rows;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return Semantics(
      container: true,
      label: l10n.loading,
      child: ExcludeSemantics(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.page,
            AppSpacing.md,
            AppSpacing.page,
            AppSpacing.xxxl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < rows; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Row(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerHigh,
                          borderRadius: AppRadius.medium,
                        ),
                        child: const SizedBox.square(dimension: 40),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FractionallySizedBox(
                              widthFactor: 0.62,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: colors.surfaceContainerHigh,
                                  borderRadius: AppRadius.small,
                                ),
                                child: const SizedBox(height: 12),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            FractionallySizedBox(
                              widthFactor: 0.38,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: colors.surfaceContainer,
                                  borderRadius: AppRadius.small,
                                ),
                                child: const SizedBox(height: 10),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppErrorState extends StatelessWidget {
  const AppErrorState({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.errorSurface,
                borderRadius: AppRadius.card,
                border: Border.all(color: colors.error.withValues(alpha: 0.18)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Icon(Icons.error_outline, size: 28, color: colors.error),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              l10n.errorGeneric,
              textAlign: TextAlign.center,
              style: context.headlineStyle,
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: l10n.retry,
              variant: AppButtonVariant.secondary,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}

class AppAsyncValueView<T> extends StatelessWidget {
  const AppAsyncValueView({
    required this.value,
    required this.data,
    required this.onRetry,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(T value) data;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      loading: () => const AppLoadingState(),
      error: (error, stackTrace) => AppErrorState(onRetry: onRetry),
    );
  }
}
