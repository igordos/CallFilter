import 'package:call_filter/core/database/app_database.dart';
import 'package:call_filter/core/di/providers.dart';
import 'package:call_filter/features/call_filter/domain/call_screening_gateway.dart';
import 'package:call_filter/features/call_filter/domain/platform_capabilities.dart';
import 'package:call_filter/features/call_filter/domain/platform_filter_snapshot.dart';
import 'package:call_filter/features/contacts/data/drift_whitelist_repository.dart';
import 'package:call_filter/features/contacts/domain/contact_whitelist_entry.dart';
import 'package:call_filter/features/rules/data/drift_rules_repository.dart';
import 'package:call_filter/features/settings/data/drift_settings_repository.dart';
import 'package:call_filter/features/settings/domain/app_settings.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/test_app.dart';

class RecordingGateway extends Mock implements CallScreeningGateway;

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

  test('startup and repository changes sync the native snapshot', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final gateway = RecordingGateway();
    final snapshots = <PlatformFilterSnapshot>[];

    when(() => gateway.isSupported).thenReturn(true);
    when(gateway.getCapabilities).thenAnswer(
      (_) async => const PlatformCapabilities(
        platformName: 'test',
        callScreening: PlatformCapabilityState.available,
        callerDisplayName: PlatformCapabilityState.limited,
        callDirectory: PlatformCapabilityState.unavailable,
        numberBlocking: PlatformCapabilityState.available,
      ),
    );
    when(() => gateway.syncSnapshot(any())).thenAnswer((invocation) async {
      snapshots.add(
        invocation.positionalArguments.first as PlatformFilterSnapshot,
      );
    });
    when(gateway.openSystemSettings).thenAnswer((_) async {});

    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
        callScreeningGatewayProvider.overrideWithValue(gateway),
        regexMatchRunnerProvider.overrideWithValue(
          const InlineRegexMatchRunner(),
        ),
      ],
    );
    addTearDown(() async {
      container.dispose();
      await database.close();
    });

    container.read(platformSyncCoordinatorProvider);
    await Future<void>.delayed(const Duration(milliseconds: 350));
    expect(snapshots, isNotEmpty);
    expect(snapshots.last.schemaVersion, 1);
    expect(snapshots.last.rules, isEmpty);

    await DriftRulesRepository(database).saveRule(buildRule());
    await Future<void>.delayed(const Duration(milliseconds: 450));

    expect(snapshots.last.rules, hasLength(1));
    expect(snapshots.last.rules.single.id, 'rule-1');

    await DriftRulesRepository(database)
        .setRuleEnabled('rule-1', isEnabled: false);
    await Future<void>.delayed(const Duration(milliseconds: 450));
    expect(snapshots.last.rules, isEmpty);

    await DriftRulesRepository(database).deleteRule('rule-1');
    await Future<void>.delayed(const Duration(milliseconds: 450));
    expect(snapshots.last.rules, isEmpty);

    final whitelist = DriftWhitelistRepository(database);
    await whitelist.addEntry(
      ContactWhitelistEntry(
        id: 'white-1',
        phoneNumber: '+7 (700) 123-45-67',
        label: 'Boss',
        createdAt: DateTime(2025),
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 450));
    expect(snapshots.last.whitelistNumbers, ['77001234567']);

    await whitelist.deleteEntry('white-1');
    await Future<void>.delayed(const Duration(milliseconds: 450));
    expect(snapshots.last.whitelistNumbers, isEmpty);

    await DriftSettingsRepository(database).saveSettings(
      const AppSettings(filteringEnabled: false, logBlockedCalls: true),
    );
    await Future<void>.delayed(const Duration(milliseconds: 450));
    expect(snapshots.last.filteringEnabled, isFalse);
  });
}
