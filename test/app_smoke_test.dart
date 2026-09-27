import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:studyflow/app/app.dart';
import 'package:studyflow/controllers/preview_controller.dart';
import 'package:studyflow/services/preferences_service.dart';

void main() {
  tearDown(() async => Get.reset());
  Future<void> start(
    WidgetTester tester,
    ThemeMode mode, {
    double scale = 1,
  }) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = scale;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    Get.put<PreferencesService>(MemoryPreferences(mode));
    await tester.pumpWidget(const StudyFlowApp());
    await tester.pumpAndSettle();
  }

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('Welcome and all screens render in ${mode.name}', (
      tester,
    ) async {
      await start(tester, mode);
      expect(find.text('StudyFlow'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('Explore the preview'), 200);
      await tester.tap(find.text('Explore the preview'));
      await tester.pumpAndSettle();
      for (final tab in [0, 1, 3, 4]) {
        Get.find<PreviewController>().tab.value = tab;
        await tester.pumpAndSettle();
        expect(find.text('UI preview · sample data'), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.drag(
          find.byType(SingleChildScrollView).first,
          const Offset(0, -1200),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
    });
  }

  testWidgets('Large text works across the main screens', (tester) async {
    await start(tester, ThemeMode.light, scale: 1.6);
    await tester.scrollUntilVisible(find.text('Explore the preview'), 200);
    await tester.tap(find.text('Explore the preview'));
    await tester.pumpAndSettle();
    for (final tab in [0, 1, 3, 4]) {
      Get.find<PreviewController>().tab.value = tab;
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('Preview task creation, completion, navigation and theme work', (
    tester,
  ) async {
    await start(tester, ThemeMode.light);
    await tester.scrollUntilVisible(find.text('Explore the preview'), 200);
    await tester.tap(find.text('Explore the preview'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Add'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Task'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextFormField).first,
      'Review chemistry',
    );
    await tester.scrollUntilVisible(
      find.text('Add task'),
      150,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Add task'));
    await tester.pumpAndSettle();
    final c = Get.find<PreviewController>();
    expect(c.tasks.last.title, 'Review chemistry');
    expect(c.tab.value, 1);
    c.toggle(c.tasks.last);
    expect(c.tasks.last.done, isTrue);
    c.tab.value = 4;
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Dark'), 250);
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    expect(Get.find<PreferencesService>().themeMode, ThemeMode.dark);
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
