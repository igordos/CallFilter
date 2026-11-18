import 'package:call_filter/features/rules/domain/filter_rule.dart';

/// Persistence boundary for [FilterRule] values.
abstract interface class RulesRepository {
  Stream<List<FilterRule>> watchRules();

  Future<List<FilterRule>> getRules();

  Future<FilterRule?> getRuleById(String id);

  Future<void> saveRule(FilterRule rule);

  Future<void> setRuleEnabled(String id, {required bool isEnabled});

  Future<void> deleteRule(String id);
}
