import 'package:call_filter/core/di/providers.dart';
import 'package:call_filter/features/call_history/domain/blocked_call.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CallHistoryController extends StreamNotifier<List<BlockedCall>> {
  @override
  Stream<List<BlockedCall>> build() {
    return ref.watch(callHistoryRepositoryProvider).watchBlockedCalls();
  }

  Future<void> addBlockedCall(BlockedCall call) {
    return ref.read(callHistoryRepositoryProvider).addBlockedCall(call);
  }

  Future<void> clear() {
    return ref.read(callHistoryRepositoryProvider).clear();
  }
}

final callHistoryControllerProvider =
    StreamNotifierProvider<CallHistoryController, List<BlockedCall>>(
      CallHistoryController.new,
    );
