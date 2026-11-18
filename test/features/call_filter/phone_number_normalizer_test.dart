import 'package:call_filter/features/call_filter/domain/phone_number_normalizer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PhoneNumberNormalizer', () {
    test('keeps only digits', () {
      expect(
        PhoneNumberNormalizer.normalize('+7 (700) 123-45-67'),
        '77001234567',
      );
    });

    test('requires at least five digits', () {
      expect(PhoneNumberNormalizer.isValid('12-34'), isFalse);
      expect(PhoneNumberNormalizer.isValid('12-345'), isTrue);
    });
  });
}
