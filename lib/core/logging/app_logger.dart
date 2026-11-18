import 'dart:developer' as developer;

/// Small logging facade so platform/data code does not call `print` directly.
class AppLogger {
  const AppLogger(this.name);

  final String name;

  void info(String message) {
    developer.log(message, name: name, level: 800);
  }

  void warning(String message, {Object? error}) {
    developer.log(message, name: name, level: 900, error: error);
  }

  void error(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: name,
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
