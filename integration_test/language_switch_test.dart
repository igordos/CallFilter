import 'package:call_filter/core/database/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';

import '../test/helpers/test_app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('switching to Russian does not remove Material localizations', (
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
    await tester.tap(find.byKey(const ValueKey('nav_settings')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('language_dropdown')));
    await settle(tester);
    await tester.tap(find.text('Русский').last);
    await settle(tester);

    expect(find.text('Настройки'), findsWidgets);
    // Section header and language tile both show "Язык".
    expect(find.text('Язык'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
