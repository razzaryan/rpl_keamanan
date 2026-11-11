/// Kumpulan fungsi validasi dan sanitasi input.
///
/// Class ini menyediakan method statis untuk memvalidasi input
/// pengguna dan membersihkan karakter berbahaya.
class Validators {
  /// Memvalidasi format email.
  ///
  /// Mengembalikan `true` jika [email] memiliki format yang valid.
  static bool isValidEmail(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email);
  }

  /// Memvalidasi bahwa [value] tidak kosong.
  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  /// Memvalidasi panjang [value] antara [min] dan [max].
  static bool hasValidLength(String value, {int min = 1, int max = 100}) {
    final length = value.trim().length;
    return length >= min && length <= max;
  }

  /// Membersihkan input dari karakter berbahaya.
  ///
  /// Mengganti karakter `<`, `>`, `"`, dan `'` dengan HTML entities
  /// untuk mencegah XSS.
  static String sanitize(String input) {
    return input
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;')
        .trim();
  }

  /// Memvalidasi dan membersihkan input teks.
  ///
  /// Mengembalikan pesan error jika tidak valid, atau `null` jika valid.
  static String? validateText(
    String? value, {
    String fieldName = 'Field',
    int minLength = 1,
    int maxLength = 100,
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    if (!hasValidLength(value, min: minLength, max: maxLength)) {
      return '$fieldName harus antara $minLength-$maxLength karakter';
    }
    return null;
  }

  /// Memvalidasi format email.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong';
    }
    if (!isValidEmail(value.trim())) {
      return 'Format email tidak valid';
    }
    return null;
  }

  /// Validasi nomor telepon (hanya angka, 10-13 digit).
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    final cleaned = value.trim();
    final phoneRegex = RegExp(r'^[0-9]{10,13}$');
    if (!phoneRegex.hasMatch(cleaned)) {
      return 'Nomor telepon harus berupa 10-13 digit angka';
    }
    return null;
  }

  /// Validasi URL (harus dimulai dengan http:// atau https://).
  static String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'URL tidak boleh kosong';
    }
    final cleaned = value.trim();
    final uri = Uri.tryParse(cleaned);
    final isValidScheme = uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
    final hasHost = uri != null && uri.host.isNotEmpty;
    if (!isValidScheme || !hasHost) {
      return 'URL harus dimulai dengan http:// atau https:// dan valid';
    }
    return null;
  }

  /// Validasi password (minimal 8 karakter, mengandung huruf kapital, angka, dan simbol).
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }
    final hasUppercase = RegExp(r'[A-Z]').hasMatch(value);
    final hasDigit = RegExp(r'[0-9]').hasMatch(value);
    final hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>_\-]').hasMatch(value);

    if (!hasUppercase) {
      return 'Password harus mengandung minimal satu huruf kapital';
    }
    if (!hasDigit) {
      return 'Password harus mengandung minimal satu angka';
    }
    if (!hasSpecial) {
      return 'Password harus mengandung minimal satu karakter khusus/simbol';
    }
    return null;
  }
}
