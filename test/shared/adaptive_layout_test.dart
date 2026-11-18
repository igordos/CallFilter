import 'package:call_filter/core/database/app_database.dart';
import 'package:call_filter/shared/widgets/app_bottom_navigation_bar.dart';
import 'package:call_filter/shared/widgets/app_bottom_sheet.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/test_app.dart';

Future<void> _pumpWithSize(
  WidgetTester tester,
  Size size, {
  required ProviderContainer container,
}) async {
  await pumpCallFilterApp(tester, container: container);
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  await tester.pump();
  await settle(tester);
}

void main() {
  testWidgets('expanded window uses rail and bounded content', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    final container = testContainer(database: database);
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      container.dispose();
      await database.close();
    });

    await _pumpWithSize(tester, const Size(900, 1200), container: container);

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(AppBottomNavigationBar), findsNothing);
    final contentWidth = tester
        .getSize(find.byKey(const Key('app_content_max_width')))
        .width;
    expect(contentWidth, lessThanOrEqualTo(720));
  });

  testWidgets('1200px window keeps rail and bounded content', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    final container = testContainer(database: database);
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      container.dispose();
      await database.close();
    });

    await _pumpWithSize(tester, const Size(1200, 900), container: container);

    expect(find.byType(NavigationRail), findsOneWidget);
    final contentWidth = tester
        .getSize(find.byKey(const Key('app_content_max_width')))
        .width;
    expect(contentWidth, lessThanOrEqualTo(720));
  });

  testWidgets('600px boundary uses the rail', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    final container = testContainer(database: database);
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      container.dispose();
      await database.close();
    });

    await _pumpWithSize(tester, const Size(600, 900), container: container);

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(AppBottomNavigationBar), findsNothing);
  });

  testWidgets('wide shell caps bottom sheets', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    final container = testContainer(database: database);
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      container.dispose();
      await database.close();
    });

    await _pumpWithSize(tester, const Size(900, 1200), container: container);
    await tester.tap(find.byKey(const Key('check_caller_tile')));
    await settle(tester);

    final sheetWidth = tester.getSize(find.byType(AppSheetSurface)).width;
    expect(sheetWidth, lessThanOrEqualTo(640));
  });

  testWidgets('compact window keeps bottom navigation', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    final container = testContainer(database: database);
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      container.dispose();
      await database.close();
    });

    await _pumpWithSize(tester, const Size(599, 900), container: container);

    expect(find.byType(AppBottomNavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
    expect(find.text('Home'), findsNothing);
  });
}
