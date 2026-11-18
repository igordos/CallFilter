import 'package:call_filter/core/database/app_database.dart';
import 'package:call_filter/features/settings/domain/app_settings.dart';
import 'package:call_filter/features/settings/domain/settings_repository.dart';
import 'package:drift/drift.dart';

class DriftSettingsRepository implements SettingsRepository {
  DriftSettingsRepository(this._database);

  final AppDatabase _database;

  @override
  Stream<AppSettings> watchSettings() {
    return (_database.select(
      _database.appSettingsRows,
    )..where((row) => row.id.equals(0))).watchSingleOrNull().map(
      (row) => row == null ? const AppSettings.defaults() : _toDomain(row),
    );
  }

  @override
  Future<AppSettings> getSettings() async {
    final query = _database.select(_database.appSettingsRows)
      ..where((row) => row.id.equals(0));
    final row = await query.getSingleOrNull();
    return row == null ? const AppSettings.defaults() : _toDomain(row);
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    await _database
        .into(_database.appSettingsRows)
        .insertOnConflictUpdate(
          AppSettingsRowsCompanion(
            id: const Value(0),
            filteringEnabled: Value(settings.filteringEnabled),
            logBlockedCalls: Value(settings.logBlockedCalls),
            themeMode: Value(settings.themeMode.name),
            localeCode: Value(settings.localeCode),
          ),
        );
  }

  AppSettings _toDomain(AppSettingsRecord row) {
    final themeMode = AppThemeMode.values.firstWhere(
      (mode) => mode.name == row.themeMode,
      orElse: () => AppThemeMode.system,
    );
    return AppSettings(
      filteringEnabled: row.filteringEnabled,
      logBlockedCalls: row.logBlockedCalls,
      themeMode: themeMode,
      localeCode: row.localeCode,
    );
  }
}
