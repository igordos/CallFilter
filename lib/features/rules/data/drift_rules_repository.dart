import 'package:call_filter/core/database/app_database.dart';
import 'package:call_filter/features/rules/domain/filter_rule.dart';
import 'package:call_filter/features/rules/domain/rules_repository.dart';
import 'package:drift/drift.dart';

class DriftRulesRepository implements RulesRepository {
  DriftRulesRepository(this._database);

  final AppDatabase _database;

  @override
  Stream<List<FilterRule>> watchRules() {
    final query = _database.select(_database.filterRuleRows)
      ..orderBy([
        (row) =>
            OrderingTerm(expression: row.priority, mode: OrderingMode.desc),
        (row) => OrderingTerm(expression: row.name),
      ]);
    return query.watch().map(
      (rows) => rows.map(_toDomain).toList(growable: false),
    );
  }

  @override
  Future<List<FilterRule>> getRules() async {
    final query = _database.select(_database.filterRuleRows)
      ..orderBy([
        (row) =>
            OrderingTerm(expression: row.priority, mode: OrderingMode.desc),
        (row) => OrderingTerm(expression: row.name),
      ]);
    final rows = await query.get();
    return rows.map(_toDomain).toList(growable: false);
  }

  @override
  Future<FilterRule?> getRuleById(String id) async {
    final query = _database.select(_database.filterRuleRows)
      ..where((row) => row.id.equals(id));
    final row = await query.getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  @override
  Future<void> saveRule(FilterRule rule) async {
    await _database
        .into(_database.filterRuleRows)
        .insertOnConflictUpdate(
          FilterRuleRowsCompanion.insert(
            id: rule.id,
            name: rule.name,
            pattern: rule.pattern,
            createdAt: rule.createdAt,
            updatedAt: rule.updatedAt,
            isEnabled: Value(rule.isEnabled),
            priority: Value(rule.priority),
            description: Value(rule.description),
          ),
        );
  }

  @override
  Future<void> setRuleEnabled(String id, {required bool isEnabled}) async {
    await (_database.update(
      _database.filterRuleRows,
    )..where((row) => row.id.equals(id))).write(
      FilterRuleRowsCompanion(
        isEnabled: Value(isEnabled),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> deleteRule(String id) async {
    await (_database.delete(
      _database.filterRuleRows,
    )..where((row) => row.id.equals(id))).go();
  }

  FilterRule _toDomain(FilterRuleRecord row) {
    return FilterRule(
      id: row.id,
      name: row.name,
      pattern: row.pattern,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      isEnabled: row.isEnabled,
      priority: row.priority,
      description: row.description,
    );
  }
}
