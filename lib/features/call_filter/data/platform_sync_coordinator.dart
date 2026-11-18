import 'dart:async';

import 'package:call_filter/features/call_filter/data/platform_sync_service.dart';
import 'package:call_filter/features/call_history/domain/call_history_repository.dart';
import 'package:call_filter/features/contacts/domain/whitelist_repository.dart';
import 'package:call_filter/features/rules/domain/rules_repository.dart';
import 'package:call_filter/features/settings/domain/settings_repository.dart';

/// Keeps the native snapshot in step with local repository changes.
///
/// The native CallScreeningService never reads Drift directly. It consumes the
/// last snapshot written through [PlatformSyncService], so every rules,
/// whitelist, settings or history change must trigger a fresh snapshot. Syncs
/// are serialized and debounced; a failed sync never leaves a partial snapshot
/// because the native write is a single atomic preferences commit.
class PlatformSyncCoordinator {
  PlatformSyncCoordinator({
    required PlatformSyncService syncService,
    required RulesRepository rulesRepository,
    required WhitelistRepository whitelistRepository,
    required CallHistoryRepository callHistoryRepository,
    required SettingsRepository settingsRepository,
    this.debounce = const Duration(milliseconds: 250),
  }) : _syncService = syncService,
       _rulesRepository = rulesRepository,
       _whitelistRepository = whitelistRepository,
       _callHistoryRepository = callHistoryRepository,
       _settingsRepository = settingsRepository;

  final PlatformSyncService _syncService;
  final RulesRepository _rulesRepository;
  final WhitelistRepository _whitelistRepository;
  final CallHistoryRepository _callHistoryRepository;
  final SettingsRepository _settingsRepository;
  final Duration debounce;

  final List<StreamSubscription<Object?>> _subscriptions = [];
  Timer? _debounceTimer;
  Future<void> _queue = Future<void>.value();
  bool _started = false;
  bool _disposed = false;

  Object? lastError;

  Future<void> start() async {
    if (_started || _disposed) {
      return;
    }
    _started = true;
    _subscriptions
      ..add(_rulesRepository.watchRules().listen((_) => _schedule()))
      ..add(_whitelistRepository.watchEntries().listen((_) => _schedule()))
      ..add(_settingsRepository.watchSettings().listen((_) => _schedule()))
      ..add(
        _callHistoryRepository.watchBlockedCalls().listen((_) => _schedule()),
      );
    await _syncSilently();
  }

  void _schedule() {
    if (_disposed) {
      return;
    }
    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounce, () {
      unawaited(_syncSilently());
    });
  }

  /// Runs a sync immediately. Calls are serialized so an older repository read
  /// cannot overwrite a newer snapshot.
  Future<void> syncNow() {
    if (_disposed) {
      return Future<void>.value();
    }
    final operation = _queue.then((_) => _syncService.sync());
    _queue = operation.catchError((Object _) {});
    return operation;
  }

  Future<void> _syncSilently() async {
    try {
      await syncNow();
      lastError = null;
    } on Object catch (error) {
      // A failed sync must not crash the UI or create a second data path.
      // The manual Settings action can surface the error to the user.
      lastError = error;
    }
  }

  Future<void> dispose() async {
    _disposed = true;
    _debounceTimer?.cancel();
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    _subscriptions.clear();
    await _queue;
  }
}
