import 'package:call_filter/core/database/app_database.dart';
import 'package:call_filter/features/call_history/data/drift_call_history_repository.dart';
import 'package:call_filter/features/call_history/domain/blocked_call.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/test_app.dart';

void main() {
  testWidgets('filters and searches blocked calls', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    final repository = DriftCallHistoryRepository(database);
    final now = DateTime.now();
    await repository.addBlockedCall(
      BlockedCall(
        id: 'today-call',
        phoneNumber: '+7 700 111-11-11',
        organizationName: 'Сегодняшняя организация',
        ruleId: 'today',
        ruleName: 'Today rule',
        blockedAt: now,
      ),
    );
    await repository.addBlockedCall(
      BlockedCall(
        id: 'earlier-call',
        phoneNumber: '+7 700 222-22-22',
        organizationName: 'Старая организация',
        ruleId: 'earlier',
        ruleName: 'Earlier rule',
        blockedAt: now.subtract(const Duration(days: 3)),
      ),
    );
    final container = testContainer(database: database);
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      container.dispose();
      await database.close();
    });

    await pumpCallFilterApp(tester, container: container);
    await tester.tap(find.byKey(const ValueKey('nav_history')));
    await settle(tester);

    expect(find.text('Сегодняшняя организация'), findsOneWidget);
    expect(find.text('Старая организация'), findsOneWidget);

    await tester.tap(find.byKey(const Key('history_filter_today')));
    await settle(tester);
    expect(find.text('Сегодняшняя организация'), findsOneWidget);
    expect(find.text('Старая организация'), findsNothing);

    await tester.tap(find.byKey(const Key('history_filter_all')));
    await settle(tester);
    await tester.enterText(
      find.byKey(const Key('history_search_field')),
      'Старая',
    );
    await settle(tester);
    expect(find.text('Старая организация'), findsOneWidget);
    expect(find.text('Сегодняшняя организация'), findsNothing);
  });
}
