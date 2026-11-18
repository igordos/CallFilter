import 'package:call_filter/core/database/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/test_app.dart';

void main() {
  testWidgets('shell screens tolerate a small phone and large text', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    final container = testContainer(database: database);
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      container.dispose();
      await database.close();
    });
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await pumpCallFilterApp(tester, container: container);
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.35;
    await tester.pump();
    await settle(tester);

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
  });
}
