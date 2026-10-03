import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/motion/app_motion.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/haptics.dart';
import '../../../../core/widgets/app_button.dart';
import 'road_progress_painter.dart';

class ReadinessJourneyHero extends StatefulWidget {
  const ReadinessJourneyHero({
    super.key,
    required this.readiness,
    required this.exploredTopics,
    required this.totalTopics,
    required this.onContinue,
  });
  final int readiness;
  final int exploredTopics;
  final int totalTopics;
  final VoidCallback onContinue;

  @override
  State<ReadinessJourneyHero> createState() => _ReadinessJourneyHeroState();
}

class _ReadinessJourneyHeroState extends State<ReadinessJourneyHero>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  double _from = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: AppMotion.hero);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.forward();
    });
  }

  @override
  void didUpdateWidget(covariant ReadinessJourneyHero oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.readiness != widget.readiness) {
      _from = oldWidget.readiness.toDouble();
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = reduceMotion
            ? 1.0
            : AppMotion.decelerate.transform(_controller.value);
        final value = (_from + (widget.readiness - _from) * t).round().clamp(
          0,
          100,
        );
        final reveal = reduceMotion
            ? 1.0
            : ((_controller.value - .18) / .55).clamp(0.0, 1.0);
        return Opacity(
          opacity: reduceMotion ? 1 : (.72 + .28 * _controller.value),
          child: Transform.translate(
            offset: Offset(0, reduceMotion ? 0 : 9 * (1 - _controller.value)),
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 25, 24, 22),
              decoration: BoxDecoration(
                color: AppColors.primaryDark,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'YOUR ROAD TO READY',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: const Color(0xFFB7C3B8),
                      fontSize: 11,
                      letterSpacing: 1.7,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 13),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '$value%',
                            style: Theme.of(context).textTheme.displayLarge
                                ?.copyWith(
                                  fontSize: 76,
                                  height: .98,
                                  letterSpacing: -4.5,
                                  color: AppColors.surface,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          widget.readiness >= 100
                              ? 'Ready for\nthe next step'
                              : widget.readiness >= 65
                              ? 'Almost\nthere'
                              : widget.readiness > 0
                              ? 'On your\nway'
                              : 'Start your\njourney',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: const Color(0xFFD0DACF),
                                height: 1.2,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  RepaintBoundary(
                    child: SizedBox(
                      height: 106,
                      width: double.infinity,
                      child: CustomPaint(
                        painter: RoadProgressPainter(progress: value / 100),
                      ),
                    ),
                  ),
                  const SizedBox(height: 9),
                  Opacity(
                    opacity: reveal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Every question moves you forward.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.surface,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Based on questions explored  ·  ${widget.exploredTopics} of ${widget.totalTopics} topics',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: const Color(0xFFADBBB0)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 21),
                  AppButton(
                    text: 'Continue learning  →',
                    onPressed: widget.onContinue,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class TodayRecommendationCard extends StatelessWidget {
  const TodayRecommendationCard({
    super.key,
    required this.title,
    required this.onTap,
  });
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _Pressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFE5EBE4),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'UP NEXT',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontSize: 11,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineLarge
                        ?.copyWith(height: 1.09, letterSpacing: -.5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Focused practice  ·  at your pace',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          'Start session',
                          maxLines: 2,
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.underline,
                              ),
                        ),
                      ),
                      const SizedBox(width: 7),
                      Icon(PhosphorIcons.arrowUpRight(), size: 17),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            const _IntersectionGraphic(),
          ],
        ),
      ),
    );
  }
}

class _IntersectionGraphic extends StatelessWidget {
  const _IntersectionGraphic();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 82,
      child: CustomPaint(painter: _IntersectionPainter()),
    );
  }
}

class _IntersectionPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final road = Paint()
      ..color = AppColors.primaryDark
      ..strokeWidth = 17
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * .5, 7),
      Offset(size.width * .5, size.height - 7),
      road,
    );
    canvas.drawLine(
      Offset(7, size.height * .52),
      Offset(size.width - 7, size.height * .52),
      road,
    );
    final lane = Paint()
      ..color = AppColors.primaryAccent
      ..strokeWidth = 2.2;
    canvas.drawLine(
      Offset(size.width * .5, 7),
      Offset(size.width * .5, 24),
      lane,
    );
    canvas.drawLine(
      Offset(size.width * .5, 62),
      Offset(size.width * .5, 75),
      lane,
    );
    canvas.drawCircle(
      Offset(size.width * .5, size.height * .52),
      5,
      Paint()..color = AppColors.primaryAccent,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class QuickActions extends StatelessWidget {
  const QuickActions({
    super.key,
    required this.mistakesCount,
    required this.onOpen,
  });
  final int mistakesCount;
  final Future<void> Function(String route, {Object? extra}) onOpen;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Pressable(
          onTap: () {
            AppHaptics.selection();
            onOpen('/practice');
          },
          child: Container(
            padding: const EdgeInsets.fromLTRB(19, 17, 19, 17),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(17),
            ),
            child: Row(
              children: [
                Icon(
                  PhosphorIcons.lightning(PhosphorIconsStyle.fill),
                  size: 28,
                  color: AppColors.secondaryAccent,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quick practice',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'A short run through the essentials',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(PhosphorIcons.arrowRight(), size: 19),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _QuickTile(
                title: 'Road signs',
                subtitle: 'Know the signs',
                icon: PhosphorIcons.trafficSign(PhosphorIconsStyle.fill),
                color: const Color(0xFFFFE7B4),
                onTap: () {
                  AppHaptics.selection();
                  onOpen('/signs');
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickTile(
                title: 'Mistakes',
                subtitle: '$mistakesCount to revisit',
                icon: PhosphorIcons.target(PhosphorIconsStyle.fill),
                color: const Color(0xFFFFE1DC),
                onTap: () {
                  AppHaptics.selection();
                  onOpen('/mistakes');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickTile extends StatelessWidget {
  const _QuickTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => _Pressable(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primaryDark, size: 29),
          const SizedBox(height: 20),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    ),
  );
}

class DailyGoalCard extends StatelessWidget {
  const DailyGoalCard({super.key, required this.progress});
  final int progress;
  @override
  Widget build(BuildContext context) {
    final done = progress.clamp(0, 10);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Daily goal',
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '$done / 10',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontFeatures: [const FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          LayoutBuilder(
            builder: (context, constraints) => TweenAnimationBuilder<double>(
              tween: Tween<double>(end: done / 10),
              duration: MediaQuery.disableAnimationsOf(context)
                  ? Duration.zero
                  : AppMotion.expressive,
              curve: AppMotion.standardEasing,
              builder: (context, value, _) => Stack(
                children: [
                  Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8EBE5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Container(
                    height: 12,
                    width: constraints.maxWidth * value,
                    decoration: BoxDecoration(
                      color: AppColors.primaryDark,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            done == 10
                ? 'Goal reached. Nice work today.'
                : '${10 - done} questions left today',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class JourneyPreview extends StatelessWidget {
  const JourneyPreview({
    super.key,
    required this.currentTopic,
    required this.currentProgress,
    required this.nextTopic,
    required this.onTap,
  });
  final String currentTopic;
  final double currentProgress;
  final String nextTopic;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => _Pressable(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE9E9E2),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Your journey',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              Icon(PhosphorIcons.arrowUpRight(), size: 21),
            ],
          ),
          const SizedBox(height: 12),
          RepaintBoundary(
            child: SizedBox(
              height: 68,
              width: double.infinity,
              child: CustomPaint(
                painter: RoadProgressPainter(
                  progress: currentProgress.clamp(0, 1),
                  compact: true,
                ),
              ),
            ),
          ),
          const SizedBox(height: 9),
          Text(
            currentTopic,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          Text(
            '${(currentProgress * 100).round()}% explored',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 13),
          Text(
            'NEXT  /  $nextTopic',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontSize: 11,
              letterSpacing: 1,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            'View journey →',
            style: Theme.of(context).textTheme.labelMedium
                ?.copyWith(decoration: TextDecoration.underline),
          ),
        ],
      ),
    ),
  );
}

class _Pressable extends StatefulWidget {
  const _Pressable({required this.child, required this.onTap});
  final Widget child;
  final VoidCallback onTap;
  @override
  State<_Pressable> createState() => _PressableState();
}

class _PressableState extends State<_Pressable> {
  bool pressed = false;
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => pressed = true),
      onTapCancel: () => setState(() => pressed = false),
      onTapUp: (_) => setState(() => pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: pressed ? .985 : 1,
        duration: AppMotion.quick,
        curve: AppMotion.standardEasing,
        child: widget.child,
      ),
    ),
  );
}
