import 'dart:async';

import 'package:call_filter/app/theme/app_spacing.dart';
import 'package:call_filter/app/theme/app_theme_context.dart';
import 'package:call_filter/core/di/providers.dart';
import 'package:call_filter/features/call_filter/domain/platform_capabilities.dart';
import 'package:call_filter/features/settings/domain/app_settings.dart';
import 'package:call_filter/features/settings/presentation/settings_controller.dart';
import 'package:call_filter/l10n/gen/app_localizations.dart';
import 'package:call_filter/shared/widgets/app_badge.dart';
import 'package:call_filter/shared/widgets/app_button.dart';
import 'package:call_filter/shared/widgets/app_card.dart';
import 'package:call_filter/shared/widgets/app_divider.dart';
import 'package:call_filter/shared/widgets/app_list_tile.dart';
import 'package:call_filter/shared/widgets/app_scaffold.dart';
import 'package:call_filter/shared/widgets/app_section_header.dart';
import 'package:call_filter/shared/widgets/app_select_tile.dart';
import 'package:call_filter/shared/widgets/app_snackbars.dart';
import 'package:call_filter/shared/widgets/app_state_views.dart';
import 'package:call_filter/shared/widgets/app_switch.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsControllerProvider);
    final settingsValue = settings.asData?.value;
    final capabilities = ref.watch(platformCapabilitiesProvider);

    return AppScaffold(
      title: l10n.settingsTitle,
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xxxl),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.page,
              AppSpacing.md,
              AppSpacing.page,
              0,
            ),
            child: AppCard(
              variant: AppCardVariant.primary,
              child: Row(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: context.appColors.primary,
                      borderRadius: AppRadius.large,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Icon(
                        Icons.shield_outlined,
                        size: AppSizes.iconHero,
                        color: context.appColors.onPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.appTitle,
                          style: context.headlineStyle.copyWith(
                            color: context.appColors.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          l10n.settingsFilteringSubtitle,
                          style: context.bodySmallStyle.copyWith(
                            color: context.appColors.onPrimaryContainer
                                .withValues(alpha: 0.82),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppSectionHeader(l10n.settingsAppearanceTitle),
          _SettingsCard(
            child: Column(
              children: [
                AppSelectTile<AppThemeMode>(
                  key: const Key('theme_selector'),
                  title: l10n.settingsThemeTitle,
                  icon: Icons.brightness_6_outlined,
                  value: settingsValue?.themeMode ?? AppThemeMode.system,
                  options: [
                    AppSelectOption(
                      value: AppThemeMode.system,
                      label: l10n.settingsThemeSystem,
                    ),
                    AppSelectOption(
                      value: AppThemeMode.light,
                      label: l10n.settingsThemeLight,
                    ),
                    AppSelectOption(
                      value: AppThemeMode.dark,
                      label: l10n.settingsThemeDark,
                    ),
                  ],
                  onSelected: (mode) => _setTheme(context, ref, mode),
                ),
                const AppDivider(),
                AppSelectTile<String>(
                  key: const Key('language_dropdown'),
                  title: l10n.settingsLanguage,
                  icon: Icons.translate_outlined,
                  value: settingsValue?.localeCode ?? 'system',
                  options: [
                    AppSelectOption(
                      value: 'system',
                      label: l10n.settingsLanguageSystem,
                    ),
                    AppSelectOption(
                      value: 'en',
                      label: l10n.settingsLanguageEnglish,
                    ),
                    AppSelectOption(
                      value: 'ru',
                      label: l10n.settingsLanguageRussian,
                    ),
                  ],
                  onSelected: (value) => _setLocale(context, ref, value),
                ),
              ],
            ),
          ),
          AppSectionHeader(l10n.settingsFilteringTitle),
          _SettingsCard(
            child: Column(
              children: [
                AppListTile(
                  leading: const Icon(Icons.shield_outlined),
                  title: Text(l10n.settingsFilteringTitle),
                  subtitle: Text(l10n.settingsFilteringSubtitle),
                  trailing: AppSwitch(
                    key: const Key('settings_filtering_switch'),
                    value: settingsValue?.filteringEnabled ?? true,
                    semanticLabel: l10n.settingsFilteringTitle,
                    onChanged: settingsValue == null
                        ? null
                        : (enabled) =>
                              unawaited(_setFiltering(context, ref, enabled)),
                  ),
                ),
                const AppDivider(),
                AppListTile(
                  leading: const Icon(Icons.receipt_long_outlined),
                  title: Text(l10n.settingsLogTitle),
                  subtitle: Text(l10n.settingsLogSubtitle),
                  trailing: AppSwitch(
                    key: const Key('settings_log_switch'),
                    value: settingsValue?.logBlockedCalls ?? true,
                    semanticLabel: l10n.settingsLogTitle,
                    onChanged: settingsValue == null
                        ? null
                        : (enabled) =>
                              unawaited(_setLogging(context, ref, enabled)),
                  ),
                ),
              ],
            ),
          ),
          AppSectionHeader(l10n.settingsPlatformTitle),
          capabilities.when(
            loading: () => const AppLoadingState(),
            error: (error, stackTrace) => AppErrorState(
              onRetry: () => ref.invalidate(platformCapabilitiesProvider),
            ),
            data: (value) => _PlatformPanel(capabilities: value),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.page,
              AppSpacing.md,
              AppSpacing.page,
              0,
            ),
            child: Text(
              l10n.settingsPlatformExperimental,
              style: context.bodySmallStyle,
            ),
          ),
          AppSectionHeader(l10n.settingsAboutTitle),
          _SettingsCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.appTitle, style: context.headlineStyle),
                const SizedBox(height: AppSpacing.sm),
                Text(l10n.settingsAboutBody, style: context.bodySmallStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _setTheme(
    BuildContext context,
    WidgetRef ref,
    AppThemeMode mode,
  ) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ref.read(settingsControllerProvider.notifier).setThemeMode(mode);
    } on Object catch (error) {
      if (context.mounted) {
        showAppError(context, error, l10n.errorGeneric);
      }
    }
  }

  Future<void> _setLocale(
    BuildContext context,
    WidgetRef ref,
    String value,
  ) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ref
          .read(settingsControllerProvider.notifier)
          .setLocale(value == 'system' ? null : value);
    } on Object catch (error) {
      if (context.mounted) {
        showAppError(context, error, l10n.errorGeneric);
      }
    }
  }

  Future<void> _setFiltering(
    BuildContext context,
    WidgetRef ref,
    bool enabled,
  ) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ref
          .read(settingsControllerProvider.notifier)
          .setFilteringEnabled(isEnabled: enabled);
    } on Object catch (error) {
      if (context.mounted) {
        showAppError(context, error, l10n.errorGeneric);
      }
    }
  }

  Future<void> _setLogging(
    BuildContext context,
    WidgetRef ref,
    bool enabled,
  ) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ref
          .read(settingsControllerProvider.notifier)
          .setLogBlockedCalls(isEnabled: enabled);
    } on Object catch (error) {
      if (context.mounted) {
        showAppError(context, error, l10n.errorGeneric);
      }
    }
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.child, this.padding = EdgeInsets.zero});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
      child: AppCard(padding: padding, child: child),
    );
  }
}

class _PlatformPanel extends ConsumerWidget {
  const _PlatformPanel({required this.capabilities});

  final PlatformCapabilities capabilities;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final nativeAvailable = capabilities.hasNativeIntegration;

    return _SettingsCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  capabilities.platformName,
                  style: context.bodyStyle.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              AppBadge(
                label: nativeAvailable ? l10n.capabilityYes : l10n.capabilityNo,
                variant: nativeAvailable
                    ? AppBadgeVariant.success
                    : AppBadgeVariant.neutral,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _CapabilityRow(
            label: l10n.capabilityCallScreening,
            state: capabilities.callScreening,
          ),
          _CapabilityRow(
            label: l10n.capabilityCallerName,
            state: capabilities.callerDisplayName,
          ),
          _CapabilityRow(
            label: l10n.capabilityCallDirectory,
            state: capabilities.callDirectory,
          ),
          _CapabilityRow(
            label: l10n.capabilityNumberBlocking,
            state: capabilities.numberBlocking,
          ),
          if (capabilities.details.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(capabilities.details, style: context.bodySmallStyle),
          ],
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              AppButton(
                key: const Key('sync_platform_button'),
                label: l10n.settingsPlatformSync,
                icon: Icons.sync,
                variant: AppButtonVariant.secondary,
                onPressed: nativeAvailable
                    ? () => unawaited(_sync(context, ref))
                    : null,
              ),
              AppButton(
                key: const Key('open_platform_settings_button'),
                label: l10n.settingsPlatformOpenSettings,
                icon: Icons.open_in_new,
                variant: AppButtonVariant.tertiary,
                onPressed: nativeAvailable
                    ? () => unawaited(_openSettings(context, ref))
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _sync(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ref.read(platformSyncServiceProvider).sync();
      if (context.mounted) {
        showAppMessage(context, l10n.settingsPlatformSynced);
      }
    } on Object catch (error) {
      if (context.mounted) {
        showAppError(context, error, l10n.errorGeneric);
      }
    }
  }

  Future<void> _openSettings(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ref.read(callScreeningGatewayProvider).openSystemSettings();
    } on Object catch (error) {
      if (context.mounted) {
        showAppError(context, error, l10n.errorGeneric);
      }
    }
  }
}

class _CapabilityRow extends StatelessWidget {
  const _CapabilityRow({required this.label, required this.state});

  final String label;
  final PlatformCapabilityState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (variant, badgeLabel) = switch (state) {
      PlatformCapabilityState.available => (
        AppBadgeVariant.success,
        l10n.capabilityYes,
      ),
      PlatformCapabilityState.limited => (
        AppBadgeVariant.warning,
        l10n.capabilityLimited,
      ),
      PlatformCapabilityState.unavailable => (
        AppBadgeVariant.neutral,
        l10n.capabilityNo,
      ),
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(child: Text(label, style: context.bodyStyle)),
          AppBadge(label: badgeLabel, variant: variant),
        ],
      ),
    );
  }
}
