import 'dart:async';

import 'package:call_filter/features/call_filter/data/platform_sync_coordinator.dart';
import 'package:call_filter/features/call_filter/data/platform_sync_service.dart';
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

class MockSyncService extends Mock implements PlatformSyncService;

class MockRulesRepository extends Mock implements RulesRepository;

class MockWhitelistRepository extends Mock implements WhitelistRepository;

class MockCallHistoryRepository extends Mock implements CallHistoryRepository;

class MockSettingsRepository extends Mock implements SettingsRepository;

void main() {
  late MockSyncService syncService;
  late MockRulesRepository rulesRepository;
  late MockWhitelistRepository whitelistRepository;
  late MockCallHistoryRepository historyRepository;
  late MockSettingsRepository settingsRepository;
  late StreamController<List<FilterRule>> rulesController;
  late StreamController<List<ContactWhitelistEntry>> whitelistController;
  late StreamController<List<BlockedCall>> historyController;
  late StreamController<AppSettings> settingsController;
  late PlatformSyncCoordinator coordinator;

  setUp(() {
    syncService = MockSyncService();
    rulesRepository = MockRulesRepository();
    whitelistRepository = MockWhitelistRepository();
    historyRepository = MockCallHistoryRepository();
    settingsRepository = MockSettingsRepository();
    rulesController = StreamController.broadcast();
    whitelistController = StreamController.broadcast();
    historyController = StreamController.broadcast();
    settingsController = StreamController.broadcast();

    when(() => rulesRepository.watchRules())
        .thenAnswer((_) => rulesController.stream);
    when(() => whitelistRepository.watchEntries())
        .thenAnswer((_) => whitelistController.stream);
    when(() => historyRepository.watchBlockedCalls())
        .thenAnswer((_) => historyController.stream);
    when(() => settingsRepository.watchSettings())
        .thenAnswer((_) => settingsController.stream);
    when(() => syncService.sync()).thenAnswer((_) async {});

    coordinator = PlatformSyncCoordinator(
      syncService: syncService,
      rulesRepository: rulesRepository,
      whitelistRepository: whitelistRepository,
      callHistoryRepository: historyRepository,
      settingsRepository: settingsRepository,
      debounce: Duration.zero,
    );
  });

  tearDown(() async {
    await coordinator.dispose();
    await rulesController.close();
    await whitelistController.close();
    await historyController.close();
    await settingsController.close();
  });

  test('start syncs immediately', () async {
    await coordinator.start();

    verify(() => syncService.sync()).called(1);
  });

  test('repository changes enqueue a sync', () async {
    await coordinator.start();
    clearInteractions(syncService);

    rulesController.add([buildRule()]);
    await Future<void>.delayed(const Duration(milliseconds: 30));
    verify(() => syncService.sync()).called(1);

    whitelistController.add([
      ContactWhitelistEntry(
        id: 'white-1',
        phoneNumber: '+7 700 123-45-67',
        label: 'Boss',
        createdAt: DateTime(2025),
      ),
    ]);
    await Future<void>.delayed(const Duration(milliseconds: 30));
    verify(() => syncService.sync()).called(1);

    settingsController.add(const AppSettings.defaults());
    await Future<void>.delayed(const Duration(milliseconds: 30));
    verify(() => syncService.sync()).called(1);

    historyController.add([
      BlockedCall(
        id: 'call-1',
        phoneNumber: '77001234567',
        organizationName: 'Acme',
        ruleId: 'rule-1',
        ruleName: 'Acme',
        blockedAt: DateTime(2025),
      ),
    ]);
    await Future<void>.delayed(const Duration(milliseconds: 30));
    verify(() => syncService.sync()).called(1);
  });

  test('failed sync is recorded and does not stop later syncs', () async {
    var calls = 0;
    when(() => syncService.sync()).thenAnswer((_) async {
      calls++;
      if (calls == 1) {
        throw StateError('native unavailable');
      }
    });

    await coordinator.start();
    expect(coordinator.lastError, isA<StateError>());

    rulesController.add([buildRule()]);
    await Future<void>.delayed(const Duration(milliseconds: 30));
    expect(calls, 2);
    expect(coordinator.lastError, isNull);
  });
}
