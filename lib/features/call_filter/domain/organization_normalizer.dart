import 'package:call_filter/core/regex/regexp_factory.dart';

/// Normalizes caller display names before rule matching.
///
/// This is deliberately small and deterministic: Unicode NFKC normalization
/// and transliteration are not applied because Dart's core library does not
/// provide them and the extra dependency is not needed for the initial scope.
abstract final class OrganizationNormalizer {
  static final List<String> _invisibleCharacters = [
    String.fromCharCode(0x200B),
    String.fromCharCode(0x200C),
    String.fromCharCode(0x200D),
    String.fromCharCode(0xFEFF),
  ];
  static final Pattern _whitespace = compileInternalRegexp(
    r'\s+',
    unicode: true,
  );
  static final String _nonBreakingSpace = String.fromCharCode(0x00A0);

  /// Trims, removes zero-width characters, collapses whitespace and lowercases.
  static String normalize(String value) {
    var normalized = value;
    for (final character in _invisibleCharacters) {
      normalized = normalized.replaceAll(character, '');
    }
    return normalized
        .replaceAll(_nonBreakingSpace, ' ')
        .replaceAll(_whitespace, ' ')
        .trim()
        .toLowerCase();
  }
}
