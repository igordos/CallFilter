import 'package:call_filter/features/call_filter/domain/regex_safety_validator.dart';
import 'package:call_filter/features/call_filter/domain/regex_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const validator = RegexSafetyValidator();

  group('RegexSafetyValidator', () {
    test('accepts a normal organization pattern', () {
      expect(validator.validate(r'ооо\s+работа').isValid, isTrue);
    });

    test('rejects an empty pattern', () {
      expect(validator.validate('   ').error, RegexValidationError.empty);
    });

    test('rejects invalid syntax', () {
      expect(validator.validate('(').error, RegexValidationError.invalidSyntax);
    });

    test('rejects a pattern that is too long', () {
      final pattern = 'a' * (validator.maxPatternLength + 1);
      expect(validator.validate(pattern).error, RegexValidationError.tooLong);
    });

    test('rejects nested quantifiers', () {
      expect(
        validator.validate(r'(a+)+$').error,
        RegexValidationError.nestedQuantifier,
      );
      expect(
        validator.validate('(foo*){2,}').error,
        RegexValidationError.nestedQuantifier,
      );
    });

    test('rejects excessively large counted repetition', () {
      expect(
        validator.validate('a{2000}').error,
        RegexValidationError.excessiveRepetition,
      );
    });

    test('rejects control characters', () {
      final pattern = 'a${String.fromCharCode(0)}b';
      expect(
        validator.validate(pattern).error,
        RegexValidationError.controlCharacters,
      );
    });

    test('allows escaped parentheses', () {
      expect(validator.validate(r'\(ООО\)').isValid, isTrue);
    });
  });
}
