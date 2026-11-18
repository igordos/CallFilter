import 'package:call_filter/core/database/app_database.dart';
import 'package:call_filter/features/call_history/data/drift_call_history_repository.dart';
import 'package:call_filter/features/call_history/domain/blocked_call.dart';
import 'package:call_filter/features/contacts/data/drift_whitelist_repository.dart';
import 'package:call_filter/features/contacts/domain/contact_whitelist_entry.dart';
import 'package:call_filter/features/rules/data/drift_rules_repository.dart';
import 'package:call_filter/features/settings/data/drift_settings_repository.dart';
import 'package:call_filter/features/settings/domain/app_settings.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_app.dart';

void main() {
  late AppDatabase database;
  late DriftRulesRepository rules;
  late DriftWhitelistRepository whitelist;
  late DriftCallHistoryRepository history;
  late DriftSettingsRepository settings;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    rules = DriftRulesRepository(database);
    whitelist = DriftWhitelistRepository(database);
    history = DriftCallHistoryRepository(database);
    settings = DriftSettingsRepository(database);
  });

  tearDown(() => database.close());

  group('DriftRulesRepository', () {
    test('saves, reads, updates and deletes rules', () async {
      await rules.saveRule(buildRule());
      await rules.saveRule(buildRule(id: 'rule-2', name: 'Банк', priority: 10));

      final stored = await rules.getRules();
      expect(stored, hasLength(2));
      expect(stored.first.id, 'rule-2');

      await rules.setRuleEnabled('rule-1', isEnabled: false);
      final updated = await rules.getRuleById('rule-1');
      expect(updated?.isEnabled, isFalse);

      await rules.deleteRule('rule-2');
      expect(await rules.getRules(), hasLength(1));
      expect(await rules.getRuleById('rule-2'), isNull);
    });

    test('watchRules emits updates', () async {
      final emitted = <List<Object>>[];
      final subscription = rules.watchRules().listen(emitted.add);
      addTearDown(subscription.cancel);

      await rules.saveRule(buildRule());
      await Future<void>.delayed(Duration.zero);

      expect(emitted, isNotEmpty);
      expect(emitted.last, hasLength(1));
    });
  });

  group('DriftWhitelistRepository', () {
    test('saves entries and ignores duplicate numbers', () async {
      final first = ContactWhitelistEntry(
        id: 'white-1',
        phoneNumber: '+7 700 111-22-33',
        label: 'Boss',
        createdAt: DateTime(2025),
      );
      final duplicate = ContactWhitelistEntry(
        id: 'white-2',
        phoneNumber: '+7 700 111-22-33',
        label: 'Duplicate',
        createdAt: DateTime(2025),
      );

      await whitelist.addEntry(first);
      await whitelist.addEntry(duplicate);

      final entries = await whitelist.getEntries();
      expect(entries, hasLength(1));
      expect(entries.single.label, 'Boss');

      await whitelist.deleteEntry('white-1');
      expect(await whitelist.getEntries(), isEmpty);
    });
  });

  group('DriftCallHistoryRepository', () {
    test('adds and clears blocked calls', () async {
      await history.addBlockedCall(
        BlockedCall(
          id: 'call-1',
          phoneNumber: '+7 700 000-00-00',
          organizationName: 'ООО Работа',
          ruleId: 'rule-1',
          ruleName: 'Работа',
          blockedAt: DateTime(2025),
        ),
      );

      final calls = await history.getBlockedCalls();
      expect(calls, hasLength(1));
      expect(calls.single.organizationName, 'ООО Работа');

      await history.clear();
      expect(await history.getBlockedCalls(), isEmpty);
    });
  });

  group('DriftSettingsRepository', () {
    test('returns defaults for an empty database', () async {
      final value = await settings.getSettings();
      expect(value.filteringEnabled, isTrue);
      expect(value.logBlockedCalls, isTrue);
      expect(value.themeMode, AppThemeMode.system);
      expect(value.localeCode, isNull);
    });

    test('persists settings', () async {
      await settings.saveSettings(
        const AppSettings(
          filteringEnabled: false,
          logBlockedCalls: false,
          themeMode: AppThemeMode.dark,
          localeCode: 'ru',
        ),
      );

      final value = await settings.getSettings();
      expect(value.filteringEnabled, isFalse);
      expect(value.logBlockedCalls, isFalse);
      expect(value.themeMode, AppThemeMode.dark);
      expect(value.localeCode, 'ru');
    });
  });
}
