enum RegexValidationError {
  empty,
  tooLong,
  invalidSyntax,
  nestedQuantifier,
  excessiveRepetition,
  controlCharacters,
}

class RegexValidationResult {
  const RegexValidationResult.valid() : error = null;

  const RegexValidationResult.invalid(this.error);

  final RegexValidationError? error;

  bool get isValid => error == null;
}
