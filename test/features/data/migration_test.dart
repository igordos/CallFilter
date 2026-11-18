import 'package:call_filter/core/database/app_database.dart';
import 'package:call_filter/features/settings/data/drift_settings_repository.dart';
import 'package:call_filter/features/settings/domain/app_settings.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('v1 settings migrate to v2 with the system theme default', () async {
    final executor = NativeDatabase.memory(
      setup: (database) {
        database
          ..execute('''
            CREATE TABLE app_settings (
              id INTEGER NOT NULL PRIMARY KEY,
              filtering_enabled INTEGER NOT NULL DEFAULT 1,
              log_blocked_calls INTEGER NOT NULL DEFAULT 1,
              locale_code TEXT
            )
          ''')
          ..execute('''
            INSERT INTO app_settings
              (id, filtering_enabled, log_blocked_calls, locale_code)
            VALUES (0, 1, 0, 'ru')
          ''')
          ..execute('PRAGMA user_version = 1');
      },
    );
    final database = AppDatabase(executor);
    addTearDown(database.close);

    final settings = await DriftSettingsRepository(database).getSettings();

    expect(settings.filteringEnabled, isTrue);
    expect(settings.logBlockedCalls, isFalse);
    expect(settings.localeCode, 'ru');
    expect(settings.themeMode, AppThemeMode.system);
  });
}
