import 'package:call_filter/features/settings/domain/app_settings.dart';

/// Persistence boundary for [AppSettings].
abstract interface class SettingsRepository {
  Stream<AppSettings> watchSettings();

  Future<AppSettings> getSettings();

  Future<void> saveSettings(AppSettings settings);
}
