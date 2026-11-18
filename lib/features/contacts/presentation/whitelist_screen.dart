import 'dart:async';

import 'package:call_filter/app/theme/app_spacing.dart';
import 'package:call_filter/app/theme/app_theme_context.dart';
import 'package:call_filter/core/di/providers.dart';
import 'package:call_filter/features/call_filter/domain/phone_number_normalizer.dart';
import 'package:call_filter/features/contacts/domain/contact_whitelist_entry.dart';
import 'package:call_filter/features/contacts/presentation/whitelist_controller.dart';
import 'package:call_filter/l10n/gen/app_localizations.dart';
import 'package:call_filter/shared/widgets/app_button.dart';
import 'package:call_filter/shared/widgets/app_dialog.dart';
import 'package:call_filter/shared/widgets/app_divider.dart';
import 'package:call_filter/shared/widgets/app_icon_button.dart';
import 'package:call_filter/shared/widgets/app_list_tile.dart';
import 'package:call_filter/shared/widgets/app_scaffold.dart';
import 'package:call_filter/shared/widgets/app_search_field.dart';
import 'package:call_filter/shared/widgets/app_snackbars.dart';
import 'package:call_filter/shared/widgets/app_state_views.dart';
import 'package:call_filter/shared/widgets/app_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

class WhitelistScreen extends ConsumerStatefulWidget {
  const WhitelistScreen({super.key});

  @override
  ConsumerState<WhitelistScreen> createState() => _WhitelistScreenState();
}

class _WhitelistScreenState extends ConsumerState<WhitelistScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final entries = ref.watch(whitelistControllerProvider);

    return AppScaffold(
      title: l10n.whitelistTitle,
      actions: [
        AppIconButton(
          key: const Key('add_whitelist_button'),
          icon: Icons.person_add_alt_outlined,
          tooltip: l10n.whitelistAdd,
          onPressed: () => unawaited(_addEntry(context)),
        ),
        const SizedBox(width: AppSpacing.xs),
      ],
      body: AppAsyncValueView<List<ContactWhitelistEntry>>(
        value: entries,
        onRetry: () => ref.invalidate(whitelistControllerProvider),
        data: (items) => _buildBody(context, items),
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<ContactWhitelistEntry> items) {
    final l10n = AppLocalizations.of(context);
    if (items.isEmpty) {
      return AppEmptyState(
        icon: Icons.contacts_outlined,
        title: l10n.whitelistEmptyTitle,
        body: l10n.whitelistEmptyBody,
        action: AppButton(
          key: const Key('empty_add_whitelist_button'),
          label: l10n.whitelistAdd,
          icon: Icons.person_add_alt_outlined,
          onPressed: () => unawaited(_addEntry(context)),
        ),
      );
    }

    final normalizedQuery = _query.trim().toLowerCase();
    final filtered = normalizedQuery.isEmpty
        ? items
        : items
              .where((entry) {
                return entry.label.toLowerCase().contains(normalizedQuery) ||
                    entry.phoneNumber.toLowerCase().contains(normalizedQuery);
              })
              .toList(growable: false);

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
            fieldKey: const Key('whitelist_search_field'),
            controller: _searchController,
            hintText: l10n.searchWhitelistHint,
            clearTooltip: l10n.searchClear,
            onChanged: (value) => setState(() => _query = value),
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? AppEmptyState(
                  icon: Icons.search_off,
                  title: l10n.noSearchResultsTitle,
                  body: l10n.noSearchResultsBody,
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xs,
                    0,
                    AppSpacing.xs,
                    AppSpacing.xxxl,
                  ),
                  itemCount: filtered.length,
                  separatorBuilder: (context, index) => const AppDivider(
                    indent: AppSpacing.lg + AppSizes.listAvatar + AppSpacing.md,
                  ),
                  itemBuilder: (context, index) {
                    final entry = filtered[index];
                    return AppListTile(
                      key: ValueKey('whitelist_tile_${entry.id}'),
                      leading: DecoratedBox(
                        decoration: BoxDecoration(
                          color: context.appColors.primaryContainer,
                          borderRadius: AppRadius.large,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          child: Icon(
                            Icons.person_outline,
                            size: AppSizes.icon,
                            color: context.appColors.onPrimaryContainer,
                          ),
                        ),
                      ),
                      title: Text(
                        entry.label.isEmpty ? entry.phoneNumber : entry.label,
                      ),
                      subtitle: entry.label.isEmpty
                          ? null
                          : Text(entry.phoneNumber),
                      trailing: AppIconButton(
                        key: ValueKey('whitelist_delete_${entry.id}'),
                        icon: Icons.delete_outline,
                        tooltip: l10n.delete,
                        variant: AppIconButtonVariant.destructive,
                        onPressed: () =>
                            unawaited(_confirmDelete(context, entry)),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Future<void> _addEntry(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final draft = await showDialog<({String phone, String label})>(
      context: context,
      builder: (_) => const _AddWhitelistDialog(),
    );
    if (draft == null || !context.mounted) {
      return;
    }
    try {
      await ref
          .read(whitelistControllerProvider.notifier)
          .addEntry(
            ContactWhitelistEntry(
              id: ref.read(idGeneratorProvider).newId(),
              phoneNumber: draft.phone.trim(),
              label: draft.label.trim(),
              createdAt: DateTime.now(),
            ),
          );
      if (context.mounted) {
        showAppMessage(context, l10n.whitelistSaved);
      }
    } on Object catch (error) {
      if (context.mounted) {
        showAppError(context, error, l10n.errorGeneric);
      }
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    ContactWhitelistEntry entry,
  ) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showAppConfirmDialog(
      context: context,
      title: l10n.whitelistDeleteTitle,
      message: l10n.whitelistDeleteBody,
      confirmLabel: l10n.delete,
      cancelLabel: l10n.cancel,
      destructive: true,
    );
    if (!confirmed || !context.mounted) {
      return;
    }
    try {
      await ref
          .read(whitelistControllerProvider.notifier)
          .deleteEntry(entry.id);
      if (context.mounted) {
        showAppMessage(context, l10n.whitelistRemoved);
      }
    } on Object catch (error) {
      if (context.mounted) {
        showAppError(context, error, l10n.errorGeneric);
      }
    }
  }
}

class _AddWhitelistDialog extends StatefulWidget {
  const _AddWhitelistDialog();

  @override
  State<_AddWhitelistDialog> createState() => _AddWhitelistDialogState();
}

class _AddWhitelistDialogState extends State<_AddWhitelistDialog> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _labelController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _labelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppDialog(
      title: l10n.whitelistAdd,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              fieldKey: const Key('whitelist_phone_field'),
              controller: _phoneController,
              label: l10n.whitelistPhoneLabel,
              keyboardType: TextInputType.phone,
              autofocus: true,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (!PhoneNumberNormalizer.isValid(value ?? '')) {
                  return l10n.whitelistPhoneInvalid;
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              fieldKey: const Key('whitelist_label_field'),
              controller: _labelController,
              label: l10n.whitelistLabelLabel,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(context),
            ),
          ],
        ),
      ),
      actions: [
        AppButton(
          label: l10n.cancel,
          variant: AppButtonVariant.secondary,
          onPressed: () => Navigator.of(context).pop(),
        ),
        AppButton(
          key: const Key('save_whitelist_button'),
          label: l10n.save,
          onPressed: () => _submit(context),
        ),
      ],
    );
  }

  void _submit(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    Navigator.of(context)
        .pop((phone: _phoneController.text, label: _labelController.text));
  }
}
