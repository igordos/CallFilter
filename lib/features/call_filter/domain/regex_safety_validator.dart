import 'package:call_filter/core/regex/regexp_factory.dart';
import 'package:call_filter/features/call_filter/domain/regex_validation.dart';

/// Fast, static checks for patterns that are risky or invalid.
///
/// Dart uses an ECMAScript-style RegExp engine without a matching timeout.
/// This validator is a first line of defense, not a formal ReDoS proof. The
/// runtime match is additionally executed in a killable isolate with a
/// timeout; see `IsolateRegexMatchRunner`.
class RegexSafetyValidator {
  const RegexSafetyValidator({
    this.maxPatternLength = 256,
    this.maxRepetitionCount = 1000,
  });

  final int maxPatternLength;
  final int maxRepetitionCount;

  static final Pattern _controlCharacters = compileInternalRegexp(
    r'[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]',
  );

  /// Detects a quantified group whose body itself contains a quantifier,
  /// for example `(a+)+` or `(foo*){2,}`.
  static final Pattern _nestedQuantifier = compileInternalRegexp(
    r'\((?:[^()\\]|\\.)*[+*](?:[^()\\]|\\.)*\)\s*(?:[+*]|\{\d+(?:,\d*)?\})',
  );

  static final Pattern _numericQuantifier = compileInternalRegexp(
    r'\{(\d+)(?:,(\d*))?\}',
  );

  RegexValidationResult validate(String pattern) {
    if (pattern.trim().isEmpty) {
      return const RegexValidationResult.invalid(RegexValidationError.empty);
    }
    if (pattern.length > maxPatternLength) {
      return const RegexValidationResult.invalid(RegexValidationError.tooLong);
    }
    if (_controlCharacters.allMatches(pattern).isNotEmpty) {
      return const RegexValidationResult.invalid(
        RegexValidationError.controlCharacters,
      );
    }
    if (_exceedsRepetitionLimit(pattern)) {
      return const RegexValidationResult.invalid(
        RegexValidationError.excessiveRepetition,
      );
    }
    if (_nestedQuantifier.allMatches(pattern).isNotEmpty) {
      return const RegexValidationResult.invalid(
        RegexValidationError.nestedQuantifier,
      );
    }

    try {
      compileUserRegexp(pattern);
    } on FormatException {
      return const RegexValidationResult.invalid(
        RegexValidationError.invalidSyntax,
      );
    }
    return const RegexValidationResult.valid();
  }

  bool _exceedsRepetitionLimit(String pattern) {
    for (final match in _numericQuantifier.allMatches(pattern)) {
      final lower = int.tryParse(match.group(1) ?? '');
      final upper = int.tryParse(match.group(2) ?? '');
      if ((lower != null && lower > maxRepetitionCount) ||
          (upper != null && upper > maxRepetitionCount)) {
        return true;
      }
    }
    return false;
  }
}
