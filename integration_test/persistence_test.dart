import 'dart:io';

import 'package:call_filter/core/database/app_database.dart';
import 'package:call_filter/features/rules/data/drift_rules_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path/path.dart' as p;

import '../test/helpers/test_app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('rules survive restart and appear in the UI', (tester) async {
    final directory = await Directory.systemTemp.createTemp(
      'call_filter_integration_',
    );
    final file = File(p.join(directory.path, 'call_filter.sqlite'));

    addTearDown(() {
      if (file.existsSync()) {
        file.deleteSync();
      }
      directory.deleteSync(recursive: true);
    });

    final firstDatabase = AppDatabase(NativeDatabase(file));
    await DriftRulesRepository(firstDatabase)
        .saveRule(buildRule(name: 'Persisted rule'));
    await firstDatabase.close();

    final reopenedDatabase = AppDatabase(NativeDatabase(file));
    final container = testContainer(database: reopenedDatabase);
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      container.dispose();
      await reopenedDatabase.close();
    });

    await pumpCallFilterApp(tester, container: container);
    await tester.tap(find.byKey(const ValueKey('nav_rules')));
    await settle(tester);

    expect(find.text('Persisted rule'), findsOneWidget);
    expect(
      await DriftRulesRepository(reopenedDatabase).getRules(),
      hasLength(1),
    );
  });
}
