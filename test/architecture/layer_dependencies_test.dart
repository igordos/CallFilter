import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

/// Guards the feature-first dependency direction without requiring a paid
/// architecture-analysis tool. These are import checks, not a substitute for a
/// full dependency graph; they catch accidental Flutter/UI imports in domain
/// code and direct database access from presentation code.
void main() {
  test('domain does not depend on Flutter, data or presentation', () {
    final violations = <String>[];
    for (final file in _dartFiles('lib')) {
      if (!p.split(file.path).contains('domain')) {
        continue;
      }
      for (final uri in _imports(file)) {
        if (uri.startsWith('package:flutter/') ||
            uri.startsWith('package:material_ui/') ||
            uri == 'dart:ui' ||
            uri.contains('/data/') ||
            uri.contains('/presentation/')) {
          violations.add('${file.path}: forbidden domain import "$uri"');
        }
      }
    }
    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('presentation does not import Drift or concrete data layer', () {
    final violations = <String>[];
    for (final file in _dartFiles('lib')) {
      if (!p.split(file.path).contains('presentation')) {
        continue;
      }
      for (final uri in _imports(file)) {
        if (uri.startsWith('package:drift/') ||
            uri.contains('/data/') ||
            uri.endsWith('core/database/app_database.dart')) {
          violations.add('${file.path}: forbidden presentation import "$uri"');
        }
      }
    }
    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('core files outside di do not depend on feature implementations', () {
    final violations = <String>[];
    for (final file in _dartFiles('lib/core')) {
      if (p.split(file.path).contains('di')) {
        continue;
      }
      for (final uri in _imports(file)) {
        if (uri.contains('package:call_filter/features/')) {
          violations.add('${file.path}: forbidden core import "$uri"');
        }
      }
    }
    expect(violations, isEmpty, reason: violations.join('\n'));
  });
}

Iterable<File> _dartFiles(String root) {
  return Directory(root)
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'));
}

Iterable<String> _imports(File file) {
  return file
      .readAsLinesSync()
      .where((line) => line.startsWith('import '))
      .map(_extractUri)
      .whereType<String>();
}

String? _extractUri(String line) {
  final singleQuote = line.indexOf("'");
  final doubleQuote = line.indexOf('"');
  final start = switch ((singleQuote, doubleQuote)) {
    (-1, -1) => -1,
    (-1, _) => doubleQuote,
    (_, -1) => singleQuote,
    _ => singleQuote < doubleQuote ? singleQuote : doubleQuote,
  };
  if (start < 0) {
    return null;
  }
  final quote = line[start];
  final end = line.indexOf(quote, start + 1);
  return end < 0 ? null : line.substring(start + 1, end);
}
