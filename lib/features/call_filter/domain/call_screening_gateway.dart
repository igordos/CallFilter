import 'package:call_filter/features/call_filter/domain/platform_capabilities.dart';
import 'package:call_filter/features/call_filter/domain/platform_filter_snapshot.dart';

/// Abstraction over Android's CallScreeningService and iOS Call Directory.
abstract interface class CallScreeningGateway {
  Future<PlatformCapabilities> getCapabilities();

  /// Persists the current local rules for native code.
  ///
  /// This only synchronizes data. It does not prove that a call will be
  /// blocked; the native implementation and device configuration must be
  /// verified separately.
  Future<void> syncSnapshot(PlatformFilterSnapshot snapshot);

  Future<void> openSystemSettings();
}
