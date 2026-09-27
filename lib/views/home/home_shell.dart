import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/theme/design_tokens.dart';
import '../../controllers/preview_controller.dart';
import '../../widgets/add_sheet.dart';
import '../focus/focus_page.dart';
import '../planner/planner_page.dart';
import '../profile/profile_page.dart';
import 'home_page.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({super.key});
  @override
  Widget build(BuildContext context) {
    final c = Get.find<PreviewController>();
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(
                        Icons.blur_on_rounded,
                        size: 17,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        'STUDYFLOW',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          letterSpacing: 2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: dark
                              ? const Color(0xFF303830)
                              : const Color(0xFFE8ECE0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'UI preview · sample data',
                          style: TextStyle(fontSize: 9),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Obx(
                    () => AnimatedSwitcher(
                      duration: MediaQuery.disableAnimationsOf(context)
                          ? Duration.zero
                          : DesignTokens.motion,
                      switchInCurve: Curves.easeOutCubic,
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween(
                            begin: const Offset(0, .035),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      ),
                      child: SingleChildScrollView(
                        key: ValueKey(c.tab.value),
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                        child: switch (c.tab.value) {
                          1 => const PlannerPage(),
                          3 => const FocusPage(),
                          4 => const ProfilePage(),
                          _ => const HomePage(),
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                  padding: const EdgeInsets.symmetric(
                    vertical: 7,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant
                          .withValues(alpha: .35),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .035),
                        blurRadius: 20,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Obx(
                    () => Row(
                      children: [
                        _item(context, c, 0, 'Home', Icons.grid_view_rounded),
                        _item(
                          context,
                          c,
                          1,
                          'Planner',
                          Icons.calendar_today_outlined,
                        ),
                        Expanded(
                          child: Center(
                            child: IconButton.filled(
                              style: IconButton.styleFrom(
                                backgroundColor: DesignTokens.lime,
                                foregroundColor: DesignTokens.charcoal,
                                minimumSize: const Size(50, 50),
                              ),
                              tooltip: 'Add',
                              onPressed: () => showAddSheet(context),
                              icon: const Icon(Icons.add),
                            ),
                          ),
                        ),
                        _item(context, c, 3, 'Focus', Icons.timelapse_rounded),
                        _item(
                          context,
                          c,
                          4,
                          'Profile',
                          Icons.person_outline_rounded,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _item(
    BuildContext context,
    PreviewController c,
    int index,
    String label,
    IconData icon,
  ) {
    final selected = c.tab.value == index;
    return Expanded(
      child: Semantics(
        selected: selected,
        button: true,
        label: label,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => c.tab.value = index,
          child: AnimatedContainer(
            duration: DesignTokens.motion,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: selected
                  ? Theme.of(context).colorScheme.surfaceContainerHigh
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 21),
                const SizedBox(height: 5),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
