import 'package:call_filter/features/call_filter/domain/call_filter_decision.dart';
import 'package:call_filter/features/call_filter/domain/call_filter_engine.dart';
import 'package:call_filter/features/call_filter/domain/caller_info.dart';
import 'package:call_filter/features/call_filter/domain/regex_safety_validator.dart';
import 'package:call_filter/features/contacts/domain/contact_whitelist_entry.dart';
import 'package:call_filter/features/rules/domain/filter_rule.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

void main() {
  late CallFilterEngine engine;

  setUp(() {
    engine = const CallFilterEngine(
      safetyValidator: RegexSafetyValidator(),
      matchRunner: InlineRegexMatchRunner(),
    );
  });

  Future<CallFilterDecision> evaluate({
    required List<FilterRule> rules,
    required String? displayName,
    List<ContactWhitelistEntry> whitelist = const [],
    bool filteringEnabled = true,
    String phoneNumber = '+7 700 123-45-67',
  }) {
    return engine.evaluate(
      caller: CallerInfo(phoneNumber: phoneNumber, displayName: displayName),
      rules: rules,
      whitelist: whitelist,
      filteringEnabled: filteringEnabled,
    );
  }

  test('blocks a matching organization name', () async {
    final decision = await evaluate(
      rules: [buildRule()],
      displayName: 'ООО Работа',
    );

    expect(decision.isBlocked, isTrue);
    expect(decision.reason, CallFilterReason.matchedRule);
    expect(decision.match?.ruleId, 'rule-1');
    expect(decision.match?.organizationName, 'ООО Работа');
    expect(decision.match?.normalizedOrganizationName, 'ооо работа');
  });

  test('normalizes case and whitespace before matching', () async {
    final decision = await evaluate(
      rules: [buildRule(pattern: r'^ооо\s+работа$')],
      displayName: '  ООО   РАБОТА  ',
    );

    expect(decision.isBlocked, isTrue);
  });

  test('allows a non-matching organization', () async {
    final decision = await evaluate(
      rules: [buildRule()],
      displayName: 'ООО Ромашка',
    );

    expect(decision.isBlocked, isFalse);
    expect(decision.reason, CallFilterReason.noMatchingRule);
  });

  test('ignores disabled rules', () async {
    final decision = await evaluate(
      rules: [buildRule(isEnabled: false)],
      displayName: 'ООО Работа',
    );

    expect(decision.isBlocked, isFalse);
    expect(decision.reason, CallFilterReason.noMatchingRule);
  });

  test('whitelist wins over a matching rule', () async {
    final decision = await evaluate(
      rules: [buildRule()],
      whitelist: [
        ContactWhitelistEntry(
          id: 'white-1',
          phoneNumber: '+7 (700) 123-45-67',
          label: 'Boss',
          createdAt: DateTime(2025),
        ),
      ],
      displayName: 'ООО Работа',
    );

    expect(decision.isBlocked, isFalse);
    expect(decision.reason, CallFilterReason.whitelisted);
  });

  test('higher priority rule wins when several rules match', () async {
    final decision = await evaluate(
      rules: [
        buildRule(id: 'low', name: 'Low', pattern: 'работа', priority: 1),
        buildRule(id: 'high', name: 'High', priority: 10),
      ],
      displayName: 'ООО Работа',
    );

    expect(decision.isBlocked, isTrue);
    expect(decision.match?.ruleId, 'high');
  });

  test('invalid patterns are skipped safely', () async {
    final decision = await evaluate(
      rules: [buildRule(pattern: '(')],
      displayName: 'ООО Работа',
    );

    expect(decision.isBlocked, isFalse);
    expect(decision.reason, CallFilterReason.invalidRulePatterns);
  });

  test('a valid rule still matches when another rule is invalid', () async {
    final decision = await evaluate(
      rules: [
        buildRule(id: 'invalid', name: 'Invalid', pattern: '('),
        buildRule(id: 'valid', name: 'Valid', pattern: 'работа'),
      ],
      displayName: 'ООО Работа',
    );

    expect(decision.isBlocked, isTrue);
    expect(decision.match?.ruleId, 'valid');
  });

  test('missing caller display name cannot be matched by name rules', () async {
    final decision = await evaluate(rules: [buildRule()], displayName: '   ');

    expect(decision.isBlocked, isFalse);
    expect(decision.reason, CallFilterReason.callerNameUnavailable);
  });

  test('does not evaluate rules when filtering is disabled', () async {
    final decision = await evaluate(
      rules: [buildRule()],
      displayName: 'ООО Работа',
      filteringEnabled: false,
    );

    expect(decision.isBlocked, isFalse);
    expect(decision.reason, CallFilterReason.filteringDisabled);
  });

  test('reports a timeout from the regex runner', () async {
    const timeoutEngine = CallFilterEngine(
      safetyValidator: RegexSafetyValidator(),
      matchRunner: TimedOutRegexMatchRunner(),
    );
    final decision = await timeoutEngine.evaluate(
      caller: const CallerInfo(
        phoneNumber: '+7 700 123-45-67',
        displayName: 'ООО Работа',
      ),
      rules: [buildRule()],
      whitelist: const [],
      filteringEnabled: true,
    );

    expect(decision.isBlocked, isFalse);
    expect(decision.reason, CallFilterReason.regexTimeout);
  });
}
