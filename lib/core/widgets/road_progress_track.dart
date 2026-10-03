import 'package:flutter/material.dart';

import '../motion/app_motion.dart';
import '../theme/app_colors.dart';

/// Straight lane motif for compact progress; the Home hero uses a curved route.
class RoadProgressTrack extends StatelessWidget {
  const RoadProgressTrack({
    super.key,
    required this.progress,
    this.height = 18,
    this.activeColor = AppColors.primaryAccent,
  });

  final double progress;
  final double height;
  final Color activeColor;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween<double>(end: progress.clamp(0, 1)),
    duration: MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : AppMotion.expressive,
    curve: AppMotion.standardEasing,
    builder: (context, value, _) => RepaintBoundary(
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: CustomPaint(painter: _LanePainter(value, activeColor)),
      ),
    ),
  );
}

class _LanePainter extends CustomPainter {
  const _LanePainter(this.progress, this.activeColor);
  final double progress;
  final Color activeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height / 2;
    final left = 7.0;
    final right = size.width - 7;
    final x = left + (right - left) * progress;
    final track = Paint()
      ..color = const Color(0xFFCDD5CC)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(left, y), Offset(right, y), track);
    if (progress > 0) {
      canvas.drawLine(
        Offset(left, y),
        Offset(x, y),
        Paint()
          ..color = activeColor
          ..strokeWidth = 5
          ..strokeCap = StrokeCap.round,
      );
    }
    final lane = Paint()
      ..color = AppColors.primaryDark.withValues(alpha: .38)
      ..strokeWidth = 1;
    for (double start = 18; start < size.width - 10; start += 22) {
      canvas.drawLine(Offset(start, y), Offset(start + 8, y), lane);
    }
    canvas.drawCircle(Offset(x, y), 8, Paint()..color = AppColors.primaryDark);
    canvas.drawCircle(Offset(x, y), 3, Paint()..color = activeColor);
  }

  @override
  bool shouldRepaint(covariant _LanePainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.activeColor != activeColor;
}
