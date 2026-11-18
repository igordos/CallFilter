enum RegexMatchOutcome { matched, notMatched, invalidPattern, timedOut }

/// Executes a RegExp in an implementation that can enforce a time budget.
abstract interface class RegexMatchRunner {
  Future<RegexMatchOutcome> match({
    required String pattern,
    required String input,
  });
}
