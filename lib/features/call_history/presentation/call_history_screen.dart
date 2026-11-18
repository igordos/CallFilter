import 'dart:async';

import 'package:call_filter/app/theme/app_spacing.dart';
import 'package:call_filter/app/theme/app_theme_context.dart';
import 'package:call_filter/features/call_filter/presentation/caller_check_sheet.dart';
import 'package:call_filter/features/call_history/domain/blocked_call.dart';
import 'package:call_filter/features/call_history/presentation/call_history_controller.dart';
import 'package:call_filter/l10n/gen/app_localizations.dart';
import 'package:call_filter/shared/widgets/app_bottom_sheet.dart';
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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

enum _HistoryFilter { all, today, earlier }

class CallHistoryScreen extends ConsumerStatefulWidget {
  const CallHistoryScreen({super.key});

  @override
  ConsumerState<CallHistoryScreen> createState() => _CallHistoryScreenState();
}

class _CallHistoryScreenState extends ConsumerState<CallHistoryScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  _HistoryFilter _filter = _HistoryFilter.all;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final history = ref.watch(callHistoryControllerProvider);
    final hasItems = history.asData?.value.isNotEmpty ?? false;

    return AppScaffold(
      title: l10n.historyTitle,
      actions: [
        if (hasItems)
          AppIconButton(
            key: const Key('clear_history_button'),
            icon: Icons.delete_sweep_outlined,
            tooltip: l10n.historyClear,
            variant: AppIconButtonVariant.destructive,
            onPressed: () => unawaited(_confirmClear(context, ref)),
          ),
        const SizedBox(width: AppSpacing.xs),
      ],
      body: AppAsyncValueView<List<BlockedCall>>(
        value: history,
        onRetry: () => ref.invalidate(callHistoryControllerProvider),
        data: (items) {
          if (items.isEmpty) {
            return AppEmptyState(
              icon: Icons.history,
              title: l10n.historyEmptyTitle,
              body: l10n.historyEmptyBody,
              action: AppButton(
                label: l10n.homeCheckCaller,
                icon: Icons.phone_callback_outlined,
                onPressed: () => unawaited(
                  showAppBottomSheet<void>(
                    context: context,
                    builder: (_) => const CallerCheckSheet(),
                  ),
                ),
              ),
            );
          }
          return _buildBody(context, items);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<BlockedCall> items) {
    final l10n = AppLocalizations.of(context);
    final normalizedQuery = _query.trim().toLowerCase();
    final today = _today();
    final filtered = items
        .where((call) {
          final matchesQuery =
              normalizedQuery.isEmpty ||
              (call.organizationName ?? '').toLowerCase().contains(
                normalizedQuery,
              ) ||
              call.phoneNumber.toLowerCase().contains(normalizedQuery) ||
              (call.ruleName ?? '').toLowerCase().contains(normalizedQuery);
          final local = call.blockedAt.toLocal();
          final callDay = DateTime(local.year, local.month, local.day);
          final matchesFilter = switch (_filter) {
            _HistoryFilter.all => true,
            _HistoryFilter.today => callDay == today,
            _HistoryFilter.earlier => callDay.isBefore(today),
          };
          return matchesQuery && matchesFilter;
        })
        .toList(growable: false);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.page,
            AppSpacing.md,
            AppSpacing.page,
            AppSpacing.xs,
          ),
          child: AppSearchField(
            fieldKey: const Key('history_search_field'),
            controller: _searchController,
            hintText: l10n.searchHistoryHint,
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
          child: AppSegmentedControl<_HistoryFilter>(
            options: [
              AppSegmentedOption(
                value: _HistoryFilter.all,
                label: l10n.filterAll,
                key: const Key('history_filter_all'),
              ),
              AppSegmentedOption(
                value: _HistoryFilter.today,
                label: l10n.historyToday,
                key: const Key('history_filter_today'),
              ),
              AppSegmentedOption(
                value: _HistoryFilter.earlier,
                label: l10n.historyFilterEarlier,
                key: const Key('history_filter_earlier'),
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
              : _CallHistoryList(items: filtered),
        ),
      ],
    );
  }

  DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showAppConfirmDialog(
      context: context,
      title: l10n.historyClearTitle,
      message: l10n.historyClearBody,
      confirmLabel: l10n.clear,
      cancelLabel: l10n.cancel,
      destructive: true,
    );
    if (!confirmed || !context.mounted) {
      return;
    }
    try {
      await ref.read(callHistoryControllerProvider.notifier).clear();
      if (context.mounted) {
        showAppMessage(context, l10n.historyCleared);
      }
    } on Object catch (error) {
      if (context.mounted) {
        showAppError(context, error, l10n.errorGeneric);
      }
    }
  }
}

class _CallHistoryList extends StatelessWidget {
  const _CallHistoryList({required this.items});

  final List<BlockedCall> items;

  @override
  Widget build(BuildContext context) {
    final groups = _groupByDay(items);
    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxxl),
      children: [
        for (final entry in groups.entries) ...[
          AppSectionHeader(_dayLabel(context, entry.key)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
            child: AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  for (var index = 0; index < entry.value.length; index++) ...[
                    if (index > 0) const AppDivider(),
                    _CallRow(call: entry.value[index]),
                  ],
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Map<DateTime, List<BlockedCall>> _groupByDay(List<BlockedCall> calls) {
    final groups = <DateTime, List<BlockedCall>>{};
    for (final call in calls) {
      final local = call.blockedAt.toLocal();
      final day = DateTime(local.year, local.month, local.day);
      groups.putIfAbsent(day, () => []).add(call);
    }
    return groups;
  }

  String _dayLabel(BuildContext context, DateTime day) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final difference = today.difference(day).inDays;
    if (difference == 0) {
      return l10n.historyToday;
    }
    if (difference == 1) {
      return l10n.historyYesterday;
    }
    return MaterialLocalizations.of(context).formatMediumDate(day);
  }
}

class _CallRow extends StatelessWidget {
  const _CallRow({required this.call});

  final BlockedCall call;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final local = call.blockedAt.toLocal();
    final time = MaterialLocalizations.of(context)
        .formatTimeOfDay(TimeOfDay.fromDateTime(local));
    final ruleName = call.ruleName;

    return AppListTile(
      key: ValueKey('blocked_call_${call.id}'),
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
        call.organizationName ?? ruleName ?? l10n.historyUnknownOrganization,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (call.phoneNumber.isNotEmpty) Text(call.phoneNumber, maxLines: 1),
          if (ruleName != null) ...[
            const SizedBox(height: 2),
            Text(
              l10n.historyMatchedRule(ruleName),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
      trailing: Text(time, style: context.captionStyle),
    );
  }
}
