/// Data available to the filter when a call is being screened.
///
/// Platforms do not guarantee that [displayName] is present. Android may
/// expose it through `Call.Details`; iOS has no runtime API for arbitrary
/// caller name matching.
class CallerInfo {
  const CallerInfo({required this.phoneNumber, this.displayName});

  final String phoneNumber;
  final String? displayName;
}
