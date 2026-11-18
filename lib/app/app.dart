import 'package:call_filter/app/router/app_router.dart';
import 'package:call_filter/app/theme/app_spacing.dart';
import 'package:call_filter/app/theme/app_theme.dart';
import 'package:call_filter/features/settings/domain/app_settings.dart';
import 'package:call_filter/features/settings/presentation/settings_controller.dart';
import 'package:call_filter/l10n/gen/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

class CallFilterApp extends ConsumerWidget {
  const CallFilterApp({this.fontFamily, super.key});

  final String? fontFamily;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final settings = ref.watch(settingsControllerProvider).asData?.value;
    final localeCode = settings?.localeCode;
    final themeMode = switch (settings?.themeMode ?? AppThemeMode.system) {
      AppThemeMode.system => ThemeMode.system,
      AppThemeMode.light => ThemeMode.light,
      AppThemeMode.dark => ThemeMode.dark,
    };

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: AppTheme.light(fontFamily: fontFamily),
      darkTheme: AppTheme.dark(fontFamily: fontFamily),
      themeMode: themeMode,
      themeAnimationDuration: AppMotion.normal,
      themeAnimationCurve: AppMotion.state,
      locale: localeCode == null ? null : Locale(localeCode),
      supportedLocales: AppLocalizations.supportedLocales,
      // Do not use AppLocalizations.localizationsDelegates here. On Flutter
      // 3.50 gen-l10n references the deprecated flutter_localizations Material
      // delegate, while MaterialApp comes from material_ui. For non-English
      // locales that mismatch produces "No MaterialLocalizations found".
      // GlobalMaterialLocalizations.delegates from material_ui also provides
      // the matching Cupertino and Widgets delegates.
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
