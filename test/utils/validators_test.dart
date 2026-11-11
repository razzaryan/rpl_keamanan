import 'package:flutter_test/flutter_test.dart';
import 'package:rpl_keamanan/utils/validators.dart';

void main() {
  group('Validators Test - Latihan 5', () {
    test('isValidEmail valid scenarios', () {
      expect(Validators.isValidEmail('user@amikom.ac.id'), isTrue);
      expect(Validators.isValidEmail('test.dev@gmail.com'), isTrue);
      expect(Validators.isValidEmail('invalid-email'), isFalse);
      expect(Validators.isValidEmail('@nodomain.com'), isFalse);
      expect(Validators.isValidEmail('user@.com'), isFalse);
    });

    test('sanitize with dangerous input', () {
      const dangerousInput = '<script>alert("XSS")</script>';
      final sanitized = Validators.sanitize(dangerousInput);
      expect(sanitized.contains('<'), isFalse);
      expect(sanitized.contains('>'), isFalse);
      expect(sanitized.contains('"'), isFalse);
      expect(sanitized, equals('&lt;script&gt;alert(&quot;XSS&quot;)&lt;/script&gt;'));
    });

    test('validateText with various length', () {
      expect(Validators.validateText(null, fieldName: 'Nama'), contains('tidak boleh kosong'));
      expect(Validators.validateText('', fieldName: 'Nama'), contains('tidak boleh kosong'));
      expect(Validators.validateText('abc', minLength: 5, fieldName: 'Kode'), contains('harus antara 5-100'));
      expect(Validators.validateText('Halo Dunia', minLength: 3, maxLength: 20), isNull);
    });

    test('validatePhone validation', () {
      expect(Validators.validatePhone('08123456789'), isNull);
      expect(Validators.validatePhone('0812345'), contains('10-13 digit'));
      expect(Validators.validatePhone('0812345678901234'), contains('10-13 digit'));
      expect(Validators.validatePhone('0812abc3456'), contains('10-13 digit'));
    });

    test('validateUrl validation', () {
      expect(Validators.validateUrl('https://amikom.ac.id'), isNull);
      expect(Validators.validateUrl('http://jsonplaceholder.typicode.com'), isNull);
      expect(Validators.validateUrl('ftp://server.com'), contains('http:// atau https://'));
      expect(Validators.validateUrl('bukan-url'), contains('http:// atau https://'));
    });

    test('validatePassword validation', () {
      expect(Validators.validatePassword('Rahasia123!'), isNull);
      expect(Validators.validatePassword('pendek'), contains('minimal 8 karakter'));
      expect(Validators.validatePassword('semuakecil123!'), contains('huruf kapital'));
      expect(Validators.validatePassword('TANPAANGKA!'), contains('angka'));
      expect(Validators.validatePassword('TanpaSimbol123'), contains('karakter khusus'));
    });
  });
}
