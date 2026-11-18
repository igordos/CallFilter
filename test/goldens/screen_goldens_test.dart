import 'dart:io';

import 'package:call_filter/app/app.dart';
import 'package:call_filter/core/database/app_database.dart';
import 'package:call_filter/features/call_history/data/drift_call_history_repository.dart';
import 'package:call_filter/features/call_history/domain/blocked_call.dart';
import 'package:call_filter/features/contacts/data/drift_whitelist_repository.dart';
import 'package:call_filter/features/contacts/domain/contact_whitelist_entry.dart';
import 'package:call_filter/features/rules/data/drift_rules_repository.dart';
import 'package:call_filter/features/settings/data/drift_settings_repository.dart';
import 'package:call_filter/features/settings/domain/app_settings.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/test_app.dart';
import '../helpers/test_fonts.dart';

const _phone = Size(430, 932);
final GlobalKey _goldenKey = GlobalKey();

Future<({ProviderContainer container, AppDatabase database})> _seed({
  required bool dark,
  String locale = 'en',
}) async {
  final database = AppDatabase(NativeDatabase.memory());
  final rules = DriftRulesRepository(database);
  await rules.saveRule(
    buildRule(
      id: 'rule-work',
      name: 'Acme Support',
      pattern: r'acme\s+support',
      priority: 10,
      description: 'Block Acme Support callers',
    ),
  );
  await rules.saveRule(
    buildRule(
      id: 'rule-delivery',
      name: 'Fast Delivery',
      pattern: r'fast\s+delivery',
      isEnabled: false,
      description: 'Disabled example',
    ),
  );
  await DriftWhitelistRepository(database).addEntry(
    ContactWhitelistEntry(
      id: 'white-family',
      phoneNumber: '+7 700 123-45-67',
      label: 'Family',
      createdAt: DateTime(2026),
    ),
  );
  await DriftCallHistoryRepository(database).addBlockedCall(
    BlockedCall(
      id: 'call-work',
      phoneNumber: '+7 700 111-11-11',
      organizationName: 'Acme Support',
      ruleId: 'rule-work',
      ruleName: 'Acme Support',
      blockedAt: DateTime(2026, 1, 15, 10, 30),
    ),
  );
  await DriftCallHistoryRepository(database).addBlockedCall(
    BlockedCall(
      id: 'call-delivery',
      phoneNumber: '+7 700 222-22-22',
      organizationName: 'Fast Delivery',
      ruleId: 'rule-delivery',
      ruleName: 'Fast Delivery',
      blockedAt: DateTime(2026, 1, 14, 18, 5),
    ),
  );
  await DriftSettingsRepository(database).saveSettings(
    AppSettings(
      filteringEnabled: true,
      logBlockedCalls: true,
      themeMode: dark ? AppThemeMode.dark : AppThemeMode.light,
      localeCode: locale,
    ),
  );
  return (container: testContainer(database: database), database: database);
}

Future<void> _pumpScreen(
  WidgetTester tester,
  ProviderContainer container,
) async {
  tester.view.physicalSize = _phone;
  tester.view.devicePixelRatio = 1;
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: RepaintBoundary(
        key: _goldenKey,
        child: const CallFilterApp(fontFamily: 'Roboto'),
      ),
    ),
  );
  await tester.pump();
  await settle(tester);
}

Future<void> _capture(String name) {
  return expectLater(find.byKey(_goldenKey), matchesGoldenFile(name));
}

Future<void> _captureScreens(
  WidgetTester tester,
  ProviderContainer container,
  String suffix,
) async {
  await _pumpScreen(tester, container);
  await _capture('screen_home_$suffix.png');

  await tester.tap(find.byKey(const ValueKey('nav_rules')));
  await settle(tester);
  await _capture('screen_rules_$suffix.png');

  await tester.tap(find.text('Acme Support'));
  await settle(tester);
  await _capture('screen_rule_editor_$suffix.png');
  await tester.pageBack();
  await settle(tester);

  await tester.tap(find.byKey(const ValueKey('nav_whitelist')));
  await settle(tester);
  await _capture('screen_whitelist_$suffix.png');

  await tester.tap(find.byKey(const ValueKey('nav_history')));
  await settle(tester);
  await _capture('screen_history_$suffix.png');

  await tester.tap(find.byKey(const ValueKey('nav_settings')));
  await settle(tester);
  await _capture('screen_settings_$suffix.png');

  await tester.tap(find.byKey(const ValueKey('nav_home')));
  await settle(tester);
  await tester.tap(find.byKey(const Key('check_caller_tile')));
  await settle(tester);
  await _capture('screen_caller_check_$suffix.png');
}

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('screen goldens light', (tester) async {
    final seeded = await _seed(dark: false);
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      seeded.container.dispose();
      await seeded.database.close();
    });

    await _captureScreens(tester, seeded.container, 'light');
  }, skip: !Platform.isMacOS);

  testWidgets('screen empty states light', (tester) async {
    final database = AppDatabase(NativeDatabase.memory());
    final container = testContainer(database: database);
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      container.dispose();
      await database.close();
    });

    await _pumpScreen(tester, container);
    await tester.tap(find.byKey(const ValueKey('nav_rules')));
    await settle(tester);
    await _capture('screen_rules_empty_light.png');

    await tester.tap(find.byKey(const ValueKey('nav_history')));
    await settle(tester);
    await _capture('screen_history_empty_light.png');
  }, skip: !Platform.isMacOS);

  testWidgets('screen goldens dark', (tester) async {
    final seeded = await _seed(dark: true);
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      seeded.container.dispose();
      await seeded.database.close();
    });

    await _captureScreens(tester, seeded.container, 'dark');
  }, skip: !Platform.isMacOS);

  testWidgets('screen home compact layout', (tester) async {
    final seeded = await _seed(dark: false);
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      seeded.container.dispose();
      await seeded.database.close();
    });

    await _pumpScreen(tester, seeded.container);
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    await tester.pump();
    await settle(tester);
    await _capture('screen_home_compact_light.png');
  }, skip: !Platform.isMacOS);

  testWidgets('screen home compact Russian layout', (tester) async {
    final seeded = await _seed(dark: false, locale: 'ru');
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      seeded.container.dispose();
      await seeded.database.close();
    });

    await _pumpScreen(tester, seeded.container);
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    await tester.pump();
    await settle(tester);
    await _capture('screen_home_compact_ru.png');
  }, skip: !Platform.isMacOS);

  testWidgets('screen home wide layout', (tester) async {
    final seeded = await _seed(dark: false);
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      seeded.container.dispose();
      await seeded.database.close();
    });

    tester.view.physicalSize = const Size(900, 1200);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: seeded.container,
        child: RepaintBoundary(
          key: _goldenKey,
          child: const CallFilterApp(fontFamily: 'Roboto'),
        ),
      ),
    );
    await tester.pump();
    await settle(tester);
    await _capture('screen_home_wide_light.png');
  }, skip: !Platform.isMacOS);
}
