// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform_filter_snapshot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlatformFilterSnapshot _$PlatformFilterSnapshotFromJson(
  Map<String, dynamic> json,
) => PlatformFilterSnapshot(
  filteringEnabled: json['filteringEnabled'] as bool,
  rules: (json['rules'] as List<dynamic>)
      .map((e) => PlatformRule.fromJson(e as Map<String, dynamic>))
      .toList(),
  whitelistNumbers: (json['whitelistNumbers'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  directoryMappings: (json['directoryMappings'] as List<dynamic>)
      .map((e) => CallDirectoryMapping.fromJson(e as Map<String, dynamic>))
      .toList(),
  generatedAt: DateTime.parse(json['generatedAt'] as String),
  schemaVersion:
      (json['schemaVersion'] as num?)?.toInt() ??
      platformFilterSnapshotSchemaVersion,
);

Map<String, dynamic> _$PlatformFilterSnapshotToJson(
  PlatformFilterSnapshot instance,
) => <String, dynamic>{
  'schemaVersion': instance.schemaVersion,
  'filteringEnabled': instance.filteringEnabled,
  'rules': instance.rules.map((e) => e.toJson()).toList(),
  'whitelistNumbers': instance.whitelistNumbers,
  'directoryMappings': instance.directoryMappings
      .map((e) => e.toJson())
      .toList(),
  'generatedAt': instance.generatedAt.toIso8601String(),
};

PlatformRule _$PlatformRuleFromJson(Map<String, dynamic> json) => PlatformRule(
  id: json['id'] as String,
  name: json['name'] as String,
  pattern: json['pattern'] as String,
  priority: (json['priority'] as num).toInt(),
);

Map<String, dynamic> _$PlatformRuleToJson(PlatformRule instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'pattern': instance.pattern,
      'priority': instance.priority,
    };

CallDirectoryMapping _$CallDirectoryMappingFromJson(
  Map<String, dynamic> json,
) => CallDirectoryMapping(
  phoneNumber: json['phoneNumber'] as String,
  label: json['label'] as String,
  shouldBlock: json['shouldBlock'] as bool,
);

Map<String, dynamic> _$CallDirectoryMappingToJson(
  CallDirectoryMapping instance,
) => <String, dynamic>{
  'phoneNumber': instance.phoneNumber,
  'label': instance.label,
  'shouldBlock': instance.shouldBlock,
};
