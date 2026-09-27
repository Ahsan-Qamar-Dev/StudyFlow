import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/theme/design_tokens.dart';
import '../../controllers/preview_controller.dart';
import '../../widgets/study_components.dart';

class FocusPage extends StatelessWidget {
  const FocusPage({super.key});
  @override
  Widget build(BuildContext context) {
    final c = Get.find<PreviewController>();
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const PageIntro('A moment for your mind', 'Find your flow'),
          const SizedBox(height: 4),
          const Text(
            'One thing at a time is enough.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 26),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children:
                [25, 50]
                    .map<Widget>(
                      (minutes) => ChoiceChip(
                        label: Text('$minutes min'),
                        selected: c.focusMinutes.value == minutes,
                        onSelected: c.hasStarted.value
                            ? null
                            : (_) => c.setDuration(minutes),
                      ),
                    )
                    .toList()
                  ..add(
                    ActionChip(
                      label: const Text('Custom'),
                      onPressed: c.hasStarted.value
                          ? null
                          : () => _custom(context, c),
                    ),
                  ),
          ),
          const SizedBox(height: 36),
          LayoutBuilder(
            builder: (_, constraints) {
              final size = constraints.maxWidth.clamp(180.0, 280.0);
              return ProgressRing(
                size: size,
                stroke: 10,
                progress: c.remaining.value / (c.focusMinutes.value * 60),
                color: Theme.of(context).brightness == Brightness.dark
                    ? DesignTokens.lime
                    : const Color(0xFF749354),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      c.running.value
                          ? Icons.spa_outlined
                          : Icons.wb_sunny_outlined,
                      size: 30,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: size - 40,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '${(c.remaining.value ~/ 60).toString().padLeft(2, "0")}:${(c.remaining.value % 60).toString().padLeft(2, "0")}',
                          style: TextStyle(
                            fontSize: size * .20,
                            height: 1,
                            fontWeight: FontWeight.w300,
                            letterSpacing: -3,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      c.running.value
                          ? 'You are doing something good.'
                          : c.hasStarted.value
                          ? 'Take your time.'
                          : 'A fresh little start.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 36),
          DropdownButtonFormField<String>(
            initialValue: c.focusSubject.value,
            key: ValueKey(c.focusSubject.value),
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'A little focus on',
              prefixIcon: Icon(Icons.auto_stories_outlined),
            ),
            items: c.subjects
                .map(
                  (s) => DropdownMenuItem(
                    value: s,
                    child: Text(s, overflow: TextOverflow.ellipsis),
                  ),
                )
                .toList(),
            onChanged: c.hasStarted.value
                ? null
                : (value) => c.focusSubject.value = value!,
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: c.toggleTimer,
              icon: Icon(
                c.running.value
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
              ),
              label: Text(
                c.running.value
                    ? 'Pause for a moment'
                    : c.hasStarted.value
                    ? 'Back to your flow'
                    : 'Let us begin',
              ),
            ),
          ),
          if (c.hasStarted.value)
            TextButton(
              onPressed: c.resetTimer,
              child: const Text('End this preview session'),
            ),
          const SizedBox(height: 24),
          const Text(
            'Breathe in. Let your shoulders drop.\nYou only need to be here, now.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, height: 1.7),
          ),
          const SizedBox(height: 28),
          FlowCard(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            padding: 16,
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Preview timer · sessions are not saved. ${c.sessions.value > 0 ? "${c.sessions.value} completed in this preview." : "Your real study history comes later."}',
                    style: const TextStyle(fontSize: 11, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _custom(BuildContext context, PreviewController c) async {
    var duration = c.focusMinutes.value.toDouble();
    final result = await showDialog<int>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, update) => AlertDialog(
          title: const Text('Your own pace'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${duration.round()} minutes',
                style: const TextStyle(fontSize: 24),
              ),
              Slider(
                value: duration,
                min: 5,
                max: 120,
                divisions: 23,
                onChanged: (value) => update(() => duration = value),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, duration.round()),
              child: const Text('Set time'),
            ),
          ],
        ),
      ),
    );
    if (result != null) c.setDuration(result);
  }
}
