enum PlatformCapabilityState { available, limited, unavailable }

class PlatformCapabilities {
  const PlatformCapabilities({
    required this.platformName,
    required this.callScreening,
    required this.callerDisplayName,
    required this.callDirectory,
    required this.numberBlocking,
    this.details = '',
  });

  const PlatformCapabilities.unsupported([this.platformName = 'unsupported'])
    : callScreening = PlatformCapabilityState.unavailable,
      callerDisplayName = PlatformCapabilityState.unavailable,
      callDirectory = PlatformCapabilityState.unavailable,
      numberBlocking = PlatformCapabilityState.unavailable,
      details = 'Native call screening is not wired for this platform.';

  final String platformName;
  final PlatformCapabilityState callScreening;
  final PlatformCapabilityState callerDisplayName;
  final PlatformCapabilityState callDirectory;
  final PlatformCapabilityState numberBlocking;
  final String details;

  bool get hasNativeIntegration =>
      callScreening != PlatformCapabilityState.unavailable ||
      callDirectory != PlatformCapabilityState.unavailable;
}
