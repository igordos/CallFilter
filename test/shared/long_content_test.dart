import 'package:call_filter/core/database/app_database.dart';
import 'package:call_filter/features/call_history/data/drift_call_history_repository.dart';
import 'package:call_filter/features/call_history/domain/blocked_call.dart';
import 'package:call_filter/features/contacts/data/drift_whitelist_repository.dart';
import 'package:call_filter/features/contacts/domain/contact_whitelist_entry.dart';
import 'package:call_filter/features/rules/data/drift_rules_repository.dart';
import 'package:call_filter/features/settings/data/drift_settings_repository.dart';
import 'package:call_filter/features/settings/domain/app_settings.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/test_app.dart';

const _compact = Size(360, 740);
const _longName =
    'Очень длинное название организации для проверки переноса и обрезания';
const _longLabel =
    'Очень длинное имя контакта для проверки белого списка и переноса строк';

Future<void> _pumpCompact(
  WidgetTester tester,
  AppDatabase database, {
  required double textScale,
}) async {
  final container = testContainer(database: database);
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
    await database.close();
  });
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  await pumpCallFilterApp(tester, container: container);
  tester.view.physicalSize = _compact;
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  await tester.pump();
  await settle(tester);
}

Future<void> _visitAllTabs(WidgetTester tester) async {
  for (final key in const [
    'nav_rules',
    'nav_whitelist',
    'nav_history',
    'nav_settings',
    'nav_home',
  ]) {
    await tester.tap(find.byKey(ValueKey(key)));
    await settle(tester);
    expect(tester.takeException(), isNull, reason: 'Overflow on $key');
  }
}

void main() {
  testWidgets('empty screens tolerate 2.0 text on a compact phone', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    await _pumpCompact(tester, database, textScale: 2);
    await _visitAllTabs(tester);
  });

  testWidgets('editor and caller sheet tolerate 2.0 text', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    await DriftRulesRepository(database).saveRule(
      buildRule(
        id: 'long-rule',
        name: _longName,
        pattern: r'очень\s+длинный\s+паттерн',
        description: _longName,
      ),
    );
    await _pumpCompact(tester, database, textScale: 2);

    await tester.tap(find.byKey(const ValueKey('nav_rules')));
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('rule_tile_long-rule')));
    await settle(tester);
    expect(tester.takeException(), isNull, reason: 'Overflow in rule editor');
    await tester.pageBack();
    await settle(tester);

    await tester.tap(find.byKey(const ValueKey('nav_home')));
    await settle(tester);
    await tester.scrollUntilVisible(
      find.byKey(const Key('check_caller_tile')),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(const Key('check_caller_tile')));
    await settle(tester);
    expect(tester.takeException(), isNull, reason: 'Overflow in caller sheet');
  });

  testWidgets('long Russian content tolerates 2.0 text on a compact phone', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    await DriftRulesRepository(database).saveRule(
      buildRule(
        id: 'long-rule',
        name: _longName,
        pattern: r'очень\s+длинный\s+паттерн',
        description: _longName,
      ),
    );
    await DriftWhitelistRepository(database).addEntry(
      ContactWhitelistEntry(
        id: 'long-white',
        phoneNumber: '+7 700 123-45-67',
        label: _longLabel,
        createdAt: DateTime(2026),
      ),
    );
    await DriftCallHistoryRepository(database).addBlockedCall(
      BlockedCall(
        id: 'long-call',
        phoneNumber: '+7 700 111-11-11',
        organizationName: _longName,
        ruleId: 'long-rule',
        ruleName: _longName,
        blockedAt: DateTime(2026, 1, 15, 10, 30),
      ),
    );
    await DriftSettingsRepository(database).saveSettings(
      const AppSettings(
        filteringEnabled: true,
        logBlockedCalls: true,
        themeMode: AppThemeMode.light,
        localeCode: 'ru',
      ),
    );

    await _pumpCompact(tester, database, textScale: 2);
    await _visitAllTabs(tester);
  });
}
