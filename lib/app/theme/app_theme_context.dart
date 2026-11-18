import 'package:call_filter/app/theme/app_colors.dart';
import 'package:material_ui/material_ui.dart';

extension AppThemeContext on BuildContext {
  AppColors get appColors {
    final colors = Theme.of(this).extension<AppColors>();
    assert(colors != null, 'AppColors theme extension is missing.');
    return colors ?? AppColors.light;
  }

  TextStyle get displayStyle => Theme.of(this).textTheme.displaySmall!;

  TextStyle get displayLargeStyle => Theme.of(this).textTheme.displayMedium!;

  TextStyle get titleStyle => Theme.of(this).textTheme.headlineMedium!;

  TextStyle get titleMediumStyle => Theme.of(this).textTheme.titleMedium!;

  TextStyle get headlineStyle => Theme.of(this).textTheme.titleLarge!;

  TextStyle get headlineLargeStyle => Theme.of(this).textTheme.headlineLarge!;

  TextStyle get bodyStyle => Theme.of(this).textTheme.bodyLarge!;

  TextStyle get bodyMediumStyle => Theme.of(this).textTheme.bodyMedium!;

  TextStyle get bodySmallStyle => Theme.of(this).textTheme.bodySmall!;

  TextStyle get labelStyle => Theme.of(this).textTheme.labelLarge!;

  TextStyle get labelMediumStyle => Theme.of(this).textTheme.labelMedium!;

  TextStyle get captionStyle => Theme.of(this).textTheme.labelSmall!;
}
