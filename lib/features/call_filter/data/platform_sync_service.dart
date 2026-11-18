import 'package:call_filter/features/call_filter/domain/call_screening_gateway.dart';
import 'package:call_filter/features/call_filter/domain/phone_number_normalizer.dart';
import 'package:call_filter/features/call_filter/domain/platform_filter_snapshot.dart';
import 'package:call_filter/features/call_history/domain/call_history_repository.dart';
import 'package:call_filter/features/contacts/domain/whitelist_repository.dart';
import 'package:call_filter/features/rules/domain/rules_repository.dart';
import 'package:call_filter/features/settings/domain/settings_repository.dart';

/// Builds the native snapshot from local repositories and hands it to a
/// [CallScreeningGateway].
class PlatformSyncService {
  const PlatformSyncService({
    required CallScreeningGateway gateway,
    required RulesRepository rulesRepository,
    required WhitelistRepository whitelistRepository,
    required CallHistoryRepository callHistoryRepository,
    required SettingsRepository settingsRepository,
  }) : _gateway = gateway,
       _rulesRepository = rulesRepository,
       _whitelistRepository = whitelistRepository,
       _callHistoryRepository = callHistoryRepository,
       _settingsRepository = settingsRepository;

  final CallScreeningGateway _gateway;
  final RulesRepository _rulesRepository;
  final WhitelistRepository _whitelistRepository;
  final CallHistoryRepository _callHistoryRepository;
  final SettingsRepository _settingsRepository;

  Future<void> sync() async {
    final settings = await _settingsRepository.getSettings();
    final rules = await _rulesRepository.getRules();
    final whitelist = await _whitelistRepository.getEntries();
    final blockedCalls = await _callHistoryRepository.getBlockedCalls();

    // The whitelist must win in the prepared iOS mappings too. Add those first
    // so a number that also appears in history cannot become a blocking entry.
    final mappings = <String, CallDirectoryMapping>{};
    for (final entry in whitelist) {
      final number = PhoneNumberNormalizer.normalize(entry.phoneNumber);
      if (number.isEmpty) {
        continue;
      }
      mappings[number] = CallDirectoryMapping(
        phoneNumber: number,
        label: entry.label.isEmpty ? 'CallFilter whitelist' : entry.label,
        shouldBlock: false,
      );
    }
    for (final call in blockedCalls) {
      final number = PhoneNumberNormalizer.normalize(call.phoneNumber);
      if (number.isEmpty) {
        continue;
      }
      mappings.putIfAbsent(
        number,
        () => CallDirectoryMapping(
          phoneNumber: number,
          label:
              call.organizationName ??
              call.ruleName ??
              'CallFilter blocked caller',
          shouldBlock: true,
        ),
      );
    }

    await _gateway.syncSnapshot(
      PlatformFilterSnapshot(
        filteringEnabled: settings.filteringEnabled,
        rules: rules
            .where((rule) => rule.isEnabled)
            .map(
              (rule) => PlatformRule(
                id: rule.id,
                name: rule.name,
                pattern: rule.pattern,
                priority: rule.priority,
              ),
            )
            .toList(growable: false),
        whitelistNumbers: whitelist
            .map((entry) => PhoneNumberNormalizer.normalize(entry.phoneNumber))
            .where((number) => number.isNotEmpty)
            .toList(growable: false),
        directoryMappings: mappings.values.toList(growable: false),
        generatedAt: DateTime.now(),
      ),
    );
  }
}
