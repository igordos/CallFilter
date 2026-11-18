import 'package:call_filter/features/call_history/domain/blocked_call.dart';

/// Persistence boundary for the local blocked-call log.
abstract interface class CallHistoryRepository {
  Stream<List<BlockedCall>> watchBlockedCalls();

  Future<List<BlockedCall>> getBlockedCalls();

  Future<void> addBlockedCall(BlockedCall call);

  Future<void> clear();
}
