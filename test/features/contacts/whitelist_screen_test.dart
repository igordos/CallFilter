import 'package:call_filter/core/database/app_database.dart';
import 'package:call_filter/features/contacts/data/drift_whitelist_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('adds a whitelist entry through the dialog', (tester) async {
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

    expect(find.text('Whitelist is empty'), findsOneWidget);

    await tester.tap(find.byKey(const Key('add_whitelist_button')));
    await settle(tester);
    await tester.enterText(
      find.byKey(const Key('whitelist_phone_field')),
      '+7 700 123-45-67',
    );
    await tester.enterText(
      find.byKey(const Key('whitelist_label_field')),
      'Boss',
    );
    await tester.tap(find.byKey(const Key('save_whitelist_button')));
    await settle(tester);

    expect(find.text('Boss'), findsOneWidget);
    final stored = await DriftWhitelistRepository(database).getEntries();
    expect(stored, hasLength(1));
    expect(stored.single.phoneNumber, '+7 700 123-45-67');
  });

  testWidgets('shows a validation error for a short number', (tester) async {
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
    await tester.enterText(
      find.byKey(const Key('whitelist_phone_field')),
      '123',
    );
    await tester.tap(find.byKey(const Key('save_whitelist_button')));
    await settle(tester);

    expect(find.textContaining('at least 5 digits'), findsOneWidget);
    expect(await DriftWhitelistRepository(database).getEntries(), isEmpty);
  });
}
