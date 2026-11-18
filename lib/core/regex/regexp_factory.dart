// All direct `RegExp` usage is confined to this file so that the rest of the
// app consumes [Pattern]. Revisit if a future SDK replaces this constructor.

/// Compiles ECMAScript-style syntax used by user rules.
Pattern compileUserRegexp(String source) {
  return RegExp(source, caseSensitive: false, unicode: true);
}

/// Compiles internal, trusted patterns.
Pattern compileInternalRegexp(
  String source, {
  bool caseSensitive = true,
  bool unicode = false,
}) {
  return RegExp(source, caseSensitive: caseSensitive, unicode: unicode);
}

String escapeRegexp(String source) => RegExp.escape(source);
