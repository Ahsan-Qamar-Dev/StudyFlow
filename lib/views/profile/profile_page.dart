import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../app/theme/design_tokens.dart';
import '../../controllers/preview_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../widgets/study_components.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    final c = Get.find<PreviewController>();
    final appearance = Get.find<ThemeController>();
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageIntro('Look how far you can go', 'Your space'),
          FlowCard(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: DesignTokens.lavender,
                  child: Text(
                    c.name.value.isEmpty ? 'A' : c.name.value[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 26,
                      color: DesignTokens.charcoal,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c.name.value,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${c.education.value} · Lifelong learner',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Personalize your space',
                  onPressed: () => Get.toNamed(AppRoutes.welcome),
                  icon: const Icon(Icons.edit_outlined),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const SectionTitle('Little efforts add up'),
          const SizedBox(height: 14),
          const FlowCard(
            color: DesignTokens.charcoal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'THIS WEEK · SAMPLE',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 10,
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '6h 15m',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 38,
                    letterSpacing: -1.5,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Time invested in yourself.',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                SizedBox(height: 22),
                WeeklyChart(dark: true),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FlowCard(
                  color: DesignTokens.mint,
                  padding: 18,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.local_fire_department_outlined,
                        color: DesignTokens.charcoal,
                      ),
                      SizedBox(height: 15),
                      Text(
                        '3 days',
                        style: TextStyle(
                          color: DesignTokens.charcoal,
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Sample streak',
                        style: TextStyle(
                          color: DesignTokens.charcoal,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FlowCard(
                  color: DesignTokens.lavender,
                  padding: 18,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.task_alt_rounded,
                        color: DesignTokens.charcoal,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        '${c.completed} done',
                        style: const TextStyle(
                          color: DesignTokens.charcoal,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Today\'s preview tasks',
                        style: TextStyle(
                          color: DesignTokens.charcoal,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          const SectionTitle('Make it your own'),
          const SizedBox(height: 14),
          FlowCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Appearance',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: ThemeMode.values
                      .map(
                        (mode) => ChoiceChip(
                          label: Text(switch (mode) {
                            ThemeMode.system => 'System',
                            ThemeMode.light => 'Light',
                            ThemeMode.dark => 'Dark',
                          }),
                          selected: appearance.mode.value == mode,
                          onSelected: appearance.saving.value
                              ? null
                              : (_) => appearance.select(mode),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.flag_outlined),
                    const SizedBox(width: 12),
                    const Expanded(child: Text('Daily intention')),
                    Text(
                      '${c.goal.value} min',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Slider(
                  value: c.goal.value.toDouble(),
                  min: 30,
                  max: 240,
                  divisions: 7,
                  label: '${c.goal.value} min',
                  onChanged: (value) => c.goal.value = value.round(),
                ),
                Text(
                  'Small and steady is a wonderful place to start.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          FlowCard(
            child: Column(
              children: [
                _row(
                  context,
                  Icons.shield_outlined,
                  'Your space stays yours',
                  'No account. No cloud. No pressure.',
                  'StudyFlow is being built around local storage. This UI preview uses sample data in memory; only appearance is saved. No study information is sent to a server.',
                ),
                const Divider(height: 30),
                _row(
                  context,
                  Icons.favorite_outline_rounded,
                  'Made for your own pace',
                  'About StudyFlow',
                  'StudyFlow helps you turn big study goals into small daily steps. This is the interactive UI preview. Real study persistence, planning, reminders, and statistics will follow.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: TextButton(
              onPressed: () => showLicensePage(
                context: context,
                applicationName: 'StudyFlow',
                applicationVersion: 'UI preview',
              ),
              child: const Text('Open-source licenses'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    String detail,
  ) => InkWell(
    borderRadius: BorderRadius.circular(14),
    onTap: () => showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(detail),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(subtitle, style: const TextStyle(fontSize: 11)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 20),
        ],
      ),
    ),
  );
}
