import 'package:json_annotation/json_annotation.dart';

part 'platform_filter_snapshot.g.dart';

/// Current wire schema for [PlatformFilterSnapshot].
const int platformFilterSnapshotSchemaVersion = 1;

/// Data handed to the native layer.
///
/// Android can attempt name matching at screening time. iOS cannot: a Call
/// Directory extension can only consume prepared number-to-label mappings.
@JsonSerializable(explicitToJson: true)
class PlatformFilterSnapshot {
  const PlatformFilterSnapshot({
    required this.filteringEnabled,
    required this.rules,
    required this.whitelistNumbers,
    required this.directoryMappings,
    required this.generatedAt,
    this.schemaVersion = platformFilterSnapshotSchemaVersion,
  });

  factory PlatformFilterSnapshot.fromJson(Map<String, dynamic> json) =>
      _$PlatformFilterSnapshotFromJson(json);

  static const int currentSchemaVersion = platformFilterSnapshotSchemaVersion;

  final int schemaVersion;
  final bool filteringEnabled;
  final List<PlatformRule> rules;
  final List<String> whitelistNumbers;
  final List<CallDirectoryMapping> directoryMappings;
  final DateTime generatedAt;

  Map<String, dynamic> toJson() => _$PlatformFilterSnapshotToJson(this);
}

@JsonSerializable()
class PlatformRule {
  const PlatformRule({
    required this.id,
    required this.name,
    required this.pattern,
    required this.priority,
  });

  factory PlatformRule.fromJson(Map<String, dynamic> json) =>
      _$PlatformRuleFromJson(json);

  final String id;
  final String name;
  final String pattern;
  final int priority;

  Map<String, dynamic> toJson() => _$PlatformRuleToJson(this);
}

@JsonSerializable()
class CallDirectoryMapping {
  const CallDirectoryMapping({
    required this.phoneNumber,
    required this.label,
    required this.shouldBlock,
  });

  factory CallDirectoryMapping.fromJson(Map<String, dynamic> json) =>
      _$CallDirectoryMappingFromJson(json);

  final String phoneNumber;
  final String label;
  final bool shouldBlock;

  Map<String, dynamic> toJson() => _$CallDirectoryMappingToJson(this);
}
