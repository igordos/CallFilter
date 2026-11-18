import 'package:call_filter/app/app.dart';
import 'package:call_filter/core/database/app_database.dart';
import 'package:call_filter/core/di/providers.dart';
import 'package:call_filter/core/regex/regexp_factory.dart';
import 'package:call_filter/features/call_filter/data/unsupported_call_screening_gateway.dart';
import 'package:call_filter/features/call_filter/domain/regex_match_runner.dart';
import 'package:call_filter/features/rules/domain/filter_rule.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

class InlineRegexMatchRunner implements RegexMatchRunner {
  const InlineRegexMatchRunner();

  @override
  Future<RegexMatchOutcome> match({
    required String pattern,
    required String input,
  }) async {
    try {
      final regexp = compileUserRegexp(pattern);
      return regexp.allMatches(input).isNotEmpty
          ? RegexMatchOutcome.matched
          : RegexMatchOutcome.notMatched;
    } on FormatException {
      return RegexMatchOutcome.invalidPattern;
    }
  }
}

class TimedOutRegexMatchRunner implements RegexMatchRunner {
  const TimedOutRegexMatchRunner();

  @override
  Future<RegexMatchOutcome> match({
    required String pattern,
    required String input,
  }) async {
    return RegexMatchOutcome.timedOut;
  }
}

void configurePhoneSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(430, 932);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<void> pumpCallFilterApp(
  WidgetTester tester, {
  required ProviderContainer container,
}) async {
  configurePhoneSurface(tester);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const CallFilterApp(),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
  await settle(tester);
}

/// Bounded settle prevents a broken animation from hanging the suite for ten
/// minutes. A timeout surfaces the screen that failed to settle.
Future<void> settle(WidgetTester tester) {
  return tester.pumpAndSettle(
    const Duration(milliseconds: 100),
    EnginePhase.sendSemanticsUpdate,
    const Duration(seconds: 5),
  );
}

ProviderContainer testContainer({AppDatabase? database}) {
  return ProviderContainer(
    overrides: [
      if (database != null) appDatabaseProvider.overrideWithValue(database),
      callScreeningGatewayProvider.overrideWithValue(
        const UnsupportedCallScreeningGateway(),
      ),
      regexMatchRunnerProvider.overrideWithValue(
        const InlineRegexMatchRunner(),
      ),
    ],
  );
}

FilterRule buildRule({
  String id = 'rule-1',
  String name = 'Работа',
  String pattern = r'ооо\s+работа',
  bool isEnabled = true,
  int priority = 0,
  String? description,
}) {
  final createdAt = DateTime(2025);
  return FilterRule(
    id: id,
    name: name,
    pattern: pattern,
    createdAt: createdAt,
    updatedAt: createdAt,
    isEnabled: isEnabled,
    priority: priority,
    description: description,
  );
}
