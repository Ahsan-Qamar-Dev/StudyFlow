import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../app/theme/design_tokens.dart';
import '../../controllers/preview_controller.dart';
import '../../widgets/study_components.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool personalize = false;
  final name = TextEditingController();
  String level = 'University';
  double goal = 120;
  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: DesignTokens.lime,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.blur_on_rounded,
                          color: DesignTokens.charcoal,
                        ),
                      ),
                      const SizedBox(width: 11),
                      Text(
                        'StudyFlow',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const Tag('UI PREVIEW', color: DesignTokens.mint),
                    ],
                  ),
                  const SizedBox(height: 32),
                  AnimatedSwitcher(
                    duration: MediaQuery.disableAnimationsOf(context)
                        ? Duration.zero
                        : DesignTokens.motion,
                    child: personalize
                        ? _personalize(context)
                        : _intro(context),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: DesignTokens.charcoal,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        if (!personalize) {
                          setState(() => personalize = true);
                          return;
                        }
                        final c = Get.find<PreviewController>();
                        c.name.value = name.text.trim().isEmpty
                            ? 'Alex'
                            : name.text.trim();
                        c.education.value = level;
                        c.goal.value = goal.round();
                        Get.offAllNamed(AppRoutes.home);
                      },
                      iconAlignment: IconAlignment.end,
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: Text(
                        personalize
                            ? 'Make yourself at home'
                            : 'Find your own flow',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(
                      onPressed: () => Get.offAllNamed(AppRoutes.home),
                      child: const Text('Explore the preview'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'A little less pressure. A little more possibility.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _intro(BuildContext context) => Column(
    key: const ValueKey('intro'),
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        height: 265 * MediaQuery.textScalerOf(context).scale(1),
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(child: CustomPaint(painter: _OrbitPainter())),
            Transform.rotate(
              angle: -.12,
              child: Container(
                width: 195,
                height: 225 * MediaQuery.textScalerOf(context).scale(1),
                padding: const EdgeInsets.all(23),
                decoration: BoxDecoration(
                  color: DesignTokens.charcoal,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ONE LITTLE\nSTEP AT A TIME.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        letterSpacing: 1.5,
                        height: 1.7,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.spa_outlined,
                      color: DesignTokens.lime,
                      size: 68,
                    ),
                    Spacer(),
                    Text(
                      'Keep going.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        letterSpacing: -.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 1,
              top: 34,
              child: Transform.rotate(
                angle: .10,
                child: const Tag('Room to grow ↗', color: DesignTokens.lime),
              ),
            ),
            Positioned(
              left: 0,
              bottom: 25,
              child: Transform.rotate(
                angle: -.05,
                child: const Tag(
                  'Your pace. Your progress.',
                  color: DesignTokens.lavender,
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 30),
      Text(
        'Big dreams.\nSmall daily steps.',
        style: Theme.of(context).textTheme.displaySmall?.copyWith(
          fontWeight: FontWeight.w500,
          letterSpacing: -1.6,
          height: 1.08,
        ),
      ),
      const SizedBox(height: 17),
      Text(
        'A calmer place to plan your studies,\nfind your focus, and watch yourself grow.',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
      ),
    ],
  );
  Widget _personalize(BuildContext context) => Column(
    key: const ValueKey('personalize'),
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Icon(Icons.waving_hand_outlined, size: 44),
      const SizedBox(height: 22),
      Text(
        'Let us make\nthis your space.',
        style: Theme.of(context).textTheme.displaySmall?.copyWith(
          fontWeight: FontWeight.w500,
          letterSpacing: -1.6,
          height: 1.1,
        ),
      ),
      const SizedBox(height: 14),
      const Text('Just a few little things. You can change them anytime.'),
      const SizedBox(height: 26),
      TextField(
        controller: name,
        maxLength: 30,
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(
          labelText: 'What should we call you?',
          hintText: 'Your first name',
        ),
      ),
      const SizedBox(height: 16),
      const Text(
        'Where are you learning?',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 10),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: ['School', 'College', 'University', 'Other']
            .map(
              (value) => ChoiceChip(
                label: Text(value),
                selected: level == value,
                onSelected: (_) => setState(() => level = value),
              ),
            )
            .toList(),
      ),
      const SizedBox(height: 24),
      FlowCard(
        color: DesignTokens.mint,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your daily intention',
              style: TextStyle(
                color: DesignTokens.charcoal,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${goal.round()} minutes',
              style: const TextStyle(
                color: DesignTokens.charcoal,
                fontSize: 28,
              ),
            ),
            Slider(
              value: goal,
              min: 30,
              max: 240,
              divisions: 7,
              activeColor: DesignTokens.charcoal,
              onChanged: (value) => setState(() => goal = value),
            ),
            const Text(
              'Start small. You can always do a little more.',
              style: TextStyle(color: DesignTokens.charcoal, fontSize: 12),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      const Text(
        'Preview only: these details are kept for this session.',
        style: TextStyle(fontSize: 11),
      ),
    ],
  );
}

class _OrbitPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = DesignTokens.mint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(-.4);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset.zero,
        width: size.width * .95,
        height: 190,
      ),
      paint,
    );
    canvas.rotate(.8);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset.zero,
        width: size.width * .95,
        height: 190,
      ),
      paint,
    );
    canvas.restore();
    final dot = Paint()..color = DesignTokens.lime;
    canvas.drawCircle(Offset(size.width * .15, 30), 8, dot);
    canvas.drawCircle(
      Offset(size.width * .91, size.height * .74),
      12,
      dot..color = DesignTokens.lavender,
    );
    final center = Offset(size.width * .09, size.height * .50);
    for (var i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      canvas.drawLine(
        center + Offset(math.cos(angle), math.sin(angle)) * 5,
        center + Offset(math.cos(angle), math.sin(angle)) * 13,
        Paint()
          ..color = DesignTokens.charcoal
          ..strokeWidth = 1.5,
      );
    }
  }

  @override
  bool shouldRepaint(_OrbitPainter oldDelegate) => false;
}
