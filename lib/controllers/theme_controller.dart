import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/preferences_service.dart';

class ThemeController extends GetxController {
  ThemeController(this._preferences);
  final PreferencesService _preferences;
  late final mode = _preferences.themeMode.obs;
  final saving = false.obs;
  Future<void> select(ThemeMode value) async {
    if (saving.value) return;
    saving.value = true;
    try {
      await _preferences.saveTheme(value);
      mode.value = value;
      Get.changeThemeMode(value);
    } catch (_) {
      Get.snackbar('Theme was not saved', 'Please try again.');
    } finally {
      saving.value = false;
    }
  }
}
