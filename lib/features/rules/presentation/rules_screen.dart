import 'dart:async';

import 'package:call_filter/app/theme/app_spacing.dart';
import 'package:call_filter/app/theme/app_theme_context.dart';
import 'package:call_filter/features/rules/domain/filter_rule.dart';
import 'package:call_filter/features/rules/presentation/rules_controller.dart';
import 'package:call_filter/l10n/gen/app_localizations.dart';
import 'package:call_filter/shared/widgets/app_badge.dart';
import 'package:call_filter/shared/widgets/app_button.dart';
import 'package:call_filter/shared/widgets/app_card.dart';
import 'package:call_filter/shared/widgets/app_dialog.dart';
import 'package:call_filter/shared/widgets/app_divider.dart';
import 'package:call_filter/shared/widgets/app_icon_button.dart';
import 'package:call_filter/shared/widgets/app_list_tile.dart';
import 'package:call_filter/shared/widgets/app_scaffold.dart';
import 'package:call_filter/shared/widgets/app_search_field.dart';
import 'package:call_filter/shared/widgets/app_section_header.dart';
import 'package:call_filter/shared/widgets/app_segmented_control.dart';
import 'package:call_filter/shared/widgets/app_snackbars.dart';
import 'package:call_filter/shared/widgets/app_state_views.dart';
import 'package:call_filter/shared/widgets/app_switch.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

enum _RuleAction { edit, delete }

enum _RuleFilter { all, active, disabled }

class RulesScreen extends ConsumerStatefulWidget {
  const RulesScreen({super.key});

  @override
  ConsumerState<RulesScreen> createState() => _RulesScreenState();
}

class _RulesScreenState extends ConsumerState<RulesScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  _RuleFilter _filter = _RuleFilter.all;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final rules = ref.watch(rulesControllerProvider);

    return AppScaffold(
      title: l10n.rulesTitle,
      actions: [
        AppIconButton(
          key: const Key('add_rule_button'),
          icon: Icons.add,
          tooltip: l10n.addRule,
          onPressed: () => context.push('/rules/new'),
        ),
        const SizedBox(width: AppSpacing.xs),
      ],
      body: AppAsyncValueView<List<FilterRule>>(
        value: rules,
        onRetry: () => ref.invalidate(rulesControllerProvider),
        data: (items) => _buildBody(context, items),
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<FilterRule> items) {
    final l10n = AppLocalizations.of(context);
    if (items.isEmpty) {
      return AppEmptyState(
        icon: Icons.filter_alt_off_outlined,
        title: l10n.rulesEmptyTitle,
        body: l10n.rulesEmptyBody,
        action: AppButton(
          key: const Key('empty_add_rule_button'),
          label: l10n.addRule,
          icon: Icons.add,
          onPressed: () => context.push('/rules/new'),
        ),
      );
    }

    final normalizedQuery = _query.trim().toLowerCase();
    final filtered = items
        .where((rule) {
          final matchesQuery =
              normalizedQuery.isEmpty ||
              rule.name.toLowerCase().contains(normalizedQuery) ||
              rule.pattern.toLowerCase().contains(normalizedQuery) ||
              (rule.description ?? '').toLowerCase().contains(normalizedQuery);
          final matchesFilter = switch (_filter) {
            _RuleFilter.all => true,
            _RuleFilter.active => rule.isEnabled,
            _RuleFilter.disabled => !rule.isEnabled,
          };
          return matchesQuery && matchesFilter;
        })
        .toList(growable: false);

    final active = filtered.where((rule) => rule.isEnabled).toList();
    final disabled = filtered.where((rule) => !rule.isEnabled).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.page,
            AppSpacing.md,
            AppSpacing.page,
            AppSpacing.sm,
          ),
          child: AppSearchField(
            fieldKey: const Key('rules_search_field'),
            controller: _searchController,
            hintText: l10n.searchRulesHint,
            clearTooltip: l10n.searchClear,
            onChanged: (value) => setState(() => _query = value),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.page,
            AppSpacing.sm,
            AppSpacing.page,
            AppSpacing.xs,
          ),
          child: AppSegmentedControl<_RuleFilter>(
            options: [
              AppSegmentedOption(
                value: _RuleFilter.all,
                label: l10n.filterAll,
                key: const Key('rules_filter_all'),
              ),
              AppSegmentedOption(
                value: _RuleFilter.active,
                label: l10n.rulesFilterActive,
                key: const Key('rules_filter_active'),
              ),
              AppSegmentedOption(
                value: _RuleFilter.disabled,
                label: l10n.rulesFilterDisabled,
                key: const Key('rules_filter_disabled'),
              ),
            ],
            selected: _filter,
            onSelected: (value) => setState(() => _filter = value),
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? AppEmptyState(
                  icon: Icons.search_off,
                  title: l10n.noSearchResultsTitle,
                  body: l10n.noSearchResultsBody,
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.page,
                    0,
                    AppSpacing.page,
                    AppSpacing.xxxl,
                  ),
                  children: [
                    if (active.isNotEmpty)
                      _RuleGroup(title: l10n.rulesFilterActive, rules: active),
                    if (disabled.isNotEmpty)
                      _RuleGroup(
                        title: l10n.rulesFilterDisabled,
                        rules: disabled,
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _RuleGroup extends StatelessWidget {
  const _RuleGroup({required this.title, required this.rules});

  final String title;
  final List<FilterRule> rules;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSectionHeader(
          title,
          trailing: Text('${rules.length}', style: context.labelMediumStyle),
        ),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var index = 0; index < rules.length; index++) ...[
                if (index > 0) const AppDivider(),
                _RuleTile(rule: rules[index]),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _RuleTile extends ConsumerWidget {
  const _RuleTile({required this.rule});

  final FilterRule rule;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;

    return AppListTile(
      key: ValueKey('rule_tile_${rule.id}'),
      onTap: () => context.push('/rules/${rule.id}/edit'),
      leading: DecoratedBox(
        decoration: BoxDecoration(
          color: rule.isEnabled
              ? colors.primarySurface
              : colors.surfaceSecondary,
          borderRadius: AppRadius.control,
          border: Border.all(
            color: rule.isEnabled
                ? colors.primary.withValues(alpha: 0.18)
                : colors.border,
          ),
        ),
        child: SizedBox.square(
          dimension: AppSizes.listAvatar,
          child: Icon(
            Icons.filter_alt_outlined,
            size: AppSizes.icon,
            color: rule.isEnabled ? colors.primary : colors.foregroundMuted,
          ),
        ),
      ),
      title: Text(rule.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.xs),
          Text(
            rule.pattern,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.bodySmallStyle.copyWith(
              fontFamily: 'monospace',
              color: colors.primary,
            ),
          ),
          if (rule.description case final description?
              when description.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(description, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
          if (rule.priority > 0) ...[
            const SizedBox(height: AppSpacing.sm),
            AppBadge(label: l10n.rulePriority(rule.priority)),
          ],
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppSwitch(
            key: ValueKey('rule_toggle_${rule.id}'),
            value: rule.isEnabled,
            semanticLabel: rule.name,
            onChanged: (enabled) async {
              try {
                await ref
                    .read(rulesControllerProvider.notifier)
                    .toggleRule(rule, isEnabled: enabled);
              } on Object catch (error) {
                if (context.mounted) {
                  showAppError(context, error, l10n.errorGeneric);
                }
              }
            },
          ),
          PopupMenuButton<_RuleAction>(
            key: ValueKey('rule_menu_${rule.id}'),
            tooltip: l10n.moreActions,
            onSelected: (action) async {
              switch (action) {
                case _RuleAction.edit:
                  await context.push('/rules/${rule.id}/edit');
                case _RuleAction.delete:
                  await _confirmDelete(context, ref, l10n);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: _RuleAction.edit, child: Text(l10n.edit)),
              PopupMenuItem(
                value: _RuleAction.delete,
                child: Text(l10n.delete),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showAppConfirmDialog(
      context: context,
      title: l10n.ruleDeleteTitle,
      message: l10n.ruleDeleteBody,
      confirmLabel: l10n.delete,
      cancelLabel: l10n.cancel,
      destructive: true,
    );
    if (!confirmed || !context.mounted) {
      return;
    }
    try {
      await ref.read(rulesControllerProvider.notifier).deleteRule(rule.id);
      if (context.mounted) {
        showAppMessage(context, l10n.ruleDeleted);
      }
    } on Object catch (error) {
      if (context.mounted) {
        showAppError(context, error, l10n.errorGeneric);
      }
    }
  }
}
