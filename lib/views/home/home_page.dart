import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/theme/design_tokens.dart';
import '../../controllers/preview_controller.dart';
import '../../widgets/study_components.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final c = Get.find<PreviewController>();
    final theme = Theme.of(context);
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'A FRESH START',
                      style: theme.textTheme.labelSmall?.copyWith(
                        letterSpacing: 1.8,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      'Hey, ${c.name.value} ☀',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton.filledTonal(
                onPressed: () => c.tab.value = 4,
                tooltip: 'Your profile',
                icon: Text(
                  c.name.value.isEmpty ? 'A' : c.name.value[0].toUpperCase(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Text(
            'Small steps.\nBig possibilities.',
            style: theme.textTheme.displaySmall?.copyWith(
              height: 1.1,
              letterSpacing: -1.8,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Let us make a little progress today.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 26),
          FlowCard(
            color: DesignTokens.charcoal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'YOUR DAILY MOMENTUM',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              letterSpacing: 1.6,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            '45',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 46,
                              height: 1,
                              letterSpacing: -2,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            'of ${c.goal.value} minutes',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ProgressRing(
                      progress: 45 / c.goal.value,
                      size: 100,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.bolt_rounded,
                            color: DesignTokens.lime,
                            size: 28,
                          ),
                          Text(
                            '${(45 / c.goal.value * 100).round()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                const Divider(color: Colors.white12),
                const SizedBox(height: 10),
                const Row(
                  children: [
                    Icon(
                      Icons.local_fire_department_outlined,
                      color: DesignTokens.lime,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '3 days of showing up',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    Text(
                      'Keep going ↗',
                      style: TextStyle(color: DesignTokens.lime, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          const SectionTitle('A good place to start'),
          const SizedBox(height: 14),
          FlowCard(
            color: DesignTokens.lime,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Tag(
                      'UP NEXT',
                      color: Color(0xFFF3FFD7),
                      icon: Icons.auto_awesome_outlined,
                    ),
                    Spacer(),
                    Icon(
                      Icons.north_east_rounded,
                      color: DesignTokens.charcoal,
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                const Text(
                  'Get to know\nyour cells.',
                  style: TextStyle(
                    color: DesignTokens.charcoal,
                    fontSize: 30,
                    height: 1.12,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Biology · Cell structure & function',
                  style: TextStyle(color: DesignTokens.charcoal, fontSize: 12),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: DesignTokens.charcoal,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          c.focusSubject.value = 'Biology';
                          c.tab.value = 3;
                        },
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: const Text('Start a little focus'),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Text(
                      '25 min',
                      style: TextStyle(
                        color: DesignTokens.charcoal,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SectionTitle(
            'Your little to-do list',
            action: 'See all',
            onTap: () => c.tab.value = 1,
          ),
          const SizedBox(height: 5),
          Text(
            '${c.completed} of ${c.today.length} done. Every step counts.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          ...c.today.map(
            (task) => TaskCard(task: task, onToggle: () => c.toggle(task)),
          ),
          const SizedBox(height: 16),
          const SectionTitle('On the horizon'),
          const SizedBox(height: 14),
          ...c.exams
              .take(2)
              .map(
                (exam) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: FlowCard(
                    color: DesignTokens.lavender,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(13),
                          decoration: BoxDecoration(
                            color: Colors.white54,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(
                            Icons.event_note_rounded,
                            color: DesignTokens.charcoal,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exam.title,
                                style: const TextStyle(
                                  color: DesignTokens.charcoal,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${exam.date.difference(DateUtils.dateOnly(DateTime.now())).inDays} days to feel ready',
                                style: const TextStyle(
                                  color: DesignTokens.charcoal,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          const SizedBox(height: 14),
          SectionTitle(
            'Your week, in focus',
            action: 'Insights',
            onTap: () => c.tab.value = 4,
          ),
          const SizedBox(height: 14),
          const FlowCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '6h 15m',
                  style: TextStyle(fontSize: 32, letterSpacing: -1),
                ),
                SizedBox(height: 4),
                Text('A little more each day', style: TextStyle(fontSize: 12)),
                SizedBox(height: 16),
                WeeklyChart(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
