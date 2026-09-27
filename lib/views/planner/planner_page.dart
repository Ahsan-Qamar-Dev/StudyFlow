import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/theme/design_tokens.dart';
import '../../controllers/preview_controller.dart';
import '../../widgets/study_components.dart';
import '../../widgets/add_sheet.dart';

class PlannerPage extends StatelessWidget {
  const PlannerPage({super.key});
  @override
  Widget build(BuildContext context) {
    final c = Get.find<PreviewController>();
    final now = DateUtils.dateOnly(DateTime.now());
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageIntro(
            'One day at a time',
            'Your planner',
            trailing: IconButton.outlined(
              tooltip: 'Add to your plan',
              onPressed: () => showAddSheet(context),
              icon: const Icon(Icons.add),
            ),
          ),
          Text(
            'A little structure. A lot less stress.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 90 * MediaQuery.textScalerOf(context).scale(1),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (_, index) {
                final date = now.add(Duration(days: index));
                final selected = c.selectedDay.value == index;
                return Semantics(
                  selected: selected,
                  button: true,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () => c.selectedDay.value = index,
                    child: AnimatedContainer(
                      duration: DesignTokens.motion,
                      width: 53 * MediaQuery.textScalerOf(context).scale(1),
                      decoration: BoxDecoration(
                        color: selected
                            ? DesignTokens.charcoal
                            : Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            index == 0 ? 'Today' : days[date.weekday - 1],
                            style: TextStyle(
                              fontSize: 10,
                              color: selected
                                  ? Colors.white70
                                  : Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${date.day}',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: selected
                                  ? DesignTokens.lime
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: index < 3
                                  ? DesignTokens.lime
                                  : Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 26),
          FlowCard(
            color: DesignTokens.mint,
            child: Row(
              children: [
                const Icon(
                  Icons.air_rounded,
                  size: 30,
                  color: DesignTokens.charcoal,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Make space for a break',
                        style: TextStyle(
                          color: DesignTokens.charcoal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'You learn better when you recharge, too.',
                        style: TextStyle(
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
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            children: ['All', 'To do', 'Done']
                .map(
                  (filter) => ChoiceChip(
                    label: Text(filter),
                    selected: c.plannerFilter.value == filter,
                    onSelected: (_) => c.plannerFilter.value = filter,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          SectionTitle(
            c.selectedDay.value == 0 ? 'Today\'s plan' : 'A look ahead',
          ),
          const SizedBox(height: 14),
          if (c.planned.isEmpty)
            const EmptyMessage(
              title: 'A little breathing room',
              subtitle:
                  'Nothing here yet. Add a small step whenever you are ready.',
            )
          else
            ...c.planned.map(
              (task) => TaskCard(task: task, onToggle: () => c.toggle(task)),
            ),
          const SizedBox(height: 24),
          const SectionTitle('Your subjects'),
          const SizedBox(height: 14),
          ...List.generate(
            c.subjects.length,
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FlowCard(
                padding: 18,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: [
                          DesignTokens.mint,
                          DesignTokens.lavender,
                          DesignTokens.peach,
                        ][i % 3],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        [
                          Icons.eco_outlined,
                          Icons.functions_rounded,
                          Icons.menu_book_rounded,
                        ][i % 3],
                        color: DesignTokens.charcoal,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        c.subjects[i],
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Focus on ${c.subjects[i]}',
                      onPressed: () {
                        c.focusSubject.value = c.subjects[i];
                        c.tab.value = 3;
                      },
                      icon: const Icon(Icons.arrow_forward_rounded),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
