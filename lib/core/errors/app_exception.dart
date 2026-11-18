/// Base class for expected application failures.
class AppException implements Exception {
  const AppException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => 'AppException: $message';
}

class PlatformIntegrationException extends AppException {
  const PlatformIntegrationException(super.message, {super.cause});
}

class RuleNotFoundException extends AppException {
  const RuleNotFoundException() : super('Rule not found');
}
