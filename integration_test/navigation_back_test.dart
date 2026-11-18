import 'package:call_filter/core/database/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';

import '../test/helpers/test_app.dart';

Future<void> _pressSystemBack(WidgetTester tester) async {
  await tester.binding.handlePopRoute();
  await settle(tester);
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('system Back follows the tab hierarchy', (tester) async {
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
    expect(find.byKey(const Key('rule_name_field')), findsOneWidget);

    await _pressSystemBack(tester);
    expect(find.byKey(const Key('rule_name_field')), findsNothing);
    expect(find.byKey(const Key('add_rule_button')), findsOneWidget);

    await _pressSystemBack(tester);
    expect(find.byKey(const Key('home_filtering_switch')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('nav_history')));
    await settle(tester);
    await _pressSystemBack(tester);
    expect(find.byKey(const Key('home_filtering_switch')), findsOneWidget);
  });

  testWidgets('system Back closes modal surfaces before navigating', (
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
    await tester.tap(find.byKey(const ValueKey('nav_whitelist')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('add_whitelist_button')));
    await settle(tester);
    expect(find.byKey(const Key('whitelist_phone_field')), findsOneWidget);

    await _pressSystemBack(tester);
    expect(find.byKey(const Key('whitelist_phone_field')), findsNothing);
    expect(find.byKey(const Key('add_whitelist_button')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('nav_home')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('check_caller_tile')));
    await settle(tester);
    expect(find.byKey(const Key('caller_phone_field')), findsOneWidget);
    await _pressSystemBack(tester);
    expect(find.byKey(const Key('caller_phone_field')), findsNothing);
  });
}
