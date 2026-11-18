import 'package:call_filter/app/theme/app_colors.dart';
import 'package:call_filter/app/theme/app_theme.dart';
import 'package:call_filter/shared/widgets/app_badge.dart';
import 'package:call_filter/shared/widgets/app_button.dart';
import 'package:call_filter/shared/widgets/app_card.dart';
import 'package:call_filter/shared/widgets/app_text_field.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  test('light and dark themes expose the semantic colour extension', () {
    expect(AppTheme.light().brightness, Brightness.light);
    expect(AppTheme.dark().brightness, Brightness.dark);
    expect(AppTheme.light().extension<AppColors>(), AppColors.light);
    expect(AppTheme.dark().extension<AppColors>(), AppColors.dark);
  });

  testWidgets('AppButton supports variants, loading and disabled states', (
    tester,
  ) async {
    var primaryTaps = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppButton(label: 'Primary', onPressed: () => primaryTaps++),
                AppButton(
                  label: 'Secondary',
                  variant: AppButtonVariant.secondary,
                  onPressed: () {},
                ),
                AppButton(
                  label: 'Danger',
                  variant: AppButtonVariant.destructive,
                  onPressed: () {},
                ),
                const AppButton(label: 'Disabled'),
                AppButton(label: 'Saving', isLoading: true, onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Primary'));
    expect(primaryTaps, 1);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Primary'), findsOneWidget);
    expect(find.text('Secondary'), findsOneWidget);
    expect(find.text('Danger'), findsOneWidget);
  });

  testWidgets('AppTextField shows inline validation errors', (tester) async {
    final formKey = GlobalKey<FormState>();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  AppTextField(
                    fieldKey: const Key('validated_field'),
                    label: 'Name',
                    validator: (value) =>
                        (value ?? '').isEmpty ? 'Required' : null,
                  ),
                  AppButton(
                    label: 'Validate',
                    onPressed: () => formKey.currentState?.validate(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Validate'));
    await tester.pump();
    expect(find.text('Required'), findsOneWidget);
  });

  testWidgets('design components survive increased text scaling', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppBadge(
                    label: 'Available',
                    variant: AppBadgeVariant.success,
                  ),
                  const SizedBox(height: 8),
                  AppCard(
                    child: Column(
                      children: [
                        AppButton(
                          label: 'A longer localized action label',
                          onPressed: () {},
                          expand: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Available'), findsOneWidget);
  });
}
