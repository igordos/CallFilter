import 'dart:async';

import 'package:call_filter/app/theme/app_spacing.dart';
import 'package:call_filter/app/theme/app_theme_context.dart';
import 'package:call_filter/features/call_filter/presentation/caller_check_sheet.dart';
import 'package:call_filter/features/call_history/domain/blocked_call.dart';
import 'package:call_filter/features/call_history/presentation/call_history_controller.dart';
import 'package:call_filter/features/contacts/presentation/whitelist_controller.dart';
import 'package:call_filter/features/rules/presentation/rules_controller.dart';
import 'package:call_filter/features/settings/presentation/settings_controller.dart';
import 'package:call_filter/l10n/gen/app_localizations.dart';
import 'package:call_filter/shared/widgets/app_bottom_sheet.dart';
import 'package:call_filter/shared/widgets/app_card.dart';
import 'package:call_filter/shared/widgets/app_divider.dart';
import 'package:call_filter/shared/widgets/app_icon_button.dart';
import 'package:call_filter/shared/widgets/app_list_tile.dart';
import 'package:call_filter/shared/widgets/app_scaffold.dart';
import 'package:call_filter/shared/widgets/app_section_header.dart';
import 'package:call_filter/shared/widgets/app_snackbars.dart';
import 'package:call_filter/shared/widgets/app_status_indicator.dart';
import 'package:call_filter/shared/widgets/app_switch.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final settings = ref.watch(settingsControllerProvider);
    final rules = ref.watch(rulesControllerProvider);
    final whitelist = ref.watch(whitelistControllerProvider);
    final history = ref.watch(callHistoryControllerProvider);
    final settingsValue = settings.asData?.value;
    final filteringEnabled = settingsValue?.filteringEnabled ?? true;
    final activeRules =
        rules.asData?.value.where((rule) => rule.isEnabled).length ?? 0;
    final whitelistCount = whitelist.asData?.value.length ?? 0;
    final historyItems = history.asData?.value ?? const <BlockedCall>[];
    final recentCalls = historyItems.take(3).toList(growable: false);

    return AppScaffold(
      title: l10n.appTitle,
      actions: [
        AppIconButton(
          key: const Key('home_settings_button'),
          icon: Icons.settings_outlined,
          tooltip: l10n.navSettings,
          onPressed: () => context.go('/settings'),
        ),
        const SizedBox(width: AppSpacing.xs),
      ],
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          AppSpacing.md,
          AppSpacing.page,
          AppSpacing.xxxl,
        ),
        children: [
          AppStatusIndicator(
            title: filteringEnabled
                ? l10n.homeFilteringOn
                : l10n.homeFilteringOff,
            description: l10n.settingsFilteringSubtitle,
            icon: filteringEnabled
                ? Icons.shield_outlined
                : Icons.shield_moon_outlined,
            tone: filteringEnabled
                ? AppStatusTone.active
                : AppStatusTone.neutral,
            trailing: AppSwitch(
              key: const Key('home_filtering_switch'),
              value: filteringEnabled,
              semanticLabel: l10n.settingsFilteringTitle,
              onChanged: settingsValue == null
                  ? null
                  : (enabled) async {
                      try {
                        await ref
                            .read(settingsControllerProvider.notifier)
                            .setFilteringEnabled(isEnabled: enabled);
                      } on Object catch (error) {
                        if (context.mounted) {
                          showAppError(context, error, l10n.errorGeneric);
                        }
                      }
                    },
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            variant: AppCardVariant.secondary,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: AppSpacing.lg,
            ),
            child: Row(
              children: [
                Expanded(
                  child: _Metric(
                    key: const Key('home_blocked_metric'),
                    value: '${historyItems.length}',
                    label: l10n.navHistory,
                    icon: Icons.block_outlined,
                    accent: colors.error,
                  ),
                ),
                _MetricDivider(color: colors.outlineVariant),
                Expanded(
                  child: _Metric(
                    key: const Key('home_rules_metric'),
                    value: '$activeRules',
                    label: l10n.homeActiveRules,
                    icon: Icons.rule_folder_outlined,
                    accent: colors.primary,
                  ),
                ),
                _MetricDivider(color: colors.outlineVariant),
                Expanded(
                  child: _Metric(
                    key: const Key('home_whitelist_metric'),
                    value: '$whitelistCount',
                    label: l10n.navWhitelist,
                    icon: Icons.verified_user_outlined,
                    accent: colors.tertiary,
                  ),
                ),
              ],
            ),
          ),
          AppSectionHeader(l10n.homeQuickActions),
          AppCard(
            variant: AppCardVariant.secondary,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                Expanded(
                  child: _QuickAction(
                    key: const Key('check_caller_tile'),
                    icon: Icons.phone_callback_outlined,
                    label: l10n.homeQuickCheck,
                    semanticLabel: l10n.homeCheckCaller,
                    iconBackground: colors.primaryContainer,
                    iconForeground: colors.onPrimaryContainer,
                    onTap: () => unawaited(
                      showAppBottomSheet<void>(
                        context: context,
                        builder: (_) => const CallerCheckSheet(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _QuickAction(
                    key: const Key('home_add_rule_button'),
                    icon: Icons.add,
                    label: l10n.homeQuickRule,
                    semanticLabel: l10n.addRule,
                    iconBackground: colors.secondaryContainer,
                    iconForeground: colors.onSecondaryContainer,
                    onTap: () => context.push('/rules/new'),
                  ),
                ),
                Expanded(
                  child: _QuickAction(
                    key: const Key('home_history_button'),
                    icon: Icons.history,
                    label: l10n.homeQuickHistory,
                    semanticLabel: l10n.homeHistory,
                    iconBackground: colors.tertiaryContainer,
                    iconForeground: colors.onTertiaryContainer,
                    onTap: () => context.go('/history'),
                  ),
                ),
                Expanded(
                  child: _QuickAction(
                    key: const Key('home_protection_button'),
                    icon: Icons.settings_outlined,
                    label: l10n.homeQuickProtection,
                    semanticLabel: l10n.homeManageProtection,
                    iconBackground: colors.surfaceContainerHigh,
                    iconForeground: colors.onSurfaceVariant,
                    onTap: () => context.go('/settings'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppSectionHeader(
            l10n.homeRecentBlockedTitle,
            trailing: historyItems.isEmpty
                ? null
                : TextButton(
                    onPressed: () => context.go('/history'),
                    child: Text(l10n.homeViewAll),
                  ),
          ),
          AppCard(
            padding: EdgeInsets.zero,
            child: recentCalls.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Row(
                      children: [
                        Icon(
                          Icons.history_toggle_off,
                          size: AppSizes.icon,
                          color: colors.outline,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            l10n.homeNoRecentBlocked,
                            style: context.bodySmallStyle,
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      for (
                        var index = 0;
                        index < recentCalls.length;
                        index++
                      ) ...[
                        if (index > 0) const AppDivider(),
                        _RecentCallRow(call: recentCalls[index]),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.semanticLabel,
    required this.iconBackground,
    required this.iconForeground,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final String semanticLabel;
  final Color iconBackground;
  final Color iconForeground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: Tooltip(
        message: semanticLabel,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.large,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 84),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: AppSpacing.sm,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: iconBackground,
                      borderRadius: AppRadius.medium,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      child: Icon(
                        icon,
                        size: AppSizes.icon,
                        color: iconForeground,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: context.labelMediumStyle.copyWith(
                      color: context.appColors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.value,
    required this.label,
    required this.icon,
    required this.accent,
    super.key,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : AppMotion.fast;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: AppSizes.iconSmall, color: accent),
        const SizedBox(height: AppSpacing.xs),
        AnimatedSwitcher(
          duration: duration,
          switchInCurve: AppMotion.enter,
          switchOutCurve: AppMotion.exit,
          child: Text(
            value,
            key: ValueKey(value),
            style: context.displayStyle.copyWith(color: accent),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: context.captionStyle,
        ),
      ],
    );
  }
}

class _MetricDivider extends StatelessWidget {
  const _MetricDivider({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 56, color: color);
  }
}

class _RecentCallRow extends StatelessWidget {
  const _RecentCallRow({required this.call});

  final BlockedCall call;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final local = call.blockedAt.toLocal();
    final time = MaterialLocalizations.of(context)
        .formatTimeOfDay(TimeOfDay.fromDateTime(local));
    final ruleName = call.ruleName;
    final subtitle = <String>[
      if (call.phoneNumber.isNotEmpty) call.phoneNumber,
      if (ruleName != null) l10n.historyMatchedRule(ruleName),
    ].join(' · ');

    return AppListTile(
      leading: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.errorContainer,
          borderRadius: AppRadius.large,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Icon(
            Icons.block,
            size: AppSizes.icon,
            color: colors.onErrorContainer,
          ),
        ),
      ),
      title: Text(
        call.organizationName ??
            call.ruleName ??
            l10n.historyUnknownOrganization,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: subtitle.isEmpty
          ? null
          : Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: Text(time, style: context.captionStyle),
    );
  }
}
