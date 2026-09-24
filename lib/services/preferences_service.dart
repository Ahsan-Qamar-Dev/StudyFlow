import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  PreferencesService(this._preferences, this.themeMode);
  final SharedPreferencesAsync _preferences;
  ThemeMode themeMode;
  static Future<PreferencesService> load() async {
    final preferences = SharedPreferencesAsync();
    final saved = await preferences.getString('theme_mode');
    final mode = ThemeMode.values
        .where((mode) => mode.name == saved)
        .firstOrNull;
    return PreferencesService(preferences, mode ?? ThemeMode.system);
  }

  Future<void> saveTheme(ThemeMode mode) async {
    await _preferences.setString('theme_mode', mode.name);
    themeMode = mode;
  }
}
