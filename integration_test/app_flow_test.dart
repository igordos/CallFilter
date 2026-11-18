import 'package:call_filter/core/database/app_database.dart';
import 'package:call_filter/core/di/providers.dart';
import 'package:call_filter/features/call_filter/domain/call_filter_decision.dart';
import 'package:call_filter/features/call_filter/domain/caller_info.dart';
import 'package:call_filter/features/contacts/data/drift_whitelist_repository.dart';
import 'package:call_filter/features/contacts/domain/contact_whitelist_entry.dart';
import 'package:call_filter/features/rules/data/drift_rules_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';

import '../test/helpers/test_app.dart';

Future<void> dismissKeyboard(WidgetTester tester) async {
  FocusManager.instance.primaryFocus?.unfocus();
  await SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
  await Future<void>.delayed(const Duration(milliseconds: 600));
  await tester.pump();
  await settle(tester);
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('creates a rule through the UI and blocks a matching caller', (
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

    await tester.tap(find.byKey(const ValueKey('nav_rules')));
    await settle(tester);
    await tester.tap(find.byKey(const Key('add_rule_button')));
    await settle(tester);

    await tester.enterText(find.byKey(const Key('rule_name_field')), 'Работа');
    await tester.enterText(
      find.byKey(const Key('rule_pattern_field')),
      r'ооо\s+работа',
    );
    await dismissKeyboard(tester);
    await tester.ensureVisible(find.byKey(const Key('save_rule_button')));
    await tester.tap(find.byKey(const Key('save_rule_button')));
    await settle(tester);

    expect(find.text('Работа'), findsOneWidget);
    final storedRules = await DriftRulesRepository(database).getRules();
    expect(storedRules, hasLength(1));

    final decision = await container
        .read(callFilterEngineProvider)
        .evaluate(
          caller: const CallerInfo(
            phoneNumber: '+7 700 123-45-67',
            displayName: 'ООО Работа',
          ),
          rules: storedRules,
          whitelist: const [],
          filteringEnabled: true,
        );

    expect(decision.isBlocked, isTrue);
    expect(decision.reason, CallFilterReason.matchedRule);
  });

  testWidgets('whitelisted number is allowed after adding it locally', (
    tester,
  ) async {
    final database = AppDatabase(NativeDatabase.memory());
    final container = testContainer(database: database);
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      container.dispose();
      await database.close();
    });

    await DriftRulesRepository(database).saveRule(buildRule());
    await DriftWhitelistRepository(database).addEntry(
      ContactWhitelistEntry(
        id: 'white-1',
        phoneNumber: '+7 (700) 123-45-67',
        label: 'Boss',
        createdAt: DateTime(2025),
      ),
    );

    final rules = await DriftRulesRepository(database).getRules();
    final whitelist = await DriftWhitelistRepository(database).getEntries();
    final decision = await container
        .read(callFilterEngineProvider)
        .evaluate(
          caller: const CallerInfo(
            phoneNumber: '77001234567',
            displayName: 'ООО Работа',
          ),
          rules: rules,
          whitelist: whitelist,
          filteringEnabled: true,
        );

    expect(decision.isBlocked, isFalse);
    expect(decision.reason, CallFilterReason.whitelisted);
  });
}
