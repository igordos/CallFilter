import 'package:call_filter/features/call_filter/domain/organization_match.dart';

/// Why a call was allowed or blocked.
enum CallFilterReason {
  filteringDisabled,
  whitelisted,
  callerNameUnavailable,
  matchedRule,
  noMatchingRule,
  invalidRulePatterns,
  regexTimeout,
}

/// Result of evaluating a caller against local rules and the whitelist.
class CallFilterDecision {
  const CallFilterDecision._({required this.reason, this.match});

  const CallFilterDecision.blocked(OrganizationMatch match)
    : this._(reason: CallFilterReason.matchedRule, match: match);

  const CallFilterDecision.allowed(CallFilterReason reason)
    : this._(reason: reason);

  final CallFilterReason reason;
  final OrganizationMatch? match;

  bool get isBlocked => reason == CallFilterReason.matchedRule;
}
