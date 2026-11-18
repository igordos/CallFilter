import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

@DataClassName('FilterRuleRecord')
class FilterRuleRows extends Table {
  @override
  String get tableName => 'filter_rules';

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get pattern => text()();
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();
  IntColumn get priority => integer().withDefault(const Constant(0))();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('WhitelistEntryRecord')
class WhitelistRows extends Table {
  @override
  String get tableName => 'whitelist_entries';

  TextColumn get id => text()();
  TextColumn get phoneNumber => text()();
  TextColumn get label => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {phoneNumber},
  ];
}

@DataClassName('BlockedCallRecord')
class BlockedCallRows extends Table {
  @override
  String get tableName => 'blocked_calls';

  TextColumn get id => text()();
  TextColumn get phoneNumber => text()();
  TextColumn get organizationName => text().nullable()();
  TextColumn get ruleId => text().nullable()();
  TextColumn get ruleName => text().nullable()();
  DateTimeColumn get blockedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('AppSettingsRecord')
class AppSettingsRows extends Table {
  @override
  String get tableName => 'app_settings';

  IntColumn get id => integer().withDefault(const Constant(0))();
  BoolColumn get filteringEnabled =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get logBlockedCalls =>
      boolean().withDefault(const Constant(true))();
  TextColumn get themeMode => text().withDefault(const Constant('system'))();
  TextColumn get localeCode => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: [FilterRuleRows, WhitelistRows, BlockedCallRows, AppSettingsRows],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  AppDatabase.defaults() : super(driftDatabase(name: 'call_filter'));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          await m.addColumn(appSettingsRows, appSettingsRows.themeMode);
        }
      },
    );
  }
}
