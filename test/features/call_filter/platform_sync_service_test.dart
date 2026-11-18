import 'package:call_filter/features/call_filter/data/platform_sync_service.dart';
import 'package:call_filter/features/call_filter/domain/call_screening_gateway.dart';
import 'package:call_filter/features/call_filter/domain/platform_filter_snapshot.dart';
import 'package:call_filter/features/call_history/domain/blocked_call.dart';
import 'package:call_filter/features/call_history/domain/call_history_repository.dart';
import 'package:call_filter/features/contacts/domain/contact_whitelist_entry.dart';
import 'package:call_filter/features/contacts/domain/whitelist_repository.dart';
import 'package:call_filter/features/rules/domain/filter_rule.dart';
import 'package:call_filter/features/rules/domain/rules_repository.dart';
import 'package:call_filter/features/settings/domain/app_settings.dart';
import 'package:call_filter/features/settings/domain/settings_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/test_app.dart';

class MockRulesRepository extends Mock implements RulesRepository;

class MockWhitelistRepository extends Mock implements WhitelistRepository;

class MockCallHistoryRepository extends Mock implements CallHistoryRepository;

class MockSettingsRepository extends Mock implements SettingsRepository;

class MockGateway extends Mock implements CallScreeningGateway;

void main() {
  setUpAll(() {
    registerFallbackValue(
      PlatformFilterSnapshot(
        filteringEnabled: true,
        rules: const [],
        whitelistNumbers: const [],
        directoryMappings: const [],
        generatedAt: DateTime(2025),
      ),
    );
  });

  test(
    'whitelist mapping wins over blocked history for the same number',
    () async {
      final rules = MockRulesRepository();
      final whitelist = MockWhitelistRepository();
      final history = MockCallHistoryRepository();
      final settings = MockSettingsRepository();
      final gateway = MockGateway();
      PlatformFilterSnapshot? captured;

      when(settings.getSettings)
          .thenAnswer((_) async => const AppSettings.defaults());
      when(rules.getRules).thenAnswer((_) async => <FilterRule>[buildRule()]);
      when(whitelist.getEntries).thenAnswer(
        (_) async => [
          ContactWhitelistEntry(
            id: 'white-1',
            phoneNumber: '+7 (700) 123-45-67',
            label: 'Boss',
            createdAt: DateTime(2025),
          ),
        ],
      );
      when(history.getBlockedCalls).thenAnswer(
        (_) async => [
          BlockedCall(
            id: 'call-1',
            phoneNumber: '77001234567',
            organizationName: 'ООО Работа',
            ruleId: 'rule-1',
            ruleName: 'Работа',
            blockedAt: DateTime(2025),
          ),
        ],
      );
      when(() => gateway.syncSnapshot(any())).thenAnswer((invocation) async {
        captured =
            invocation.positionalArguments.first as PlatformFilterSnapshot;
      });

      await PlatformSyncService(
        gateway: gateway,
        rulesRepository: rules,
        whitelistRepository: whitelist,
        callHistoryRepository: history,
        settingsRepository: settings,
      ).sync();

      expect(captured, isNotNull);
      expect(captured!.directoryMappings, hasLength(1));
      expect(captured!.directoryMappings.single.phoneNumber, '77001234567');
      expect(captured!.directoryMappings.single.shouldBlock, isFalse);
      expect(captured!.directoryMappings.single.label, 'Boss');
    },
  );

  test(
    'syncs only active rules, normalized whitelist and schema version',
    () async {
      final rules = MockRulesRepository();
      final whitelist = MockWhitelistRepository();
      final history = MockCallHistoryRepository();
      final settings = MockSettingsRepository();
      final gateway = MockGateway();
      PlatformFilterSnapshot? captured;

      when(settings.getSettings).thenAnswer(
        (_) async =>
            const AppSettings(filteringEnabled: false, logBlockedCalls: true),
      );
      when(rules.getRules).thenAnswer(
        (_) async => [buildRule(), buildRule(id: 'disabled', isEnabled: false)],
      );
      when(whitelist.getEntries).thenAnswer(
        (_) async => [
          ContactWhitelistEntry(
            id: 'white-1',
            phoneNumber: '+7 (700) 123-45-67',
            label: 'Boss',
            createdAt: DateTime(2025),
          ),
        ],
      );
      when(history.getBlockedCalls).thenAnswer((_) async => []);
      when(() => gateway.syncSnapshot(any())).thenAnswer((invocation) async {
        captured =
            invocation.positionalArguments.first as PlatformFilterSnapshot;
      });

      await PlatformSyncService(
        gateway: gateway,
        rulesRepository: rules,
        whitelistRepository: whitelist,
        callHistoryRepository: history,
        settingsRepository: settings,
      ).sync();

      expect(captured, isNotNull);
      expect(
        captured!.schemaVersion,
        PlatformFilterSnapshot.currentSchemaVersion,
      );
      expect(captured!.filteringEnabled, isFalse);
      expect(captured!.rules, hasLength(1));
      expect(captured!.rules.single.id, 'rule-1');
      expect(captured!.whitelistNumbers, ['77001234567']);
    },
  );
}
