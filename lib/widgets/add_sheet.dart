import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/theme/design_tokens.dart';
import '../controllers/preview_controller.dart';
import 'study_components.dart';

Future<void> showAddSheet(BuildContext context) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => const _AddSheet(),
);

class _AddSheet extends StatefulWidget {
  const _AddSheet();
  @override
  State<_AddSheet> createState() => _AddSheetState();
}

class _AddSheetState extends State<_AddSheet> {
  String? kind;
  String? subject;
  int minutes = 25;
  DateTime date = DateUtils.dateOnly(DateTime.now());
  final title = TextEditingController();
  final form = GlobalKey<FormState>();
  @override
  void dispose() {
    title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PreviewController>();
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          0,
          24,
          MediaQuery.viewInsetsOf(context).bottom + 24,
        ),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    if (kind != null)
                      IconButton(
                        tooltip: 'Back',
                        onPressed: () => setState(() => kind = null),
                        icon: const Icon(Icons.arrow_back),
                      ),
                    Expanded(
                      child: Text(
                        kind == null
                            ? 'Make a little plan'
                            : 'Add a ${kind!.toLowerCase()}',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(letterSpacing: -.8),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Close',
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'UI preview · additions stay in this session.',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 24),
                if (kind == null) ...[
                  _option(
                    'Task',
                    'One small thing to get done',
                    Icons.check_rounded,
                    DesignTokens.lime,
                  ),
                  _option(
                    'Subject',
                    'Give your learning a home',
                    Icons.auto_stories_outlined,
                    DesignTokens.mint,
                  ),
                  _option(
                    'Exam',
                    'Something to work towards',
                    Icons.event_outlined,
                    DesignTokens.lavender,
                  ),
                ] else
                  Form(
                    key: form,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: title,
                          textCapitalization: TextCapitalization.sentences,
                          maxLength: 80,
                          decoration: InputDecoration(
                            labelText: '$kind name',
                            hintText: kind == 'Task'
                                ? 'e.g. Review chapter 3'
                                : kind == 'Subject'
                                ? 'e.g. Chemistry'
                                : 'e.g. Chemistry midterm',
                          ),
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                              ? 'Give it a name first.'
                              : null,
                        ),
                        if (kind != 'Subject') ...[
                          const SizedBox(height: 14),
                          DropdownButtonFormField<String>(
                            initialValue: subject ?? c.subjects.first,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: 'Subject',
                            ),
                            items: c.subjects
                                .map(
                                  (s) => DropdownMenuItem(
                                    value: s,
                                    child: Text(
                                      s,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) => subject = value,
                          ),
                          const SizedBox(height: 12),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.calendar_today_outlined),
                            title: Text(
                              '${date.day}/${date.month}/${date.year}',
                            ),
                            trailing: const Icon(Icons.edit_outlined),
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: date,
                                firstDate: DateUtils.dateOnly(DateTime.now()),
                                lastDate: DateTime.now().add(
                                  const Duration(days: 730),
                                ),
                              );
                              if (picked != null && mounted) {
                                setState(() => date = picked);
                              }
                            },
                          ),
                        ],
                        if (kind == 'Task') ...[
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('A little time: $minutes minutes'),
                          ),
                          Slider(
                            value: minutes.toDouble(),
                            min: 5,
                            max: 120,
                            divisions: 23,
                            label: '$minutes min',
                            onChanged: (value) =>
                                setState(() => minutes = value.round()),
                          ),
                        ],
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () {
                              if (!form.currentState!.validate()) return;
                              final chosen = subject ?? c.subjects.first;
                              if (kind == 'Subject') {
                                if (c.subjects.any(
                                  (s) =>
                                      s.toLowerCase() ==
                                      title.text.trim().toLowerCase(),
                                )) {
                                  Get.snackbar(
                                    'Already here',
                                    'Try another subject name.',
                                  );
                                  return;
                                }
                                c.subjects.add(title.text.trim());
                              } else if (kind == 'Task') {
                                c.tasks.add(
                                  PreviewTask(
                                    title.text.trim(),
                                    chosen,
                                    minutes,
                                    DesignTokens.mint,
                                    day: date
                                        .difference(
                                          DateUtils.dateOnly(DateTime.now()),
                                        )
                                        .inDays,
                                  ),
                                );
                                c.selectedDay.value = date
                                    .difference(
                                      DateUtils.dateOnly(DateTime.now()),
                                    )
                                    .inDays
                                    .clamp(0, 6);
                              } else {
                                c.exams.add(
                                  PreviewExam(title.text.trim(), chosen, date),
                                );
                              }
                              c.tab.value = kind == 'Exam' ? 0 : 1;
                              Navigator.pop(context);
                              Get.snackbar(
                                'A little plan, made.',
                                '$kind added to this preview.',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            },
                            child: Text('Add ${kind!.toLowerCase()}'),
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
    );
  }

  Widget _option(String name, String subtitle, IconData icon, Color color) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () => setState(() => kind = name),
          child: FlowCard(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: DesignTokens.charcoal),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(subtitle, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_rounded, size: 20),
              ],
            ),
          ),
        ),
      );
}
