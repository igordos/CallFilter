import 'package:call_filter/features/call_filter/domain/organization_normalizer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OrganizationNormalizer', () {
    test('trims, lowercases and collapses whitespace', () {
      expect(
        OrganizationNormalizer.normalize('  ООО   РАБОТА \n Москва '),
        'ооо работа москва',
      );
    });

    test('normalizes non-breaking spaces', () {
      final value = 'ООО${String.fromCharCode(0x00A0)}Работа';
      expect(OrganizationNormalizer.normalize(value), 'ооо работа');
    });

    test('removes zero-width characters', () {
      final value = 'ООО${String.fromCharCode(0x200B)} Работа';
      expect(OrganizationNormalizer.normalize(value), 'ооо работа');
    });

    test('keeps punctuation and digits', () {
      expect(
        OrganizationNormalizer.normalize('ООО «Работа-2»'),
        'ооо «работа-2»',
      );
    });
  });
}
