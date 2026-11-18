import 'package:call_filter/core/di/providers.dart';
import 'package:call_filter/features/rules/domain/rules_repository.dart';
import 'package:call_filter/features/rules/presentation/rules_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/test_app.dart';

class MockRulesRepository extends Mock implements RulesRepository;

void main() {
  setUpAll(() {
    registerFallbackValue(buildRule());
  });

  test(
    'controller uses the repository overridden in the provider container',
    () async {
      final repository = MockRulesRepository();
      final firstRule = buildRule();
      final secondRule = buildRule(id: 'rule-2', name: 'Банк');

      when(repository.watchRules).thenAnswer((_) => Stream.value([firstRule]));
      when(() => repository.saveRule(any())).thenAnswer((_) async {});

      final container = ProviderContainer(
        overrides: [rulesRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);
      final subscription = container.listen(
        rulesControllerProvider,
        (previous, next) {},
      );
      addTearDown(subscription.close);

      await Future<void>.delayed(Duration.zero);
      expect(container.read(rulesControllerProvider).value, [firstRule]);

      await container
          .read(rulesControllerProvider.notifier)
          .saveRule(secondRule);

      verify(() => repository.saveRule(secondRule)).called(1);
    },
  );
}
