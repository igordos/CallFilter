enum AppThemeMode { system, light, dark }

/// Local, user-controlled app settings.
class AppSettings {
  const AppSettings({
    required this.filteringEnabled,
    required this.logBlockedCalls,
    this.themeMode = AppThemeMode.system,
    this.localeCode,
  });

  const AppSettings.defaults()
    : filteringEnabled = true,
      logBlockedCalls = true,
      themeMode = AppThemeMode.system,
      localeCode = null;

  final bool filteringEnabled;
  final bool logBlockedCalls;
  final AppThemeMode themeMode;

  /// `null` follows the system locale. Supported values are `en` and `ru`.
  final String? localeCode;

  AppSettings copyWith({
    bool? filteringEnabled,
    bool? logBlockedCalls,
    AppThemeMode? themeMode,
    String? localeCode,
    bool clearLocale = false,
  }) {
    return AppSettings(
      filteringEnabled: filteringEnabled ?? this.filteringEnabled,
      logBlockedCalls: logBlockedCalls ?? this.logBlockedCalls,
      themeMode: themeMode ?? this.themeMode,
      localeCode: clearLocale ? null : localeCode ?? this.localeCode,
    );
  }
}
