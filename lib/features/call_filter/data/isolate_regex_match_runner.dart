import 'dart:async';
import 'dart:isolate';

import 'package:call_filter/core/logging/app_logger.dart';
import 'package:call_filter/core/regex/regexp_factory.dart';
import 'package:call_filter/features/call_filter/domain/regex_match_runner.dart';

/// Runs one rule match in a killable isolate.
///
/// Dart's RegExp API has no timeout. Killing the worker is the only reliable
/// way to stop a catastrophic backtracking expression from blocking the UI.
/// The default budget is intentionally short because caller display names are
/// small; a rule that needs longer is suspicious.
class IsolateRegexMatchRunner implements RegexMatchRunner {
  const IsolateRegexMatchRunner({
    this.timeout = const Duration(milliseconds: 250),
    AppLogger logger = const AppLogger('call_filter.regex'),
  }) : _logger = logger;

  final Duration timeout;
  final AppLogger _logger;

  @override
  Future<RegexMatchOutcome> match({
    required String pattern,
    required String input,
  }) async {
    final receivePort = ReceivePort();
    Isolate? isolate;
    try {
      isolate = await Isolate.spawn<List<Object?>>(_matchEntryPoint, <Object?>[
        receivePort.sendPort,
        pattern,
        input,
      ], debugName: 'call-filter-rule');
      final raw = await receivePort.first.timeout(timeout);
      return _parse(raw);
    } on TimeoutException {
      isolate?.kill(priority: Isolate.immediate);
      return RegexMatchOutcome.timedOut;
    } on Object catch (error, stackTrace) {
      isolate?.kill(priority: Isolate.immediate);
      _logger.error(
        'Regex worker failed',
        error: error,
        stackTrace: stackTrace,
      );
      return RegexMatchOutcome.invalidPattern;
    } finally {
      receivePort.close();
    }
  }

  RegexMatchOutcome _parse(Object? raw) {
    return switch (raw) {
      'matched' => RegexMatchOutcome.matched,
      'notMatched' => RegexMatchOutcome.notMatched,
      _ => RegexMatchOutcome.invalidPattern,
    };
  }
}

@pragma('vm:entry-point')
void _matchEntryPoint(List<Object?> message) {
  final sendPort = message[0]! as SendPort;
  final pattern = message[1]! as String;
  final input = message[2]! as String;

  try {
    final regexp = compileUserRegexp(pattern);
    sendPort.send(regexp.allMatches(input).isEmpty ? 'notMatched' : 'matched');
  } on FormatException {
    sendPort.send('invalidPattern');
  }
}
