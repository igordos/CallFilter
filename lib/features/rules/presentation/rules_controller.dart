import 'package:call_filter/core/di/providers.dart';
import 'package:call_filter/features/rules/domain/filter_rule.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RulesController extends StreamNotifier<List<FilterRule>> {
  @override
  Stream<List<FilterRule>> build() {
    return ref.watch(rulesRepositoryProvider).watchRules();
  }

  Future<void> saveRule(FilterRule rule) {
    return ref.read(rulesRepositoryProvider).saveRule(rule);
  }

  Future<void> toggleRule(FilterRule rule, {required bool isEnabled}) {
    return ref
        .read(rulesRepositoryProvider)
        .setRuleEnabled(rule.id, isEnabled: isEnabled);
  }

  Future<void> deleteRule(String id) {
    return ref.read(rulesRepositoryProvider).deleteRule(id);
  }
}

final rulesControllerProvider =
    StreamNotifierProvider<RulesController, List<FilterRule>>(
      RulesController.new,
    );
