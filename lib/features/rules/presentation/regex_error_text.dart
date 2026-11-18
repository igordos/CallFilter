import 'package:call_filter/features/call_filter/domain/regex_safety_validator.dart';
import 'package:call_filter/features/call_filter/domain/regex_validation.dart';
import 'package:call_filter/l10n/gen/app_localizations.dart';

String regexValidationMessage(
  AppLocalizations l10n,
  RegexValidationResult result,
  RegexSafetyValidator validator,
) {
  return switch (result.error) {
    RegexValidationError.empty => l10n.ruleRegexEmpty,
    RegexValidationError.tooLong => l10n.ruleRegexTooLong(
      validator.maxPatternLength,
    ),
    RegexValidationError.invalidSyntax => l10n.ruleRegexInvalidSyntax,
    RegexValidationError.nestedQuantifier => l10n.ruleRegexNestedQuantifier,
    RegexValidationError.excessiveRepetition =>
      l10n.ruleRegexRepetitionTooLarge(validator.maxRepetitionCount),
    RegexValidationError.controlCharacters => l10n.ruleRegexControlCharacters,
    null => '',
  };
}
