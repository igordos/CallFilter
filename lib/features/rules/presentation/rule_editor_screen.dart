import 'dart:async';

import 'package:call_filter/app/theme/app_spacing.dart';
import 'package:call_filter/app/theme/app_theme_context.dart';
import 'package:call_filter/core/di/providers.dart';
import 'package:call_filter/features/rules/domain/filter_rule.dart';
import 'package:call_filter/features/rules/presentation/regex_error_text.dart';
import 'package:call_filter/features/rules/presentation/rules_controller.dart';
import 'package:call_filter/l10n/gen/app_localizations.dart';
import 'package:call_filter/shared/widgets/app_button.dart';
import 'package:call_filter/shared/widgets/app_card.dart';
import 'package:call_filter/shared/widgets/app_dialog.dart';
import 'package:call_filter/shared/widgets/app_divider.dart';
import 'package:call_filter/shared/widgets/app_icon_button.dart';
import 'package:call_filter/shared/widgets/app_list_tile.dart';
import 'package:call_filter/shared/widgets/app_scaffold.dart';
import 'package:call_filter/shared/widgets/app_section_header.dart';
import 'package:call_filter/shared/widgets/app_snackbars.dart';
import 'package:call_filter/shared/widgets/app_state_views.dart';
import 'package:call_filter/shared/widgets/app_switch.dart';
import 'package:call_filter/shared/widgets/app_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

class RuleEditorScreen extends ConsumerStatefulWidget {
  const RuleEditorScreen({this.ruleId, super.key});

  final String? ruleId;

  @override
  ConsumerState<RuleEditorScreen> createState() => _RuleEditorScreenState();
}

class _RuleEditorScreenState extends ConsumerState<RuleEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _patternController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priorityController = TextEditingController(text: '0');

  FilterRule? _existingRule;
  bool _isLoading = false;
  bool _isSaving = false;
  bool _isNotFound = false;
  bool _isEnabled = true;
  bool _allowPop = false;
  Object? _loadError;

  String _initialName = '';
  String _initialPattern = '';
  String _initialDescription = '';
  String _initialPriority = '0';
  bool _initialEnabled = true;

  bool get _isEditing => widget.ruleId != null;

  bool get _isDirty =>
      _nameController.text != _initialName ||
      _patternController.text != _initialPattern ||
      _descriptionController.text != _initialDescription ||
      _priorityController.text != _initialPriority ||
      _isEnabled != _initialEnabled;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _isLoading = true;
      unawaited(_loadRule());
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _patternController.dispose();
    _descriptionController.dispose();
    _priorityController.dispose();
    super.dispose();
  }

  Future<void> _loadRule() async {
    try {
      final rule = await ref
          .read(rulesRepositoryProvider)
          .getRuleById(widget.ruleId!);
      if (!mounted) {
        return;
      }
      if (rule == null) {
        setState(() {
          _isLoading = false;
          _isNotFound = true;
        });
        return;
      }
      _existingRule = rule;
      _nameController.text = rule.name;
      _patternController.text = rule.pattern;
      _descriptionController.text = rule.description ?? '';
      _priorityController.text = rule.priority.toString();
      _initialName = rule.name;
      _initialPattern = rule.pattern;
      _initialDescription = rule.description ?? '';
      _initialPriority = rule.priority.toString();
      _initialEnabled = rule.isEnabled;
      setState(() {
        _isLoading = false;
        _isEnabled = rule.isEnabled;
      });
    } on Object catch (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _loadError = error;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PopScope(
      canPop: !_isDirty || _allowPop,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          unawaited(_handleBack(context));
        }
      },
      child: AppScaffold(
        title: _isEditing ? l10n.ruleEditTitle : l10n.ruleAddTitle,
        leading: AppIconButton(
          icon: Icons.arrow_back,
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () => unawaited(_handleBack(context)),
        ),
        body: _buildBody(context, l10n),
        bottomNavigationBar: _buildActions(context, l10n),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n) {
    if (_isLoading) {
      return const AppLoadingState();
    }
    if (_isNotFound) {
      return AppEmptyState(
        icon: Icons.search_off,
        title: l10n.errorRuleNotFound,
        body: l10n.errorGeneric,
        action: AppButton(
          label: l10n.close,
          variant: AppButtonVariant.secondary,
          onPressed: () => context.pop(),
        ),
      );
    }
    if (_loadError != null) {
      return AppErrorState(onRetry: _retryLoad);
    }

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          AppSpacing.lg,
          AppSpacing.page,
          AppSpacing.xxxl,
        ),
        children: [
          AppSectionHeader(l10n.ruleSectionIdentity),
          AppCard(
            variant: AppCardVariant.secondary,
            child: Column(
              children: [
                AppTextField(
                  fieldKey: const Key('rule_name_field'),
                  controller: _nameController,
                  label: l10n.ruleNameLabel,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (_) => setState(() {}),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.ruleNameRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  fieldKey: const Key('rule_pattern_field'),
                  controller: _patternController,
                  label: l10n.rulePatternLabel,
                  helperText: l10n.rulePatternHelp,
                  textInputAction: TextInputAction.next,
                  autocorrect: false,
                  enableSuggestions: false,
                  onChanged: (_) => setState(() {}),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.rulePatternRequired;
                    }
                    final validator = ref.read(regexSafetyValidatorProvider);
                    final result = validator.validate(value.trim());
                    if (!result.isValid) {
                      return regexValidationMessage(l10n, result, validator);
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  fieldKey: const Key('rule_description_field'),
                  controller: _descriptionController,
                  label: l10n.ruleDescriptionLabel,
                  maxLines: 3,
                  minLines: 2,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (_) => setState(() {}),
                ),
              ],
            ),
          ),
          AppSectionHeader(l10n.ruleSectionBehavior),
          AppCard(
            variant: AppCardVariant.secondary,
            child: Column(
              children: [
                AppTextField(
                  fieldKey: const Key('rule_priority_field'),
                  controller: _priorityController,
                  label: l10n.rulePriorityLabel,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onChanged: (_) => setState(() {}),
                  validator: (value) {
                    final parsed = int.tryParse(value?.trim() ?? '');
                    if (parsed == null || parsed < 0 || parsed > 100) {
                      return l10n.rulePriorityInvalid;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                const AppDivider(),
                AppListTile(
                  title: Text(l10n.ruleEnabledLabel),
                  trailing: AppSwitch(
                    key: const Key('rule_enabled_switch'),
                    value: _isEnabled,
                    semanticLabel: l10n.ruleEnabledLabel,
                    onChanged: (value) {
                      setState(() {
                        _isEnabled = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            variant: AppCardVariant.elevated,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: AppSizes.iconLarge,
                  color: context.appColors.primary,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.ruleExampleTitle,
                        style: context.labelStyle.copyWith(
                          color: context.appColors.primary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(l10n.ruleExampleBody, style: context.bodySmallStyle),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, AppLocalizations l10n) {
    final colors = context.appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        border: Border(top: BorderSide(color: colors.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: Center(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppSizes.pageMaxWidth),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.page,
                AppSpacing.md,
                AppSpacing.page,
                AppSpacing.md,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: AppButton(
                      key: const Key('save_rule_button'),
                      label: l10n.ruleSave,
                      icon: Icons.check,
                      isLoading: _isSaving,
                      expand: true,
                      onPressed: _isSaving ? null : () => unawaited(_save()),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppButton(
                      label: l10n.cancel,
                      variant: AppButtonVariant.secondary,
                      expand: true,
                      onPressed: _isSaving
                          ? null
                          : () => unawaited(_handleBack(context)),
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

  void _retryLoad() {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });
    unawaited(_loadRule());
  }

  Future<void> _handleBack(BuildContext context) async {
    if (_isSaving) {
      return;
    }
    final l10n = AppLocalizations.of(context);
    if (!_isDirty) {
      setState(() => _allowPop = true);
      context.pop();
      return;
    }
    final discard = await showAppConfirmDialog(
      context: context,
      title: l10n.editorDiscardTitle,
      message: l10n.editorDiscardBody,
      confirmLabel: l10n.editorDiscardConfirm,
      cancelLabel: l10n.editorKeepEditing,
      destructive: true,
    );
    if (discard && context.mounted) {
      setState(() => _allowPop = true);
      context.pop();
    }
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isSaving = true);
    final now = DateTime.now();
    final description = _descriptionController.text.trim();
    final rule = FilterRule(
      id: _existingRule?.id ?? ref.read(idGeneratorProvider).newId(),
      name: _nameController.text.trim(),
      pattern: _patternController.text.trim(),
      createdAt: _existingRule?.createdAt ?? now,
      updatedAt: now,
      isEnabled: _isEnabled,
      priority: int.parse(_priorityController.text.trim()),
      description: description.isEmpty ? null : description,
    );

    try {
      await ref.read(rulesControllerProvider.notifier).saveRule(rule);
      if (!mounted) {
        return;
      }
      showAppMessage(context, l10n.ruleSaved);
      setState(() => _allowPop = true);
      context.pop();
    } on Object catch (error) {
      if (mounted) {
        showAppError(context, error, l10n.errorGeneric);
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
