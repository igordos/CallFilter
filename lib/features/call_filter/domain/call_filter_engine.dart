import 'package:call_filter/features/call_filter/domain/call_filter_decision.dart';
import 'package:call_filter/features/call_filter/domain/caller_info.dart';
import 'package:call_filter/features/call_filter/domain/organization_match.dart';
import 'package:call_filter/features/call_filter/domain/organization_normalizer.dart';
import 'package:call_filter/features/call_filter/domain/phone_number_normalizer.dart';
import 'package:call_filter/features/call_filter/domain/regex_match_runner.dart';
import 'package:call_filter/features/call_filter/domain/regex_safety_validator.dart';
import 'package:call_filter/features/contacts/domain/contact_whitelist_entry.dart';
import 'package:call_filter/features/rules/domain/filter_rule.dart';

/// Evaluates a caller against the whitelist and active name-based rules.
///
/// Name matching is intentionally separated from native call screening. The
/// platform layer decides when caller metadata is available; this engine only
/// defines deterministic local behavior for a supplied [CallerInfo].
class CallFilterEngine {
  const CallFilterEngine({
    required RegexSafetyValidator safetyValidator,
    required RegexMatchRunner matchRunner,
  }) : _safetyValidator = safetyValidator,
       _matchRunner = matchRunner;

  final RegexSafetyValidator _safetyValidator;
  final RegexMatchRunner _matchRunner;

  Future<CallFilterDecision> evaluate({
    required CallerInfo caller,
    required List<FilterRule> rules,
    required List<ContactWhitelistEntry> whitelist,
    required bool filteringEnabled,
  }) async {
    if (!filteringEnabled) {
      return const CallFilterDecision.allowed(
        CallFilterReason.filteringDisabled,
      );
    }

    final normalizedPhone = PhoneNumberNormalizer.normalize(caller.phoneNumber);
    final isWhitelisted =
        normalizedPhone.isNotEmpty &&
        whitelist.any(
          (entry) =>
              PhoneNumberNormalizer.normalize(entry.phoneNumber) ==
              normalizedPhone,
        );
    if (isWhitelisted) {
      return const CallFilterDecision.allowed(CallFilterReason.whitelisted);
    }

    final displayName = caller.displayName?.trim();
    if (displayName == null || displayName.isEmpty) {
      return const CallFilterDecision.allowed(
        CallFilterReason.callerNameUnavailable,
      );
    }

    final normalizedName = OrganizationNormalizer.normalize(displayName);
    final activeRules = rules.where((rule) => rule.isEnabled).toList()
      ..sort((a, b) {
        final byPriority = b.priority.compareTo(a.priority);
        return byPriority != 0 ? byPriority : a.name.compareTo(b.name);
      });

    var invalidRules = 0;
    var timedOut = false;

    for (final rule in activeRules) {
      if (!_safetyValidator.validate(rule.pattern).isValid) {
        invalidRules++;
        continue;
      }

      final outcome = await _matchRunner.match(
        pattern: rule.pattern,
        input: normalizedName,
      );
      switch (outcome) {
        case RegexMatchOutcome.matched:
          return CallFilterDecision.blocked(
            OrganizationMatch(
              organizationName: displayName,
              normalizedOrganizationName: normalizedName,
              ruleId: rule.id,
              ruleName: rule.name,
            ),
          );
        case RegexMatchOutcome.notMatched:
          continue;
        case RegexMatchOutcome.invalidPattern:
          invalidRules++;
        case RegexMatchOutcome.timedOut:
          timedOut = true;
      }
    }

    if (timedOut) {
      return const CallFilterDecision.allowed(CallFilterReason.regexTimeout);
    }
    if (invalidRules > 0) {
      return const CallFilterDecision.allowed(
        CallFilterReason.invalidRulePatterns,
      );
    }
    return const CallFilterDecision.allowed(CallFilterReason.noMatchingRule);
  }
}
