import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/app.dart';
import 'services/database_service.dart';
import 'services/preferences_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    Get.put(await DatabaseService.open(), permanent: true);
    Get.put(await PreferencesService.load(), permanent: true);
    runApp(const StudyFlowApp());
  } catch (_) {
    runApp(
      MaterialApp(
        home: Scaffold(
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.storage_rounded, size: 48),
                    const SizedBox(height: 20),
                    const Text(
                      'We could not open your study space.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Your data has not been reset. Free up device storage and reopen the app.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
