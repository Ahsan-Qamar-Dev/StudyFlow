import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../app/theme/design_tokens.dart';
import '../controllers/preview_controller.dart';

class FlowCard extends StatelessWidget {
  const FlowCard({
    super.key,
    required this.child,
    this.color,
    this.padding = 22,
  });
  final Widget child;
  final Color? color;
  final double padding;
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(padding),
    decoration: BoxDecoration(
      color: color ?? Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(28),
    ),
    child: child,
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.action, this.onTap});
  final String title;
  final String? action;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.w600, letterSpacing: -.6),
        ),
      ),
      if (action != null) TextButton(onPressed: onTap, child: Text(action!)),
    ],
  );
}

class Tag extends StatelessWidget {
  const Tag(this.label, {super.key, this.color, this.icon});
  final String label;
  final Color? color;
  final IconData? icon;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    decoration: BoxDecoration(
      color: color ?? Theme.of(context).colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 14, color: DesignTokens.charcoal),
          const SizedBox(width: 5),
        ],
        Flexible(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: DesignTokens.charcoal,
            ),
          ),
        ),
      ],
    ),
  );
}

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, required this.onToggle});
  final PreviewTask task;
  final VoidCallback onToggle;
  @override
  Widget build(BuildContext context) => Semantics(
    checked: task.done,
    label: '${task.title}, ${task.minutes} minutes',
    child: Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: FlowCard(
        padding: 16,
        child: Row(
          children: [
            Container(
              width: 4,
              height: 44,
              decoration: BoxDecoration(
                color: task.color,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.subject.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 1.2,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  AnimatedDefaultTextStyle(
                    duration: DesignTokens.motion,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      decoration: task.done ? TextDecoration.lineThrough : null,
                      color: task.done
                          ? Theme.of(context).colorScheme.onSurfaceVariant
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                    child: Text(task.title),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${task.minutes} min · ${task.done ? "Nicely done" : "One step at a time"}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Checkbox(
              value: task.done,
              onChanged: (_) => onToggle(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    required this.progress,
    required this.child,
    this.size = 92,
    this.color = DesignTokens.lime,
    this.stroke = 7,
  });
  final double progress;
  final Widget child;
  final double size;
  final Color color;
  final double stroke;
  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    duration: MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 900),
    curve: Curves.easeOutCubic,
    tween: Tween(begin: 0, end: progress.clamp(0, 1)),
    builder: (_, value, child) => SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(value, color, stroke),
        child: Center(child: child),
      ),
    ),
    child: child,
  );
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.value, this.color, this.stroke);
  final double value;
  final Color color;
  final double stroke;
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      rect.deflate(stroke / 2),
      -math.pi / 2,
      math.pi * 2,
      false,
      paint..color = color.withValues(alpha: .17),
    );
    canvas.drawArc(
      rect.deflate(stroke / 2),
      -math.pi / 2,
      math.pi * 2 * value,
      false,
      paint..color = color,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.value != value || old.color != color || old.stroke != stroke;
}

class WeeklyChart extends StatelessWidget {
  const WeeklyChart({super.key, this.dark = false});
  final bool dark;
  @override
  Widget build(BuildContext context) {
    const values = [.36, .66, .48, .88, .57, .24, .14];
    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Semantics(
      label: 'Sample week: 40, 75, 55, 100, 65, 25, and 15 minutes.',
      child: SizedBox(
        height: 128,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(
            7,
            (index) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: values[index]),
                      duration: MediaQuery.disableAnimationsOf(context)
                          ? Duration.zero
                          : Duration(milliseconds: 550 + index * 70),
                      curve: Curves.easeOutCubic,
                      builder: (_, value, _) => Container(
                        height: 94 * value + 5,
                        decoration: BoxDecoration(
                          color: index == 3
                              ? DesignTokens.lime
                              : (dark
                                    ? Colors.white.withValues(alpha: .14)
                                    : DesignTokens.mint),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      labels[index],
                      style: TextStyle(
                        fontSize: 11,
                        color: dark
                            ? Colors.white70
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
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

class EmptyMessage extends StatelessWidget {
  const EmptyMessage({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.wb_sunny_outlined,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  @override
  Widget build(BuildContext context) => FlowCard(
    child: Column(
      children: [
        Icon(icon, size: 34),
        const SizedBox(height: 12),
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 7),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    ),
  );
}

class PageIntro extends StatelessWidget {
  const PageIntro(this.eyebrow, this.title, {super.key, this.trailing});
  final String eyebrow;
  final String title;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 26),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eyebrow.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall
                    ?.copyWith(letterSpacing: 1.8),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  letterSpacing: -1.3,
                ),
              ),
            ],
          ),
        ),
        ?trailing,
      ],
    ),
  );
}
