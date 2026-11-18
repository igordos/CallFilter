import 'dart:async';

import 'package:call_filter/app/theme/app_spacing.dart';
import 'package:call_filter/app/theme/app_theme_context.dart';
import 'package:call_filter/core/di/providers.dart';
import 'package:call_filter/features/call_filter/domain/call_filter_decision.dart';
import 'package:call_filter/features/call_filter/domain/caller_info.dart';
import 'package:call_filter/features/call_filter/domain/phone_number_normalizer.dart';
import 'package:call_filter/features/call_history/domain/blocked_call.dart';
import 'package:call_filter/features/call_history/presentation/call_history_controller.dart';
import 'package:call_filter/l10n/gen/app_localizations.dart';
import 'package:call_filter/shared/widgets/app_bottom_sheet.dart';
import 'package:call_filter/shared/widgets/app_button.dart';
import 'package:call_filter/shared/widgets/app_snackbars.dart';
import 'package:call_filter/shared/widgets/app_status_indicator.dart';
import 'package:call_filter/shared/widgets/app_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

class CallerCheckSheet extends ConsumerStatefulWidget {
  const CallerCheckSheet({super.key});

  @override
  ConsumerState<CallerCheckSheet> createState() => _CallerCheckSheetState();
}

class _CallerCheckSheetState extends ConsumerState<CallerCheckSheet> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();

  CallFilterDecision? _decision;
  bool _isEvaluating = false;
  bool _wasLogged = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        0,
        AppSpacing.page,
        AppSpacing.page,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSheetHeader(
            title: l10n.callerCheckTitle,
            subtitle: l10n.homeCheckCallerSubtitle,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextField(
                  fieldKey: const Key('caller_phone_field'),
                  controller: _phoneController,
                  label: l10n.callerPhoneLabel,
                  hintText: l10n.callerPhoneHint,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (!PhoneNumberNormalizer.isValid(value ?? '')) {
                      return l10n.callerPhoneInvalid;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  fieldKey: const Key('caller_name_field'),
                  controller: _nameController,
                  label: l10n.callerNameLabel,
                  hintText: l10n.callerNameHint,
                  textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.words,
                  onFieldSubmitted: (_) => unawaited(_evaluate()),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            key: const Key('evaluate_caller_button'),
            label: l10n.callerCheckAction,
            icon: Icons.play_arrow,
            isLoading: _isEvaluating,
            expand: true,
            onPressed: _isEvaluating ? null : () => unawaited(_evaluate()),
          ),
          if (_decision case final decision?) ...[
            const SizedBox(height: AppSpacing.lg),
            _DecisionCard(decision: decision, wasLogged: _wasLogged),
          ],
        ],
      ),
    );
  }

  Future<void> _evaluate() async {
    final l10n = AppLocalizations.of(context);
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isEvaluating = true;
      _decision = null;
      _wasLogged = false;
    });

    final caller = CallerInfo(
      phoneNumber: _phoneController.text,
      displayName: _nameController.text.trim().isEmpty
          ? null
          : _nameController.text,
    );

    try {
      final settings = await ref.read(settingsRepositoryProvider).getSettings();
      final rules = await ref.read(rulesRepositoryProvider).getRules();
      final whitelist = await ref
          .read(whitelistRepositoryProvider)
          .getEntries();

      final decision = await ref
          .read(callFilterEngineProvider)
          .evaluate(
            caller: caller,
            rules: rules,
            whitelist: whitelist,
            filteringEnabled: settings.filteringEnabled,
          );

      var wasLogged = false;
      if (decision.isBlocked && settings.logBlockedCalls) {
        final match = decision.match!;
        await ref
            .read(callHistoryControllerProvider.notifier)
            .addBlockedCall(
              BlockedCall(
                id: ref.read(idGeneratorProvider).newId(),
                phoneNumber: caller.phoneNumber,
                organizationName: match.organizationName,
                ruleId: match.ruleId,
                ruleName: match.ruleName,
                blockedAt: DateTime.now(),
              ),
            );
        wasLogged = true;
      }

      if (!mounted) {
        return;
      }
      setState(() {
        _decision = decision;
        _wasLogged = wasLogged;
      });
    } on Object catch (error) {
      if (mounted) {
        showAppError(context, error, l10n.errorGeneric);
      }
    } finally {
      if (mounted) {
        setState(() => _isEvaluating = false);
      }
    }
  }
}

class _DecisionCard extends StatelessWidget {
  const _DecisionCard({required this.decision, required this.wasLogged});

  final CallFilterDecision decision;
  final bool wasLogged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final blocked = decision.isBlocked;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppStatusIndicator(
          title: blocked ? l10n.callerBlockedTitle : l10n.callerAllowedTitle,
          description: blocked
              ? l10n.callerBlockedBody(
                  decision.match!.ruleName,
                  decision.match!.organizationName,
                )
              : l10n.callerAllowedBody(_reasonText(l10n, decision.reason)),
          icon: blocked ? Icons.block : Icons.check_circle_outline,
          tone: blocked ? AppStatusTone.error : AppStatusTone.success,
        ),
        if (wasLogged) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(l10n.callerLogged, style: context.captionStyle),
        ],
      ],
    );
  }

  String _reasonText(AppLocalizations l10n, CallFilterReason reason) {
    return switch (reason) {
      CallFilterReason.filteringDisabled => l10n.callerFilteringDisabled,
      CallFilterReason.whitelisted => l10n.callerWhitelisted,
      CallFilterReason.callerNameUnavailable => l10n.callerNoName,
      CallFilterReason.matchedRule => l10n.callerBlockedTitle,
      CallFilterReason.noMatchingRule => l10n.callerNoRule,
      CallFilterReason.invalidRulePatterns => l10n.callerInvalidRules,
      CallFilterReason.regexTimeout => l10n.callerTimeout,
    };
  }
}
