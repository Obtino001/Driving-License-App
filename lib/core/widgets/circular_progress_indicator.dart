/// Custom circular progress ring with percentage label.
library;

import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A custom painted circular progress indicator with a centered percentage.
///
/// Used for category progress, overall stats, and the continue practice card.
class AppCircularProgress extends StatelessWidget {
  const AppCircularProgress({
    super.key,
    required this.progress,
    this.size = 64,
    this.strokeWidth = 6,
    this.activeColor,
    this.backgroundColor,
    this.showLabel = true,
    this.child,
  });

  /// Progress value from 0.0 to 1.0.
  final double progress;

  /// Diameter of the ring.
  final double size;

  /// Thickness of the ring stroke.
  final double strokeWidth;

  /// Color of the progress arc. Defaults to primary.
  final Color? activeColor;

  /// Color of the background ring. Defaults to surfaceVariant.
  final Color? backgroundColor;

  /// Whether to show the percentage label in the center.
  final bool showLabel;

  /// Optional child widget to show in the center instead of label.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final active = activeColor ?? theme.colorScheme.primary;
    final bg = backgroundColor ?? theme.colorScheme.surfaceContainerHighest;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _CircularProgressPainter(
              progress: progress.clamp(0.0, 1.0),
              activeColor: active,
              backgroundColor: bg,
              strokeWidth: strokeWidth,
            ),
          ),
          if (child != null)
            child!
          else if (showLabel)
            Text(
              '${(progress * 100).round()}%',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
        ],
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  _CircularProgressPainter({
    required this.progress,
    required this.activeColor,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  final double progress;
  final Color activeColor;
  final Color backgroundColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Background ring
    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = backgroundColor
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    if (progress > 0) {
      final activePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = activeColor
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        rect,
        -math.pi / 2, // Start from top
        2 * math.pi * progress,
        false,
        activePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.activeColor != activeColor;
  }
}
