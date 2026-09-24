import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/preferences_service.dart';
import 'bindings/initial_binding.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';

class StudyFlowApp extends StatelessWidget {
  const StudyFlowApp({super.key});
  @override
  Widget build(BuildContext context) => GetMaterialApp(
    title: 'StudyFlow',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    themeMode: Get.find<PreferencesService>().themeMode,
    initialBinding: InitialBinding(),
    initialRoute: AppRoutes.home,
    getPages: AppPages.pages,
  );
}
