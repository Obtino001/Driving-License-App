import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/motion/app_motion.dart';
import '../domain/scenario_models.dart';

class VisualScenarioWidget extends StatefulWidget {
  final VisualScenario scenario;
  final ScenarioState state;
  final double width;
  final double height;

  const VisualScenarioWidget({
    super.key,
    required this.scenario,
    this.state = ScenarioState.initial,
    this.width = double.infinity,
    this.height = 200,
  });

  @override
  State<VisualScenarioWidget> createState() => _VisualScenarioWidgetState();
}

class _VisualScenarioWidgetState extends State<VisualScenarioWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _progress = CurvedAnimation(
      parent: _controller,
      curve: AppMotion.standardEasing,
    );

    if (widget.state == ScenarioState.highlighted) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant VisualScenarioWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state != oldWidget.state) {
      if (widget.state == ScenarioState.highlighted) {
        _controller.forward(from: 0.0);
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: AnimatedBuilder(
        animation: _progress,
        builder: (context, child) {
          return CustomPaint(
            painter: _ScenarioPainter(
              scenario: widget.scenario,
              animationProgress: _progress.value,
            ),
          );
        },
      ),
    );
  }
}

class _ScenarioPainter extends CustomPaint {
  final VisualScenario scenario;
  final double animationProgress;

  _ScenarioPainter({required this.scenario, required this.animationProgress});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw Road Surface
    final roadPaint = Paint()..color = const Color(0xFF2C2C2E);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), roadPaint);

    // 2. Draw markings based on scenario type
    final markPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    if (scenario.type == ScenarioType.intersection) {
      // Draw intersection cross
      canvas.drawLine(
        Offset(0, size.height / 2),
        Offset(size.width, size.height / 2),
        markPaint,
      );
      canvas.drawLine(
        Offset(size.width / 2, 0),
        Offset(size.width / 2, size.height),
        markPaint,
      );
    } else {
      // Default straight road
      canvas.drawLine(
        Offset(0, size.height / 2),
        Offset(size.width, size.height / 2),
        markPaint,
      );
    }

    // 3. Draw Actors
    for (final actor in scenario.actors) {
      canvas.save();

      // Calculate position. If highlighted, maybe move or draw a path
      Offset currentPos = actor.position;
      if (actor.isHighlighted && animationProgress > 0) {
        // Simple animation: move slightly forward based on rotation
        final dx = 30 * animationProgress * (actor.rotation == 0 ? 1 : -1);
        currentPos = Offset(currentPos.dx + dx, currentPos.dy);
      }

      canvas.translate(currentPos.dx, currentPos.dy);
      canvas.rotate(actor.rotation);

      // Draw vehicle body
      final color = actor.isHighlighted && animationProgress > 0.5
          ? AppColors.primaryAccent
          : actor.color;

      final vPaint = Paint()..color = color;
      final rect = RRect.fromRectAndRadius(
        const Rect.fromLTWH(-15, -10, 30, 20),
        const Radius.circular(4),
      );
      canvas.drawRRect(rect, vPaint);

      // Draw windshield
      final glassPaint = Paint()..color = Colors.black.withValues(alpha: 0.5);
      canvas.drawRect(const Rect.fromLTWH(5, -8, 5, 16), glassPaint);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ScenarioPainter oldDelegate) {
    return oldDelegate.animationProgress != animationProgress ||
        oldDelegate.scenario != scenario;
  }
}
