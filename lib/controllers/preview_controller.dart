import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/theme/design_tokens.dart';

class PreviewTask {
  PreviewTask(
    this.title,
    this.subject,
    this.minutes,
    this.color, {
    this.done = false,
    this.day = 0,
  });
  final String title;
  final String subject;
  final int minutes;
  final Color color;
  final int day;
  bool done;
}

class PreviewExam {
  PreviewExam(this.title, this.subject, this.date);
  final String title;
  final String subject;
  final DateTime date;
}

/// Presentation-only sandbox. No sample records are written to SQLite.
class PreviewController extends GetxController {
  final tab = 0.obs;
  final name = 'Alex'.obs;
  final education = 'University'.obs;
  final goal = 120.obs;
  final selectedDay = 0.obs;
  final plannerFilter = 'All'.obs;
  final subjects = <String>['Biology', 'Mathematics', 'Literature'].obs;
  final tasks = <PreviewTask>[
    PreviewTask('Cell structure & function', 'Biology', 25, DesignTokens.mint),
    PreviewTask(
      'Practice derivatives',
      'Mathematics',
      40,
      DesignTokens.lavender,
    ),
    PreviewTask(
      'Read chapter 04',
      'Literature',
      20,
      DesignTokens.peach,
      done: true,
    ),
    PreviewTask(
      'Review your flashcards',
      'Biology',
      20,
      DesignTokens.mint,
      day: 1,
    ),
    PreviewTask(
      'Solve practice questions',
      'Mathematics',
      30,
      DesignTokens.lavender,
      day: 2,
    ),
  ].obs;
  final exams = <PreviewExam>[
    PreviewExam(
      'Biology midterm',
      'Biology',
      DateTime.now().add(const Duration(days: 6)),
    ),
  ].obs;
  final focusSubject = 'Biology'.obs;
  final focusMinutes = 25.obs;
  final remaining = (25 * 60).obs;
  final running = false.obs;
  final hasStarted = false.obs;
  final sessions = 0.obs;
  Timer? _ticker;
  DateTime? _deadline;

  List<PreviewTask> get today => tasks.where((task) => task.day == 0).toList();
  int get completed => today.where((task) => task.done).length;
  List<PreviewTask> get planned => tasks
      .where(
        (task) =>
            task.day == selectedDay.value &&
            (plannerFilter.value == 'All' ||
                (plannerFilter.value == 'Done' ? task.done : !task.done)),
      )
      .toList();

  void toggle(PreviewTask task) {
    task.done = !task.done;
    tasks.refresh();
  }

  void setDuration(int minutes) {
    if (hasStarted.value) return;
    focusMinutes.value = minutes;
    remaining.value = minutes * 60;
  }

  void toggleTimer() {
    if (running.value) {
      _refreshTimer();
      running.value = false;
      _ticker?.cancel();
      _deadline = null;
    } else {
      if (remaining.value <= 0) remaining.value = focusMinutes.value * 60;
      hasStarted.value = true;
      _deadline = DateTime.now().add(Duration(seconds: remaining.value));
      running.value = true;
      _ticker = Timer.periodic(
        const Duration(milliseconds: 250),
        (_) => _refreshTimer(),
      );
    }
  }

  void _refreshTimer() {
    if (_deadline == null) return;
    remaining.value =
        ((_deadline!.difference(DateTime.now()).inMilliseconds / 1000).ceil())
            .clamp(0, focusMinutes.value * 60);
    if (remaining.value == 0) {
      _ticker?.cancel();
      running.value = false;
      hasStarted.value = false;
      _deadline = null;
      sessions.value++;
      Get.snackbar(
        'A little progress, made.',
        'Preview session complete. Take a gentle break.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void resetTimer() {
    _ticker?.cancel();
    _deadline = null;
    running.value = false;
    hasStarted.value = false;
    remaining.value = focusMinutes.value * 60;
  }

  @override
  void onClose() {
    _ticker?.cancel();
    super.onClose();
  }
}
