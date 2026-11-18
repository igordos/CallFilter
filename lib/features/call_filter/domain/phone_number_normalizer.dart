import 'package:call_filter/core/regex/regexp_factory.dart';

/// Extracts a digits-only key for whitelist comparisons.
///
/// Country-specific canonicalization (for example, mapping a national `8`
/// prefix to `+7`) is intentionally out of scope until the product defines a
/// country. Numbers are compared by their digit sequence only.
abstract final class PhoneNumberNormalizer {
  static final Pattern _nonDigits = compileInternalRegexp(r'\D');

  static String normalize(String value) {
    return value.replaceAll(_nonDigits, '');
  }

  static bool isValid(String value) => normalize(value).length >= 5;
}
