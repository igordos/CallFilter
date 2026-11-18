import 'package:call_filter/core/database/app_database.dart';
import 'package:call_filter/features/call_history/data/drift_call_history_repository.dart';
import 'package:call_filter/features/contacts/data/drift_whitelist_repository.dart';
import 'package:call_filter/features/contacts/domain/contact_whitelist_entry.dart';
import 'package:call_filter/features/rules/data/drift_rules_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('evaluates a caller and records a blocked call', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    await DriftRulesRepository(database).saveRule(buildRule());
    final container = testContainer(database: database);
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      container.dispose();
      await database.close();
    });

    await pumpCallFilterApp(tester, container: container);
    await tester.tap(find.byKey(const Key('check_caller_tile')));
    await settle(tester);

    await tester.enterText(
      find.byKey(const Key('caller_phone_field')),
      '+7 700 123-45-67',
    );
    await tester.enterText(
      find.byKey(const Key('caller_name_field')),
      'ООО Работа',
    );
    await tester.tap(find.byKey(const Key('evaluate_caller_button')));
    await settle(tester);

    expect(find.text('Call would be blocked'), findsOneWidget);
    final calls = await DriftCallHistoryRepository(database).getBlockedCalls();
    expect(calls, hasLength(1));
    expect(calls.single.organizationName, 'ООО Работа');
  });

  testWidgets('whitelisted number is allowed in the caller check', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    await DriftRulesRepository(database).saveRule(buildRule());
    await DriftWhitelistRepository(database).addEntry(
      ContactWhitelistEntry(
        id: 'white-1',
        phoneNumber: '+7 (700) 123-45-67',
        label: 'Boss',
        createdAt: DateTime(2025),
      ),
    );
    final container = testContainer(database: database);
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      container.dispose();
      await database.close();
    });

    await pumpCallFilterApp(tester, container: container);
    await tester.tap(find.byKey(const Key('check_caller_tile')));
    await settle(tester);

    await tester.enterText(
      find.byKey(const Key('caller_phone_field')),
      '+7 700 123-45-67',
    );
    await tester.enterText(
      find.byKey(const Key('caller_name_field')),
      'ООО Работа',
    );
    await tester.tap(find.byKey(const Key('evaluate_caller_button')));
    await settle(tester);

    expect(find.text('Call would be allowed'), findsOneWidget);
    expect(find.textContaining('whitelist'), findsOneWidget);
    expect(
      await DriftCallHistoryRepository(database).getBlockedCalls(),
      isEmpty,
    );
  });
}
