import 'package:call_filter/core/database/app_database.dart';
import 'package:call_filter/features/rules/data/drift_rules_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('creates a rule and persists it locally', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    final container = testContainer(database: database);
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      container.dispose();
      await database.close();
    });

    await pumpCallFilterApp(tester, container: container);
    await tester.tap(find.byKey(const ValueKey('nav_rules')));
    await settle(tester);

    expect(find.text('No filter rules yet'), findsOneWidget);

    await tester.tap(find.byKey(const Key('add_rule_button')));
    await settle(tester);

    await tester.enterText(find.byKey(const Key('rule_name_field')), 'Работа');
    await tester.enterText(
      find.byKey(const Key('rule_pattern_field')),
      r'ооо\s+работа',
    );
    await tester.ensureVisible(find.byKey(const Key('save_rule_button')));
    await tester.tap(find.byKey(const Key('save_rule_button')));
    await settle(tester);

    expect(find.text('Работа'), findsOneWidget);
    final stored = await DriftRulesRepository(database).getRules();
    expect(stored, hasLength(1));
    expect(stored.single.pattern, r'ооо\s+работа');
  });

  testWidgets('rejects a nested-quantifier RegExp before saving', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    final container = testContainer(database: database);
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      container.dispose();
      await database.close();
    });

    await pumpCallFilterApp(tester, container: container);
    await tester.tap(find.byKey(const ValueKey('nav_rules')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('add_rule_button')));
    await settle(tester);

    await tester.enterText(find.byKey(const Key('rule_name_field')), 'Unsafe');
    await tester.enterText(
      find.byKey(const Key('rule_pattern_field')),
      r'(a+)+$',
    );
    await tester.ensureVisible(find.byKey(const Key('save_rule_button')));
    await tester.tap(find.byKey(const Key('save_rule_button')));
    await settle(tester);

    expect(find.textContaining('Nested quantifiers'), findsOneWidget);
    expect(await DriftRulesRepository(database).getRules(), isEmpty);
  });

  testWidgets('lists an existing rule and toggles it', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    final repository = DriftRulesRepository(database);
    await repository.saveRule(buildRule());
    final container = testContainer(database: database);
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      container.dispose();
      await database.close();
    });

    await pumpCallFilterApp(tester, container: container);
    await tester.tap(find.byKey(const ValueKey('nav_rules')));
    await settle(tester);

    expect(find.text('Работа'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('rule_toggle_rule-1')));
    await settle(tester);

    final stored = await repository.getRuleById('rule-1');
    expect(stored?.isEnabled, isFalse);
  });
}
