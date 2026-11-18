import 'dart:io';

import 'package:call_filter/app/theme/app_spacing.dart';
import 'package:call_filter/app/theme/app_theme.dart';
import 'package:call_filter/shared/widgets/app_badge.dart';
import 'package:call_filter/shared/widgets/app_button.dart';
import 'package:call_filter/shared/widgets/app_chip.dart';
import 'package:call_filter/shared/widgets/app_status_indicator.dart';
import 'package:call_filter/shared/widgets/app_switch.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/test_fonts.dart';

Widget _preview({required bool dark}) {
  final theme = dark
      ? AppTheme.dark(fontFamily: 'Roboto')
      : AppTheme.light(fontFamily: 'Roboto');
  return MaterialApp(
    theme: theme,
    home: Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: RepaintBoundary(
          key: const Key('expressive_golden'),
          child: Container(
            width: 430,
            color: theme.scaffoldBackgroundColor,
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppStatusIndicator(
                  title: 'Filtering is on',
                  description: 'Active rules are checked for incoming calls.',
                  icon: Icons.shield_outlined,
                  trailing: AppSwitch(
                    value: true,
                    semanticLabel: 'Call filtering',
                    onChanged: (_) {},
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                const Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    AppBadge(label: 'Blocked', variant: AppBadgeVariant.error),
                    AppBadge(
                      label: 'Allowed',
                      variant: AppBadgeVariant.success,
                    ),
                    AppBadge(
                      label: 'Limited',
                      variant: AppBadgeVariant.warning,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                AppChip(label: 'All', selected: true, onSelected: (_) {}),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: 'Save',
                        onPressed: () {},
                        expand: true,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: AppButton(
                        label: 'Cancel',
                        variant: AppButtonVariant.secondary,
                        onPressed: () {},
                        expand: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('expressive components light theme', (tester) async {
    await tester.pumpWidget(_preview(dark: false));
    await tester.pumpAndSettle();
    await expectLater(
      find.byKey(const Key('expressive_golden')),
      matchesGoldenFile('expressive_components_light.png'),
    );
  }, skip: !Platform.isMacOS);

  testWidgets('expressive components dark theme', (tester) async {
    await tester.pumpWidget(_preview(dark: true));
    await tester.pumpAndSettle();
    await expectLater(
      find.byKey(const Key('expressive_golden')),
      matchesGoldenFile('expressive_components_dark.png'),
    );
  }, skip: !Platform.isMacOS);
}
