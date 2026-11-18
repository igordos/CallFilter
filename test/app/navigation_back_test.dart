import 'package:call_filter/core/database/app_database.dart';
import 'package:call_filter/features/rules/data/drift_rules_repository.dart';
import 'package:call_filter/features/rules/presentation/rules_screen.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/test_app.dart';

Future<void> _pressSystemBack(WidgetTester tester) async {
  await tester.binding.handlePopRoute();
  await settle(tester);
}

Future<AppDatabase> _pump(
  WidgetTester tester, {
  Size size = const Size(430, 932),
}) async {
  final database = AppDatabase(NativeDatabase.memory());
  final container = testContainer(database: database);
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
    await database.close();
  });
  await pumpCallFilterApp(tester, container: container);
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  await tester.pump();
  await settle(tester);
  return database;
}

void main() {
  testWidgets('Back from Rule Editor returns to Rules', (tester) async {
    await _pump(tester);
    await tester.tap(find.byKey(const ValueKey('nav_rules')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('add_rule_button')));
    await settle(tester);
    expect(find.byKey(const Key('rule_name_field')), findsOneWidget);

    await _pressSystemBack(tester);

    expect(find.byKey(const Key('rule_name_field')), findsNothing);
    expect(find.byKey(const Key('add_rule_button')), findsOneWidget);
  });

  testWidgets('Back at non-home branch roots returns Home', (tester) async {
    await _pump(tester);
    for (final key in const ['nav_rules', 'nav_history', 'nav_settings']) {
      await tester.tap(find.byKey(ValueKey(key)));
      await settle(tester);
      await _pressSystemBack(tester);
      expect(
        find.byKey(const Key('home_filtering_switch')),
        findsOneWidget,
        reason: 'Back from $key should return Home',
      );
    }
  });

  testWidgets('multiple nested transitions pop within the branch', (
    tester,
  ) async {
    await _pump(tester);
    await tester.tap(find.byKey(const ValueKey('nav_rules')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('add_rule_button')));
    await settle(tester);
    await _pressSystemBack(tester);
    expect(find.byType(RulesScreen), findsOneWidget);
    await _pressSystemBack(tester);
    expect(find.byKey(const Key('home_filtering_switch')), findsOneWidget);
  });

  testWidgets('Back at Home is allowed to leave the app', (tester) async {
    await _pump(tester);
    final handled = await tester.binding.handlePopRoute();
    await settle(tester);
    expect(handled, isFalse);
    expect(find.byKey(const Key('home_filtering_switch')), findsOneWidget);
  });

  testWidgets('Back closes a dialog before navigating', (tester) async {
    await _pump(tester);
    await tester.tap(find.byKey(const ValueKey('nav_whitelist')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('add_whitelist_button')));
    await settle(tester);
    expect(find.byKey(const Key('whitelist_phone_field')), findsOneWidget);

    await _pressSystemBack(tester);

    expect(find.byKey(const Key('whitelist_phone_field')), findsNothing);
    expect(find.byKey(const Key('add_whitelist_button')), findsOneWidget);
  });

  testWidgets('Back closes a bottom sheet before navigating', (tester) async {
    await _pump(tester);
    await tester.tap(find.byKey(const Key('check_caller_tile')));
    await settle(tester);
    expect(find.byKey(const Key('caller_phone_field')), findsOneWidget);

    await _pressSystemBack(tester);

    expect(find.byKey(const Key('caller_phone_field')), findsNothing);
    expect(find.byKey(const Key('home_filtering_switch')), findsOneWidget);
  });

  testWidgets('tab switching preserves branch state', (tester) async {
    final database = await _pump(tester);
    await DriftRulesRepository(database).saveRule(buildRule());
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('nav_rules')));
    await settle(tester);
    await tester.enterText(find.byKey(const Key('rules_search_field')), 'Acme');
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('nav_history')));
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('nav_rules')));
    await settle(tester);

    final field = tester.widget<TextField>(
      find.byKey(const Key('rules_search_field')),
    );
    expect(field.controller?.text, 'Acme');
  });

  testWidgets('re-selecting the current tab does not duplicate it', (
    tester,
  ) async {
    await _pump(tester);
    await tester.tap(find.byKey(const ValueKey('nav_rules')));
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('nav_rules')));
    await settle(tester);

    expect(find.byType(RulesScreen), findsOneWidget);
    expect(find.byKey(const Key('add_rule_button')), findsOneWidget);
  });

  testWidgets('rail uses the same branch switching and Back behavior', (
    tester,
  ) async {
    await _pump(tester, size: const Size(900, 1200));
    await tester.tap(find.byKey(const ValueKey('nav_history')));
    await settle(tester);
    expect(find.byType(NavigationRail), findsOneWidget);
    await _pressSystemBack(tester);
    expect(find.byKey(const Key('home_filtering_switch')), findsOneWidget);
  });
}
