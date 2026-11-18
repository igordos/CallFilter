import 'package:call_filter/app/theme/app_colors.dart';
import 'package:call_filter/app/theme/app_spacing.dart';
import 'package:call_filter/app/theme/app_typography.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

abstract final class AppTheme {
  static ThemeData light({String? fontFamily}) => _build(
    brightness: Brightness.light,
    colors: AppColors.light,
    fontFamily: fontFamily,
  );

  static ThemeData dark({String? fontFamily}) => _build(
    brightness: Brightness.dark,
    colors: AppColors.dark,
    fontFamily: fontFamily,
  );

  static ThemeData _build({
    required Brightness brightness,
    required AppColors colors,
    String? fontFamily,
  }) {
    final baseTextTheme = AppTypography.textTheme(colors);
    final textTheme = fontFamily == null
        ? baseTextTheme
        : baseTextTheme.apply(fontFamily: fontFamily);
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: colors.primary,
      onPrimary: colors.onPrimary,
      primaryContainer: colors.primaryContainer,
      onPrimaryContainer: colors.onPrimaryContainer,
      secondary: colors.secondary,
      onSecondary: colors.onSecondary,
      secondaryContainer: colors.secondaryContainer,
      onSecondaryContainer: colors.onSecondaryContainer,
      tertiary: colors.tertiary,
      onTertiary: colors.onTertiary,
      tertiaryContainer: colors.tertiaryContainer,
      onTertiaryContainer: colors.onTertiaryContainer,
      error: colors.error,
      onError: colors.onError,
      errorContainer: colors.errorContainer,
      onErrorContainer: colors.onErrorContainer,
      surface: colors.surface,
      onSurface: colors.onSurface,
      onSurfaceVariant: colors.onSurfaceVariant,
      surfaceDim: colors.surfaceContainerLow,
      surfaceBright: colors.surfaceContainerLowest,
      surfaceContainerLowest: colors.surfaceContainerLowest,
      surfaceContainerLow: colors.surfaceContainerLow,
      surfaceContainer: colors.surfaceContainer,
      surfaceContainerHigh: colors.surfaceContainerHigh,
      surfaceContainerHighest: colors.surfaceContainerHighest,
      outline: colors.outline,
      outlineVariant: colors.outlineVariant,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: colors.onSurface,
      onInverseSurface: colors.surface,
      inversePrimary: colors.primaryContainer,
      surfaceTint: colors.primary,
    );

    final overlayStyle = brightness == Brightness.dark
        ? SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: colors.surfaceContainer,
            systemNavigationBarIconBrightness: Brightness.light,
          )
        : SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: colors.surfaceContainer,
            systemNavigationBarIconBrightness: Brightness.dark,
          );

    final labelStyle = WidgetStateProperty.resolveWith<TextStyle?>((states) {
      final selected = states.contains(WidgetState.selected);
      return textTheme.labelSmall?.copyWith(
        color: selected ? colors.onSurface : colors.onSurfaceVariant,
        fontSize: 9.5,
        height: 1.15,
        letterSpacing: 0,
        fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
      );
    });

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      extensions: <ThemeExtension<dynamic>>[colors],
      scaffoldBackgroundColor: colors.background,
      canvasColor: colors.background,
      cardColor: colors.surfaceContainerLow,
      dividerColor: colors.outlineVariant,
      disabledColor: colors.onSurface.withValues(alpha: 0.38),
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.fuchsia: FadeForwardsPageTransitionsBuilder(),
        },
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        foregroundColor: colors.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
        iconTheme: IconThemeData(
          color: colors.onSurfaceVariant,
          size: AppSizes.iconLarge,
        ),
        actionsIconTheme: IconThemeData(
          color: colors.onSurfaceVariant,
          size: AppSizes.iconLarge,
        ),
        systemOverlayStyle: overlayStyle,
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: AppSizes.navBarHeight,
        elevation: 0,
        backgroundColor: colors.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        indicatorColor: colors.secondaryContainer,
        indicatorShape: const StadiumBorder(),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: labelStyle,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected
                ? colors.onSecondaryContainer
                : colors.onSurfaceVariant,
            size: selected ? AppSizes.iconLarge : AppSizes.icon,
          );
        }),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colors.surfaceContainerLow,
        indicatorColor: colors.secondaryContainer,
        selectedIconTheme: IconThemeData(
          color: colors.onSecondaryContainer,
          size: AppSizes.iconLarge,
        ),
        unselectedIconTheme: IconThemeData(
          color: colors.onSurfaceVariant,
          size: AppSizes.icon,
        ),
        selectedLabelTextStyle: textTheme.labelLarge?.copyWith(
          color: colors.onSurface,
        ),
        unselectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: colors.onSurfaceVariant,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceContainerHigh,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: colors.onSurfaceVariant,
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: colors.onSurfaceVariant,
        ),
        floatingLabelStyle: textTheme.bodySmall?.copyWith(
          color: colors.primary,
          fontWeight: FontWeight.w600,
        ),
        helperStyle: textTheme.bodySmall,
        errorStyle: textTheme.bodySmall?.copyWith(color: colors.error),
        helperMaxLines: 3,
        errorMaxLines: 3,
        border: OutlineInputBorder(
          borderRadius: AppRadius.control,
          borderSide: BorderSide(color: colors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.control,
          borderSide: BorderSide(color: colors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.control,
          borderSide: BorderSide(color: colors.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.control,
          borderSide: BorderSide(color: colors.error, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.control,
          borderSide: BorderSide(color: colors.error, width: 1.6),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(
            Size(0, AppSizes.controlHeight),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          ),
          shape: const WidgetStatePropertyAll(StadiumBorder()),
          textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
          elevation: const WidgetStatePropertyAll(0),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(
            Size(0, AppSizes.controlHeight),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          ),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: AppRadius.control),
          ),
          textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
          side: WidgetStatePropertyAll(
            BorderSide(color: colors.outlineVariant),
          ),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            return states.contains(WidgetState.selected)
                ? colors.secondaryContainer
                : colors.surfaceContainerHigh;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            return states.contains(WidgetState.selected)
                ? colors.onSecondaryContainer
                : colors.onSurfaceVariant;
          }),
          side: WidgetStatePropertyAll(BorderSide(color: colors.outline)),
          textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size(0, 48)),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          ),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: AppRadius.full),
          ),
          textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size.square(AppSizes.minTapTarget),
          foregroundColor: colors.onSurfaceVariant,
          backgroundColor: colors.surfaceContainerHigh,
          shape: const CircleBorder(),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? colors.onPrimary
              : colors.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? colors.primary
              : colors.surfaceContainerHighest;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? Colors.transparent
              : colors.outline;
        }),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colors.surfaceContainerHigh,
        selectedColor: colors.secondaryContainer,
        disabledColor: colors.surfaceContainer,
        labelStyle: textTheme.labelLarge,
        secondaryLabelStyle: textTheme.labelLarge?.copyWith(
          color: colors.onSecondaryContainer,
        ),
        side: BorderSide(color: colors.outlineVariant),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        showCheckmark: false,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.primary,
        linearTrackColor: colors.surfaceContainerHighest,
        circularTrackColor: colors.surfaceContainerHighest,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        actionTextColor: colorScheme.inversePrimary,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.dialog),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surfaceContainerLow,
        modalBackgroundColor: colors.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        showDragHandle: false,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.sheet),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: colors.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.large),
        textStyle: textTheme.bodyMedium,
      ),
      tooltipTheme: TooltipThemeData(
        waitDuration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          color: colorScheme.inverseSurface,
          borderRadius: AppRadius.small,
        ),
        textStyle: textTheme.bodySmall?.copyWith(
          color: colorScheme.onInverseSurface,
        ),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xs,
        ),
        iconColor: colors.onSurfaceVariant,
        textColor: colors.onSurface,
        minVerticalPadding: AppSpacing.sm,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.control),
      ),
      dividerTheme: DividerThemeData(
        color: colors.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colors.primary,
        selectionColor: colors.primary.withValues(alpha: 0.24),
        selectionHandleColor: colors.primary,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primaryContainer,
        foregroundColor: colors.onPrimaryContainer,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.xl)),
        ),
      ),
    );
  }
}
