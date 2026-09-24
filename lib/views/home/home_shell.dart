import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/theme/design_tokens.dart';
import '../../controllers/theme_controller.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<ThemeController>();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: DesignTokens.lime,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.auto_stories_rounded,
                        color: DesignTokens.charcoal,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'StudyFlow',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                Text(
                  'A little focus.\nA brighter tomorrow.',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.15,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Your own space to learn, one step at a time.',
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 32),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.spa_outlined, size: 40),
                        const SizedBox(height: 20),
                        Text(
                          'Room to grow',
                          style: theme.textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Your study space is ready. Subjects, daily plans, and focus sessions will arrive in the next development phases.',
                        ),
                        const SizedBox(height: 24),
                        const Row(
                          children: [
                            Icon(Icons.offline_bolt_outlined, size: 20),
                            SizedBox(width: 8),
                            Expanded(child: Text('Built to work offline')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'Make it feel like you',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                Obx(
                  () => Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ThemeMode.values
                        .map(
                          (mode) => ChoiceChip(
                            avatar: Icon(switch (mode) {
                              ThemeMode.system =>
                                Icons.brightness_auto_outlined,
                              ThemeMode.light => Icons.light_mode_outlined,
                              ThemeMode.dark => Icons.dark_mode_outlined,
                            }, size: 18),
                            label: Text(switch (mode) {
                              ThemeMode.system => 'System',
                              ThemeMode.light => 'Light',
                              ThemeMode.dark => 'Dark',
                            }),
                            selected: controller.mode.value == mode,
                            onSelected: controller.saving.value
                                ? null
                                : (_) => controller.select(mode),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Foundation preview · Phase 1',
                  style: theme.textTheme.labelMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
