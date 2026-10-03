import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/haptics.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/editorial_header.dart';
import '../../../core/widgets/road_progress_track.dart';
import '../application/learn_controller.dart';
import 'module_motif.dart';

class LearnScreen extends ConsumerWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(learnProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) =>
              Center(child: Text('Could not load journey: $error')),
          data: (state) {
            final modules = state.modules;
            final currentIndex = modules.indexWhere(
              (m) => !m.isCompleted && m.totalQuestions > 0,
            );
            final activeIndex = currentIndex < 0 ? 0 : currentIndex;
            final explored = modules
                .where((m) => m.completedQuestions > 0)
                .length;
            return RefreshIndicator(
              onRefresh: () => ref.read(learnProvider.notifier).loadModules(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 13, 20, 40),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => context.pop(),
                      tooltip: 'Back',
                      icon: Icon(PhosphorIcons.arrowLeft()),
                    ),
                  ),
                  const SizedBox(height: 18),
                  EditorialHeader(
                    eyebrow: 'LEARNING JOURNEY',
                    title: 'Road ready,\none skill at a time.',
                    subtitle:
                        '${modules.length} topics to build your confidence. Explore them in any order.',
                  ),
                  const SizedBox(height: 26),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primaryDark,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'YOUR ROUTE SO FAR',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                fontSize: 11,
                                letterSpacing: 1.4,
                                color: const Color(0xFFBEC9BE),
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '$explored / ${modules.length} topics explored',
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(color: AppColors.surface),
                        ),
                        const SizedBox(height: 14),
                        RoadProgressTrack(
                          progress: modules.isEmpty
                              ? 0
                              : explored / modules.length,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  ...List.generate(modules.length, (index) {
                    final module = modules[index];
                    return ModuleJourneyNode(
                      module: module,
                      index: index,
                      isLast: index == modules.length - 1,
                      isCurrent: index == activeIndex,
                      onTap: () {
                        AppHaptics.selection();
                        _showModule(context, ref, module);
                      },
                    );
                  }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _showModule(
    BuildContext context,
    WidgetRef ref,
    LearnModule module,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: AppColors.backgroundLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetContext) => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            12,
            24,
            24 + MediaQuery.paddingOf(sheetContext).bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC5CEC3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Text(
                'TOPIC  /  ${module.category.toUpperCase()}',
                style: Theme.of(sheetContext).textTheme.labelMedium?.copyWith(
                  fontSize: 11,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      module.title,
                      style: Theme.of(sheetContext).textTheme.displayLarge
                          ?.copyWith(
                            fontSize: 38,
                            height: 1.05,
                            letterSpacing: -1.2,
                          ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ModuleMotif(category: module.category, size: 52),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                _description(module.category),
                style: Theme.of(sheetContext).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              RoadProgressTrack(progress: module.progress),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _SheetMetric(
                      label: 'PRACTICED',
                      value:
                          '${module.completedQuestions} / ${module.totalQuestions}',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SheetMetric(
                      label: 'ACCURACY',
                      value: module.accuracy == null
                          ? '—'
                          : '${(module.accuracy! * 100).round()}%',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              AppButton(
                text: module.completedQuestions > 0
                    ? 'Continue practice  →'
                    : 'Start practice  →',
                onPressed: () {
                  Navigator.pop(sheetContext);
                  context.push('/practice', extra: module.category).then((_) {
                    if (context.mounted) {
                      ref.read(learnProvider.notifier).loadModules();
                    }
                  });
                },
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(sheetContext),
                child: const Text('Back to journey'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _description(String category) => switch (category) {
  'Road Rules' => 'Build the everyday decisions that make every drive safer.',
  'Traffic Signs' => 'Read sign shapes and instructions at a glance.',
  'Right of Way' => 'Know when to proceed and when to yield.',
  'Speed & Distance' =>
    'Choose a pace and following distance that leave room to react.',
  'Intersections' =>
    'Navigate crossings, turns, and roundabouts with confidence.',
  'Lane Control' => 'Find the right position before your next move.',
  'Parking' => 'Learn curb rules and position your vehicle safely.',
  'Sharing the Road' =>
    'Make space for people, bicycles, trucks, and emergency vehicles.',
  'Safe Driving' => 'Turn sound judgment into a steady driving habit.',
  _ => 'Prepare for unexpected situations with a clear plan.',
};

class _SheetMetric extends StatelessWidget {
  const _SheetMetric({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontSize: 10,
            letterSpacing: 1.3,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 7),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(value, style: Theme.of(context).textTheme.headlineLarge),
        ),
      ],
    ),
  );
}

class ModuleJourneyNode extends StatelessWidget {
  const ModuleJourneyNode({
    super.key,
    required this.module,
    required this.index,
    required this.isLast,
    required this.isCurrent,
    required this.onTap,
  });
  final LearnModule module;
  final int index;
  final bool isLast;
  final bool isCurrent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final complete = module.isCompleted;
    final surface = isCurrent
        ? const Color(0xFFE5EBE4)
        : complete
        ? AppColors.surface
        : const Color(0xFFECEEE9);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 58,
            child: RepaintBoundary(
              child: CustomPaint(
                painter: LearningRoutePainter(
                  completed: complete,
                  current: isCurrent,
                  first: index == 0,
                  last: isLast,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(index.isOdd ? 8 : 0, 8, 0, 8),
              child: Material(
                color: surface,
                borderRadius: BorderRadius.circular(17),
                child: InkWell(
                  borderRadius: BorderRadius.circular(17),
                  onTap: onTap,
                  child: Padding(
                    padding: const EdgeInsets.all(17),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                complete
                                    ? 'EXPLORED'
                                    : isCurrent
                                    ? 'CURRENT STRETCH'
                                    : 'UP AHEAD',
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(
                                      fontSize: 10,
                                      letterSpacing: 1.2,
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ),
                            Text(
                              '${(module.progress * 100).round()}%',
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                module.title,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      height: 1.16,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ModuleMotif(category: module.category, size: 38),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${module.completedQuestions} of ${module.totalQuestions} questions explored',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        if (isCurrent) ...[
                          const SizedBox(height: 13),
                          RoadProgressTrack(
                            progress: module.progress,
                            height: 14,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LearningRoutePainter extends CustomPainter {
  const LearningRoutePainter({
    required this.completed,
    required this.current,
    required this.first,
    required this.last,
  });
  final bool completed;
  final bool current;
  final bool first;
  final bool last;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final path = Path()
      ..moveTo(center.dx, first ? center.dy : 0)
      ..lineTo(center.dx, last ? center.dy : size.height);
    canvas.drawPath(
      path,
      Paint()
        ..color = completed ? AppColors.primaryDark : const Color(0xFFC9D1C7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
    if (current) {
      canvas.drawLine(
        Offset(center.dx, 0),
        center,
        Paint()
          ..color = AppColors.primaryAccent
          ..strokeWidth = 4,
      );
    }
    canvas.drawCircle(
      center,
      15,
      Paint()
        ..color = current
            ? AppColors.primaryAccent
            : completed
            ? AppColors.primaryDark
            : AppColors.surface,
    );
    canvas.drawCircle(
      center,
      10,
      Paint()
        ..color = current
            ? AppColors.primaryDark
            : completed
            ? AppColors.primaryAccent
            : const Color(0xFFC9D1C7),
    );
    if (completed) {
      final check = Path()
        ..moveTo(center.dx - 4, center.dy)
        ..lineTo(center.dx - 1, center.dy + 3)
        ..lineTo(center.dx + 5, center.dy - 4);
      canvas.drawPath(
        check,
        Paint()
          ..color = AppColors.primaryDark
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant LearningRoutePainter old) =>
      old.completed != completed ||
      old.current != current ||
      old.first != first ||
      old.last != last;
}
