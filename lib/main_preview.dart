import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/app.dart';
import 'services/preferences_service.dart';

/// UI-only entry point for web review. It does not initialize SQLite.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(await PreferencesService.load(), permanent: true);
  runApp(const StudyFlowApp());
}
