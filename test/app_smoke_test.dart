import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:studyflow/app/app.dart';
import 'package:studyflow/services/preferences_service.dart';

void main() {
  tearDown(() async => Get.reset());
  for (final mode in ThemeMode.values) {
    testWidgets('Foundation renders at narrow width in ${mode.name}', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      Get.put<PreferencesService>(MemoryPreferences(mode));
      await tester.pumpWidget(const StudyFlowApp());
      await tester.pumpAndSettle();
      expect(find.text('StudyFlow'), findsOneWidget);
      expect(find.text('Room to grow'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('Theme choice updates appearance and persists the selection', (
    tester,
  ) async {
    final preferences = MemoryPreferences(ThemeMode.light);
    Get.put<PreferencesService>(preferences);
    await tester.pumpWidget(const StudyFlowApp());
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Dark'), 200);
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    expect(preferences.themeMode, ThemeMode.dark);
    expect(
      Theme.of(tester.element(find.byType(Scaffold))).brightness,
      Brightness.dark,
    );
    expect(tester.takeException(), isNull);
  });
}

class MemoryPreferences implements PreferencesService {
  MemoryPreferences(this.themeMode);
  @override
  ThemeMode themeMode;
  @override
  Future<void> saveTheme(ThemeMode mode) async => themeMode = mode;
}
