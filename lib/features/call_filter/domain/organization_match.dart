import 'package:freezed_annotation/freezed_annotation.dart';

part 'organization_match.freezed.dart';

/// The rule and organization name that caused a call to be blocked.
@freezed
abstract class OrganizationMatch with _$OrganizationMatch {
  const factory OrganizationMatch({
    required String organizationName,
    required String normalizedOrganizationName,
    required String ruleId,
    required String ruleName,
  }) = _OrganizationMatch;
}
