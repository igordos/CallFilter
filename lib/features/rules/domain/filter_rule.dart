import 'package:freezed_annotation/freezed_annotation.dart';

part 'filter_rule.freezed.dart';
part 'filter_rule.g.dart';

/// A user-defined rule that matches a normalized caller display name.
@freezed
abstract class FilterRule with _$FilterRule {
  const factory FilterRule({
    required String id,
    required String name,
    required String pattern,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(true) bool isEnabled,
    @Default(0) int priority,
    String? description,
  }) = _FilterRule;

  factory FilterRule.fromJson(Map<String, dynamic> json) =>
      _$FilterRuleFromJson(json);
}
