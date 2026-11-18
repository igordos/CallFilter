import 'package:call_filter/core/errors/app_exception.dart';
import 'package:call_filter/features/call_filter/domain/call_screening_gateway.dart';
import 'package:call_filter/features/call_filter/domain/platform_capabilities.dart';
import 'package:call_filter/features/call_filter/domain/platform_filter_snapshot.dart';

class UnsupportedCallScreeningGateway implements CallScreeningGateway {
  const UnsupportedCallScreeningGateway();

  @override
  bool get isSupported => false;

  @override
  Future<PlatformCapabilities> getCapabilities() async {
    return const PlatformCapabilities.unsupported();
  }

  @override
  Future<void> syncSnapshot(PlatformFilterSnapshot snapshot) {
    throw const PlatformIntegrationException(
      'Native call screening is unavailable on this platform.',
    );
  }

  @override
  Future<void> openSystemSettings() {
    throw const PlatformIntegrationException(
      'Native call screening is unavailable on this platform.',
    );
  }
}
