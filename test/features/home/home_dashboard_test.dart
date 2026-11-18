import 'package:call_filter/core/database/app_database.dart';
import 'package:call_filter/features/call_history/data/drift_call_history_repository.dart';
import 'package:call_filter/features/call_history/domain/blocked_call.dart';
import 'package:call_filter/features/contacts/data/drift_whitelist_repository.dart';
import 'package:call_filter/features/contacts/domain/contact_whitelist_entry.dart';
import 'package:call_filter/features/rules/data/drift_rules_repository.dart';
import 'package:call_filter/features/settings/data/drift_settings_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('dashboard shows real protection data and toggles filtering', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    final rules = DriftRulesRepository(database);
    await rules.saveRule(
      buildRule(id: 'active', name: 'Active rule', pattern: 'active'),
    );
    await rules.saveRule(
      buildRule(
        id: 'disabled',
        name: 'Disabled rule',
        pattern: 'disabled',
        isEnabled: false,
      ),
    );
    await DriftWhitelistRepository(database).addEntry(
      ContactWhitelistEntry(
        id: 'white',
        phoneNumber: '+7 700 000-00-00',
        label: 'Trusted',
        createdAt: DateTime(2025),
      ),
    );
    await DriftCallHistoryRepository(database).addBlockedCall(
      BlockedCall(
        id: 'blocked',
        phoneNumber: '+7 700 111-11-11',
        organizationName: 'ООО Работа',
        ruleId: 'active',
        ruleName: 'Active rule',
        blockedAt: DateTime.now(),
      ),
    );
    final container = testContainer(database: database);
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      container.dispose();
      await database.close();
    });

    await pumpCallFilterApp(tester, container: container);

    expect(find.text('Filtering is on'), findsOneWidget);
    expect(find.byKey(const Key('home_filtering_switch')), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const Key('home_rules_metric')),
        matching: find.text('1'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const Key('home_whitelist_metric')),
        matching: find.text('1'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const Key('home_blocked_metric')),
        matching: find.text('1'),
      ),
      findsOneWidget,
    );
    expect(find.text('ООО Работа'), findsOneWidget);

    await tester.tap(find.byKey(const Key('home_filtering_switch')));
    await settle(tester);

    expect(find.text('Filtering is off'), findsOneWidget);
    final settings = await DriftSettingsRepository(database).getSettings();
    expect(settings.filteringEnabled, isFalse);
  });

  testWidgets('dashboard quick action opens the rule editor', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    final container = testContainer(database: database);
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      container.dispose();
      await database.close();
    });

    await pumpCallFilterApp(tester, container: container);
    await tester.ensureVisible(find.byKey(const Key('home_add_rule_button')));
    await tester.tap(find.byKey(const Key('home_add_rule_button')));
    await settle(tester);

    expect(find.byKey(const Key('rule_name_field')), findsOneWidget);
    expect(find.text('New rule'), findsOneWidget);
  });
}
