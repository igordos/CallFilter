import 'package:call_filter/core/di/providers.dart';
import 'package:call_filter/features/settings/domain/app_settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsController extends StreamNotifier<AppSettings> {
  @override
  Stream<AppSettings> build() {
    return ref.watch(settingsRepositoryProvider).watchSettings();
  }

  Future<void> setFilteringEnabled({required bool isEnabled}) async {
    final current = state.asData?.value;
    if (current == null) {
      return;
    }
    await _save(current.copyWith(filteringEnabled: isEnabled));
  }

  Future<void> setLogBlockedCalls({required bool isEnabled}) async {
    final current = state.asData?.value;
    if (current == null) {
      return;
    }
    await _save(current.copyWith(logBlockedCalls: isEnabled));
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    final current = state.asData?.value;
    if (current == null) {
      return;
    }
    await _save(current.copyWith(themeMode: mode));
  }

  Future<void> setLocale(String? localeCode) async {
    final current = state.asData?.value;
    if (current == null) {
      return;
    }
    await _save(
      current.copyWith(localeCode: localeCode, clearLocale: localeCode == null),
    );
  }

  Future<void> _save(AppSettings settings) {
    return ref.read(settingsRepositoryProvider).saveSettings(settings);
  }
}

final settingsControllerProvider =
    StreamNotifierProvider<SettingsController, AppSettings>(
      SettingsController.new,
    );
