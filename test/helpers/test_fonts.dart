import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

/// Loads the platform font files used by the Material test environment.
///
/// Flutter widget tests normally render with the synthetic Ahem font. These
/// fonts are local Flutter SDK artifacts, so golden tests can exercise real
/// glyph widths, Cyrillic text, wrapping and Material icons without adding a
/// package or a font asset to the application.
Future<void> loadGoldenFonts() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final fonts = _materialFontsDirectory();
  final roboto = FontLoader('Roboto')
    ..addFont(_fontData(fonts, 'Roboto-Regular.ttf'))
    ..addFont(_fontData(fonts, 'Roboto-Medium.ttf'))
    ..addFont(_fontData(fonts, 'Roboto-Bold.ttf'))
    ..addFont(_fontData(fonts, 'Roboto-Light.ttf'))
    ..addFont(_fontData(fonts, 'Roboto-Black.ttf'));
  await roboto.load();

  final icons = FontLoader('MaterialIcons')
    ..addFont(_fontData(fonts, 'MaterialIcons-Regular.otf'));
  await icons.load();

  final monospace = File('/System/Library/Fonts/SFNSMono.ttf');
  if (monospace.existsSync()) {
    final loader = FontLoader(
      'monospace',
    )..addFont(Future.value(ByteData.sublistView(monospace.readAsBytesSync())));
    await loader.load();
  }
}

Directory _materialFontsDirectory() {
  var directory = File(Platform.resolvedExecutable).parent;
  while (directory.parent.path != directory.path) {
    final candidate = Directory(
      p.join(directory.path, 'bin', 'cache', 'artifacts', 'material_fonts'),
    );
    if (candidate.existsSync()) {
      return candidate;
    }
    directory = directory.parent;
  }
  throw StateError(
    'Could not locate Flutter material_fonts next to '
    '${Platform.resolvedExecutable}.',
  );
}

Future<ByteData> _fontData(Directory directory, String fileName) async {
  final bytes = await File(p.join(directory.path, fileName)).readAsBytes();
  return ByteData.sublistView(bytes);
}
