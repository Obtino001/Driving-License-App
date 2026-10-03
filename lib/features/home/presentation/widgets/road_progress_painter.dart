import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// A route that scales to the available width. Progress and marker share one metric.
class RoadProgressPainter extends CustomPainter {
  const RoadProgressPainter({required this.progress, this.compact = false});
  final double progress;
  final bool compact;

  @override
  void paint(Canvas canvas, Size size) {
    final route = Path()
      ..moveTo(12, size.height * .76)
      ..cubicTo(
        size.width * .31,
        size.height * .76,
        size.width * .17,
        size.height * .2,
        size.width * .51,
        size.height * .31,
      )
      ..cubicTo(
        size.width * .78,
        size.height * .42,
        size.width * .73,
        size.height * .79,
        size.width - 12,
        size.height * .19,
      );
    final metric = route.computeMetrics().first;
    final distance = metric.length * progress.clamp(0.0, 1.0);
    final track = Paint()
      ..color = compact ? const Color(0xFFD9DED7) : const Color(0xFF405149)
      ..strokeWidth = compact ? 9 : 18
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawPath(route, track);

    final traveled = metric.extractPath(0, distance);
    canvas.drawPath(
      traveled,
      Paint()
        ..color = AppColors.primaryAccent
        ..strokeWidth = compact ? 9 : 18
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );
    if (!compact) {
      final lane = Paint()
        ..color = const Color(0xFFB1BDB3)
        ..strokeWidth = 1.4
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      for (double start = 4; start < metric.length; start += 16) {
        canvas.drawPath(
          metric.extractPath(start, math.min(start + 6, metric.length)),
          lane,
        );
      }
    }
    final tangent = metric.getTangentForOffset(
      distance.clamp(0.0, metric.length),
    );
    if (tangent == null) return;
    final p = tangent.position;
    canvas.drawCircle(
      p,
      compact ? 8 : 13,
      Paint()..color = compact ? AppColors.primaryDark : AppColors.surface,
    );
    canvas.drawCircle(
      p,
      compact ? 4 : 7,
      Paint()..color = AppColors.primaryDark,
    );
  }

  @override
  bool shouldRepaint(covariant RoadProgressPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.compact != compact;
}
