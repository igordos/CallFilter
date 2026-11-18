// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FilterRule _$FilterRuleFromJson(Map<String, dynamic> json) => _FilterRule(
  id: json['id'] as String,
  name: json['name'] as String,
  pattern: json['pattern'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  isEnabled: json['isEnabled'] as bool? ?? true,
  priority: (json['priority'] as num?)?.toInt() ?? 0,
  description: json['description'] as String?,
);

Map<String, dynamic> _$FilterRuleToJson(_FilterRule instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'pattern': instance.pattern,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'isEnabled': instance.isEnabled,
      'priority': instance.priority,
      'description': instance.description,
    };
