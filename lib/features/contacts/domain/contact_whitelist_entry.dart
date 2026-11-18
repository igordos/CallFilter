/// A phone number that must never be blocked by a rule.
class ContactWhitelistEntry {
  const ContactWhitelistEntry({
    required this.id,
    required this.phoneNumber,
    required this.label,
    required this.createdAt,
  });

  final String id;
  final String phoneNumber;
  final String label;
  final DateTime createdAt;
}
