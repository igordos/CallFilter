import 'package:call_filter/core/database/app_database.dart';
import 'package:call_filter/features/call_history/domain/blocked_call.dart';
import 'package:call_filter/features/call_history/domain/call_history_repository.dart';
import 'package:drift/drift.dart';

class DriftCallHistoryRepository implements CallHistoryRepository {
  DriftCallHistoryRepository(this._database);

  final AppDatabase _database;

  @override
  Stream<List<BlockedCall>> watchBlockedCalls() {
    final query = _database.select(_database.blockedCallRows)
      ..orderBy([
        (row) =>
            OrderingTerm(expression: row.blockedAt, mode: OrderingMode.desc),
      ]);
    return query.watch().map(
      (rows) => rows.map(_toDomain).toList(growable: false),
    );
  }

  @override
  Future<List<BlockedCall>> getBlockedCalls() async {
    final query = _database.select(_database.blockedCallRows)
      ..orderBy([
        (row) =>
            OrderingTerm(expression: row.blockedAt, mode: OrderingMode.desc),
      ]);
    final rows = await query.get();
    return rows.map(_toDomain).toList(growable: false);
  }

  @override
  Future<void> addBlockedCall(BlockedCall call) async {
    await _database
        .into(_database.blockedCallRows)
        .insert(
          BlockedCallRowsCompanion.insert(
            id: call.id,
            phoneNumber: call.phoneNumber,
            blockedAt: call.blockedAt,
            organizationName: Value(call.organizationName),
            ruleId: Value(call.ruleId),
            ruleName: Value(call.ruleName),
          ),
        );
  }

  @override
  Future<void> clear() => _database.delete(_database.blockedCallRows).go();

  BlockedCall _toDomain(BlockedCallRecord row) {
    return BlockedCall(
      id: row.id,
      phoneNumber: row.phoneNumber,
      organizationName: row.organizationName,
      ruleId: row.ruleId,
      ruleName: row.ruleName,
      blockedAt: row.blockedAt,
    );
  }
}
