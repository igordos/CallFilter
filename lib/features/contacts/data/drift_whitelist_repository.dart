import 'package:call_filter/core/database/app_database.dart';
import 'package:call_filter/features/contacts/domain/contact_whitelist_entry.dart';
import 'package:call_filter/features/contacts/domain/whitelist_repository.dart';
import 'package:drift/drift.dart';

class DriftWhitelistRepository implements WhitelistRepository {
  DriftWhitelistRepository(this._database);

  final AppDatabase _database;

  @override
  Stream<List<ContactWhitelistEntry>> watchEntries() {
    final query = _database.select(_database.whitelistRows)
      ..orderBy([
        (row) =>
            OrderingTerm(expression: row.createdAt, mode: OrderingMode.desc),
      ]);
    return query.watch().map(
      (rows) => rows.map(_toDomain).toList(growable: false),
    );
  }

  @override
  Future<List<ContactWhitelistEntry>> getEntries() async {
    final query = _database.select(_database.whitelistRows)
      ..orderBy([
        (row) =>
            OrderingTerm(expression: row.createdAt, mode: OrderingMode.desc),
      ]);
    final rows = await query.get();
    return rows.map(_toDomain).toList(growable: false);
  }

  @override
  Future<void> addEntry(ContactWhitelistEntry entry) async {
    await _database
        .into(_database.whitelistRows)
        .insert(
          WhitelistRowsCompanion.insert(
            id: entry.id,
            phoneNumber: entry.phoneNumber,
            createdAt: entry.createdAt,
            label: Value(entry.label),
          ),
          mode: InsertMode.insertOrIgnore,
        );
  }

  @override
  Future<void> deleteEntry(String id) async {
    await (_database.delete(
      _database.whitelistRows,
    )..where((row) => row.id.equals(id))).go();
  }

  ContactWhitelistEntry _toDomain(WhitelistEntryRecord row) {
    return ContactWhitelistEntry(
      id: row.id,
      phoneNumber: row.phoneNumber,
      label: row.label,
      createdAt: row.createdAt,
    );
  }
}
