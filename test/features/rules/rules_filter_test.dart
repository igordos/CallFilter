import 'package:call_filter/core/database/app_database.dart';
import 'package:call_filter/features/rules/data/drift_rules_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('filters rules by enabled state', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    final repository = DriftRulesRepository(database);
    await repository.saveRule(
      buildRule(id: 'active', name: 'Active rule', pattern: 'active'),
    );
    await repository.saveRule(
      buildRule(
        id: 'disabled',
        name: 'Disabled rule',
        pattern: 'disabled',
        isEnabled: false,
      ),
    );
    final container = testContainer(database: database);
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      container.dispose();
      await database.close();
    });

    await pumpCallFilterApp(tester, container: container);
    await tester.tap(find.byKey(const ValueKey('nav_rules')));
    await settle(tester);

    expect(find.text('Active rule'), findsOneWidget);
    expect(find.text('Disabled rule'), findsOneWidget);

    await tester.tap(find.byKey(const Key('rules_filter_disabled')));
    await settle(tester);
    expect(find.text('Disabled rule'), findsOneWidget);
    expect(find.text('Active rule'), findsNothing);

    await tester.tap(find.byKey(const Key('rules_filter_active')));
    await settle(tester);
    expect(find.text('Active rule'), findsOneWidget);
    expect(find.text('Disabled rule'), findsNothing);
  });
}
