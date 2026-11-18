import 'dart:async';

import 'package:call_filter/core/database/app_database.dart';
import 'package:call_filter/core/utils/id_generator.dart';
import 'package:call_filter/features/call_filter/data/isolate_regex_match_runner.dart';
import 'package:call_filter/features/call_filter/data/method_channel_call_screening_gateway.dart';
import 'package:call_filter/features/call_filter/data/platform_sync_service.dart';
import 'package:call_filter/features/call_filter/data/unsupported_call_screening_gateway.dart';
import 'package:call_filter/features/call_filter/domain/call_filter_engine.dart';
import 'package:call_filter/features/call_filter/domain/call_screening_gateway.dart';
import 'package:call_filter/features/call_filter/domain/platform_capabilities.dart';
import 'package:call_filter/features/call_filter/domain/regex_match_runner.dart';
import 'package:call_filter/features/call_filter/domain/regex_safety_validator.dart';
import 'package:call_filter/features/call_history/data/drift_call_history_repository.dart';
import 'package:call_filter/features/call_history/domain/call_history_repository.dart';
import 'package:call_filter/features/contacts/data/drift_whitelist_repository.dart';
import 'package:call_filter/features/contacts/domain/whitelist_repository.dart';
import 'package:call_filter/features/rules/data/drift_rules_repository.dart';
import 'package:call_filter/features/rules/domain/rules_repository.dart';
import 'package:call_filter/features/settings/data/drift_settings_repository.dart';
import 'package:call_filter/features/settings/domain/settings_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase.defaults();
  ref.onDispose(() => unawaited(database.close()));
  return database;
});

final rulesRepositoryProvider = Provider<RulesRepository>((ref) {
  return DriftRulesRepository(ref.watch(appDatabaseProvider));
});

final whitelistRepositoryProvider = Provider<WhitelistRepository>((ref) {
  return DriftWhitelistRepository(ref.watch(appDatabaseProvider));
});

final callHistoryRepositoryProvider = Provider<CallHistoryRepository>((ref) {
  return DriftCallHistoryRepository(ref.watch(appDatabaseProvider));
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return DriftSettingsRepository(ref.watch(appDatabaseProvider));
});

final idGeneratorProvider = Provider<IdGenerator>((ref) {
  return const UuidIdGenerator();
});

final regexSafetyValidatorProvider = Provider<RegexSafetyValidator>((ref) {
  return const RegexSafetyValidator();
});

final regexMatchRunnerProvider = Provider<RegexMatchRunner>((ref) {
  return const IsolateRegexMatchRunner();
});

final callFilterEngineProvider = Provider<CallFilterEngine>((ref) {
  return CallFilterEngine(
    safetyValidator: ref.watch(regexSafetyValidatorProvider),
    matchRunner: ref.watch(regexMatchRunnerProvider),
  );
});

final callScreeningGatewayProvider = Provider<CallScreeningGateway>((ref) {
  if (kIsWeb) {
    return const UnsupportedCallScreeningGateway();
  }
  return switch (defaultTargetPlatform) {
    TargetPlatform.android ||
    TargetPlatform.iOS => const MethodChannelCallScreeningGateway(),
    _ => const UnsupportedCallScreeningGateway(),
  };
});

final platformCapabilitiesProvider = FutureProvider<PlatformCapabilities>((
  ref,
) {
  return ref.watch(callScreeningGatewayProvider).getCapabilities();
});

final platformSyncServiceProvider = Provider<PlatformSyncService>((ref) {
  return PlatformSyncService(
    gateway: ref.watch(callScreeningGatewayProvider),
    rulesRepository: ref.watch(rulesRepositoryProvider),
    whitelistRepository: ref.watch(whitelistRepositoryProvider),
    callHistoryRepository: ref.watch(callHistoryRepositoryProvider),
    settingsRepository: ref.watch(settingsRepositoryProvider),
  );
});
