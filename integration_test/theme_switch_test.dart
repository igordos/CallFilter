import 'dart:io';

import 'package:call_filter/core/database/app_database.dart';
import 'package:call_filter/features/settings/data/drift_settings_repository.dart';
import 'package:call_filter/features/settings/domain/app_settings.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:path/path.dart' as p;

import '../test/helpers/test_app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('theme selection survives an app restart', (tester) async {
    final directory = await Directory.systemTemp.createTemp(
      'call_filter_theme_',
    );
    final file = File(p.join(directory.path, 'call_filter.sqlite'));
    addTearDown(() {
      if (file.existsSync()) {
        file.deleteSync();
      }
      directory.deleteSync(recursive: true);
    });

    final firstDatabase = AppDatabase(NativeDatabase(file));
    final firstContainer = testContainer(database: firstDatabase);
    await pumpCallFilterApp(tester, container: firstContainer);
    await tester.tap(find.byKey(const ValueKey('nav_settings')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('theme_selector')));
    await settle(tester);
    await tester.tap(find.text('Dark').last);
    await settle(tester);

    final firstApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(firstApp.themeMode, ThemeMode.dark);
    final saved = await DriftSettingsRepository(firstDatabase).getSettings();
    expect(saved.themeMode, AppThemeMode.dark);

    await tester.pumpWidget(const SizedBox.shrink());
    firstContainer.dispose();
    await firstDatabase.close();

    final reopenedDatabase = AppDatabase(NativeDatabase(file));
    final reopenedContainer = testContainer(database: reopenedDatabase);
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      reopenedContainer.dispose();
      await reopenedDatabase.close();
    });

    await pumpCallFilterApp(tester, container: reopenedContainer);
    await settle(tester);
    final reopenedApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(reopenedApp.themeMode, ThemeMode.dark);
  });
}
