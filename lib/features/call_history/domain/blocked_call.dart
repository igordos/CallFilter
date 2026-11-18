/// A locally recorded call that was rejected by a rule.
class BlockedCall {
  const BlockedCall({
    required this.id,
    required this.phoneNumber,
    required this.organizationName,
    required this.ruleId,
    required this.ruleName,
    required this.blockedAt,
  });

  final String id;
  final String phoneNumber;
  final String? organizationName;
  final String? ruleId;
  final String? ruleName;
  final DateTime blockedAt;
}
