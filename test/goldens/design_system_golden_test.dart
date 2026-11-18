import 'dart:io';

import 'package:call_filter/app/theme/app_colors.dart';
import 'package:call_filter/app/theme/app_spacing.dart';
import 'package:call_filter/app/theme/app_theme.dart';
import 'package:call_filter/shared/widgets/app_badge.dart';
import 'package:call_filter/shared/widgets/app_button.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../helpers/test_fonts.dart';

void main() {
  setUpAll(loadGoldenFonts);

  testWidgets('design system controls render consistently on macOS', (
    tester,
  ) async {
    final goldenKey = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(fontFamily: 'Roboto'),
        home: Scaffold(
          backgroundColor: AppColors.light.background,
          body: Center(
            child: RepaintBoundary(
              key: goldenKey,
              child: DecoratedBox(
                decoration: BoxDecoration(color: AppColors.light.surface),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppBadge(
                        label: 'Filtering on',
                        variant: AppBadgeVariant.success,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppButton(
                        label: 'Primary action',
                        onPressed: () {},
                        expand: true,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppButton(
                        label: 'Secondary action',
                        variant: AppButtonVariant.secondary,
                        onPressed: () {},
                        expand: true,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppButton(
                        label: 'Destructive action',
                        variant: AppButtonVariant.destructive,
                        onPressed: () {},
                        expand: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byKey(goldenKey),
      matchesGoldenFile('design_system_buttons_light.png'),
    );
  }, skip: !Platform.isMacOS);
}
