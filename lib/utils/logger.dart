import 'package:flutter/foundation.dart';

/// Level logging untuk aplikasi.
enum LogLevel { debug, info, warning, error }

/// Utility logging terstruktur dan aman.
///
/// Log hanya dicetak pada kDebugMode untuk mencegah informasi
/// debug terekspos pada build production.
class AppLogger {
  /// Log level debug
  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _log(LogLevel.debug, message, error, stackTrace);
  }

  /// Log level info
  static void info(String message) {
    _log(LogLevel.info, message);
  }

  /// Log level warning
  static void warning(String message, [dynamic error]) {
    _log(LogLevel.warning, message, error);
  }

  /// Log level error
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _log(LogLevel.error, message, error, stackTrace);
  }

  static void _log(LogLevel level, String message, [dynamic error, StackTrace? stackTrace]) {
    if (!kDebugMode) return;

    final timestamp = DateTime.now().toIso8601String().substring(11, 19);
    final prefix = switch (level) {
      LogLevel.debug => '🐛 [DEBUG]',
      LogLevel.info => 'ℹ️ [INFO]',
      LogLevel.warning => '⚠️ [WARN]',
      LogLevel.error => '❌ [ERROR]',
    };

    // Sensor potensi token/key bila ada pola rahasia
    final sanitizedMessage = _redactSensitive(message);

    debugPrint('$prefix $timestamp: $sanitizedMessage');
    if (error != null) {
      debugPrint('   Details: $error');
    }
    if (stackTrace != null) {
      debugPrint('   StackTrace: $stackTrace');
    }
  }

  static String _redactSensitive(String text) {
    return text.replaceAllMapped(
      RegExp(r'(API_KEY|token|password|secret|authorization)=([^\s,&]+)', caseSensitive: false),
      (match) => '${match.group(1)}=[REDACTED]',
    );
  }
}
