import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/motion/app_motion.dart';
import '../domain/scenario_models.dart';

class VisualScenarioWidget extends StatefulWidget {
  final ScenarioType type;
  final ScenarioState state;
  final double width;
  final double height;
  final bool animate;

  const VisualScenarioWidget({
    super.key,
    required this.type,
    this.state = ScenarioState.initial,
    this.width = double.infinity,
    this.height = 220,
    this.animate = false,
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
      duration: const Duration(milliseconds: 1500),
    );
    _progress = CurvedAnimation(
      parent: _controller,
      curve: AppMotion.standardEasing,
    );

    if (widget.state == ScenarioState.highlighted && widget.animate) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant VisualScenarioWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state != oldWidget.state) {
      if (widget.state == ScenarioState.highlighted && widget.animate) {
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
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: AnimatedBuilder(
        animation: _progress,
        builder: (context, child) {
          return CustomPaint(
            painter: _ScenarioPainter(
              type: widget.type,
              animationProgress: _progress.value,
              isHighlighted: widget.state == ScenarioState.highlighted,
              reduceMotion: MediaQuery.disableAnimationsOf(context),
            ),
          );
        },
      ),
    );
  }
}

class _ScenarioPainter extends CustomPainter {
  final ScenarioType type;
  final double animationProgress;
  final bool isHighlighted;
  final bool reduceMotion;

  _ScenarioPainter({
    required this.type,
    required this.animationProgress,
    required this.isHighlighted,
    required this.reduceMotion,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw Ground
    final groundPaint = Paint()
      ..color = const Color(0xFF869C80); // Subtle grass/ground
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), groundPaint);

    // 2. Draw Road
    final roadPaint = Paint()
      ..color = const Color(0xFF45474D); // Premium asphalt
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final yellowLinePaint = Paint()
      ..color = const Color(0xFFFFD54F).withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    double p = reduceMotion ? (isHighlighted ? 1.0 : 0.0) : animationProgress;
    if (!isHighlighted) p = 0;

    switch (type) {
      case ScenarioType.fourWayIntersection:
      case ScenarioType.stopSignPriority:
      case ScenarioType.leftTurnConflict:
        _drawIntersection(canvas, size, roadPaint, linePaint, yellowLinePaint);
        _drawActorsIntersection(canvas, size, p);
        break;
      case ScenarioType.pedestrianCrossing:
        _drawStraightRoad(canvas, size, roadPaint, linePaint, yellowLinePaint);
        _drawPedestrianCrossing(canvas, size, p);
        break;
      case ScenarioType.bicycleLane:
        _drawStraightRoad(
          canvas,
          size,
          roadPaint,
          linePaint,
          yellowLinePaint,
          withBikeLane: true,
        );
        _drawBicycleLaneScenario(canvas, size, p);
        break;
      case ScenarioType.highwayMerge:
        _drawHighwayMerge(canvas, size, roadPaint, linePaint);
        _drawHighwayMergeActors(canvas, size, p);
        break;
      case ScenarioType.laneChange:
        _drawStraightRoad(
          canvas,
          size,
          roadPaint,
          linePaint,
          linePaint,
          multiLane: true,
        );
        _drawLaneChange(canvas, size, p);
        break;
      case ScenarioType.parallelParking:
        _drawStraightRoad(
          canvas,
          size,
          roadPaint,
          linePaint,
          yellowLinePaint,
          withParking: true,
        );
        _drawParallelParking(canvas, size, p);
        break;
      case ScenarioType.hillParking:
        _drawHillRoad(canvas, size, roadPaint, linePaint, yellowLinePaint);
        _drawHillParking(canvas, size, p);
        break;
      case ScenarioType.emergencyVehicle:
        _drawStraightRoad(
          canvas,
          size,
          roadPaint,
          linePaint,
          yellowLinePaint,
          multiLane: true,
        );
        _drawEmergencyVehicle(canvas, size, p);
        break;
    }
  }

  void _drawIntersection(
    Canvas canvas,
    Size size,
    Paint road,
    Paint whiteLine,
    Paint yellowLine,
  ) {
    double hw = size.width / 2;
    double hh = size.height / 2;
    double rw = 60; // road half-width

    // Roads
    canvas.drawRect(Rect.fromLTWH(0, hh - rw, size.width, rw * 2), road);
    canvas.drawRect(Rect.fromLTWH(hw - rw, 0, rw * 2, size.height), road);

    // Lines (horizontal)
    canvas.drawLine(Offset(0, hh), Offset(hw - rw, hh), yellowLine);
    canvas.drawLine(Offset(hw + rw, hh), Offset(size.width, hh), yellowLine);

    // Lines (vertical)
    canvas.drawLine(Offset(hw, 0), Offset(hw, hh - rw), yellowLine);
    canvas.drawLine(Offset(hw, hh + rw), Offset(hw, size.height), yellowLine);

    // Stop lines
    if (type == ScenarioType.fourWayIntersection ||
        type == ScenarioType.stopSignPriority) {
      canvas.drawLine(
        Offset(hw - rw, hh),
        Offset(hw - rw, hh + rw),
        whiteLine..strokeWidth = 4,
      ); // bottom
      canvas.drawLine(
        Offset(hw + rw, hh),
        Offset(hw + rw, hh - rw),
        whiteLine,
      ); // top
      canvas.drawLine(
        Offset(hw - rw, hh - rw),
        Offset(hw, hh - rw),
        whiteLine,
      ); // left
      canvas.drawLine(
        Offset(hw + rw, hh + rw),
        Offset(hw, hh + rw),
        whiteLine,
      ); // right
    }
    whiteLine.strokeWidth = 2; // reset
  }

  void _drawStraightRoad(
    Canvas canvas,
    Size size,
    Paint road,
    Paint white,
    Paint centerLine, {
    bool multiLane = false,
    bool withBikeLane = false,
    bool withParking = false,
  }) {
    canvas.drawRect(Rect.fromLTWH(0, 20, size.width, size.height - 40), road);
    double mid = size.height / 2;

    if (multiLane) {
      _drawDashedLine(canvas, Offset(0, mid), Offset(size.width, mid), white);
    } else {
      canvas.drawLine(Offset(0, mid), Offset(size.width, mid), centerLine);
    }

    if (withBikeLane) {
      canvas.drawLine(
        Offset(0, size.height - 40),
        Offset(size.width, size.height - 40),
        white,
      );
      // bike icon mock
      canvas.drawCircle(Offset(size.width - 40, size.height - 30), 3, white);
      canvas.drawCircle(Offset(size.width - 30, size.height - 30), 3, white);
    }
    if (withParking) {
      canvas.drawLine(
        Offset(0, size.height - 50),
        Offset(size.width, size.height - 50),
        white,
      );
      for (int i = 0; i < 3; i++) {
        canvas.drawLine(
          Offset(60.0 + i * 100, size.height - 50),
          Offset(60.0 + i * 100, size.height - 20),
          white,
        );
      }
    }
  }

  void _drawHighwayMerge(Canvas canvas, Size size, Paint road, Paint white) {
    canvas.drawRect(Rect.fromLTWH(0, 20, size.width, size.height - 40), road);
    _drawDashedLine(
      canvas,
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      white,
    );

    // Merge lane coming from bottom right
    Path mergePath = Path()
      ..moveTo(size.width, size.height)
      ..lineTo(size.width - 120, size.height - 20)
      ..lineTo(size.width, size.height - 20)
      ..close();
    canvas.drawPath(mergePath, road);
    canvas.drawLine(
      Offset(size.width - 120, size.height - 20),
      Offset(size.width, size.height),
      white,
    );
  }

  void _drawHillRoad(
    Canvas canvas,
    Size size,
    Paint road,
    Paint white,
    Paint yellow,
  ) {
    canvas.save();
    canvas.translate(0, 40);
    canvas.rotate(-0.15); // incline
    canvas.drawRect(Rect.fromLTWH(-50, 0, size.width + 100, 100), road);
    canvas.drawLine(Offset(-50, 50), Offset(size.width + 100, 50), yellow);
    // Curb
    final curb = Paint()..color = Colors.grey.shade400;
    canvas.drawRect(Rect.fromLTWH(-50, 100, size.width + 100, 10), curb);
    canvas.restore();
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    double total = (end.dx - start.dx).abs();
    double dash = 15;
    double gap = 15;
    double current = 0;
    while (current < total) {
      canvas.drawLine(
        Offset(start.dx + current, start.dy),
        Offset(start.dx + current + dash, end.dy),
        paint,
      );
      current += dash + gap;
    }
  }

  // --- ACTOR DRAWING ---

  void _drawCar(Canvas canvas, Offset pos, double angle, Color color) {
    canvas.save();
    canvas.translate(pos.dx, pos.dy);
    canvas.rotate(angle);

    final body = Paint()..color = color;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-18, -10, 36, 20),
        const Radius.circular(5),
      ),
      body,
    );

    final glass = Paint()..color = Colors.black.withValues(alpha: 0.6);
    canvas.drawRect(const Rect.fromLTWH(0, -8, 8, 16), glass); // Windshield
    canvas.drawRect(const Rect.fromLTWH(-12, -8, 6, 16), glass); // Rear window

    canvas.restore();
  }

  void _drawBike(Canvas canvas, Offset pos) {
    canvas.save();
    canvas.translate(pos.dx, pos.dy);
    final p = Paint()
      ..color = AppColors.primaryAccent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawLine(const Offset(-10, 0), const Offset(10, 0), p);
    canvas.drawCircle(const Offset(-6, 0), 4, p);
    canvas.drawCircle(const Offset(6, 0), 4, p);
    canvas.restore();
  }

  void _drawPedestrian(Canvas canvas, Offset pos) {
    final p = Paint()..color = Colors.white;
    canvas.drawCircle(pos, 4, p);
    canvas.drawRect(
      Rect.fromCenter(center: Offset(pos.dx, pos.dy + 6), width: 6, height: 8),
      p,
    );
  }

  void _drawPathLine(Canvas canvas, Offset start, Offset end, double progress) {
    if (progress <= 0) return;
    final p = Paint()
      ..color = AppColors.primaryAccent.withValues(alpha: 0.8)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    Offset current = Offset(
      start.dx + (end.dx - start.dx) * progress,
      start.dy + (end.dy - start.dy) * progress,
    );
    canvas.drawLine(start, current, p);
  }

  // --- SCENARIO SPECIFIC ACTORS ---

  void _drawActorsIntersection(Canvas canvas, Size size, double p) {
    double hw = size.width / 2;
    double hh = size.height / 2;

    if (type == ScenarioType.fourWayIntersection) {
      // Car 1 (bottom going up) - arrives first
      _drawCar(
        canvas,
        Offset(hw + 30, hh + 100 - (p * 50)),
        -math.pi / 2,
        isHighlighted ? AppColors.primaryAccent : Colors.white,
      );
      // Car 2 (left going right) - yields
      _drawCar(canvas, Offset(hw - 100, hh + 30), 0, Colors.red.shade400);

      if (isHighlighted) {
        _drawPathLine(
          canvas,
          Offset(hw + 30, hh + 100),
          Offset(hw + 30, hh - 100),
          p,
        );
      }
    } else if (type == ScenarioType.stopSignPriority) {
      _drawCar(
        canvas,
        Offset(hw + 30, hh + 100),
        -math.pi / 2,
        Colors.white,
      ); // Bottom waiting
      _drawCar(
        canvas,
        Offset(hw - 100 + (p * 150), hh - 30),
        0,
        AppColors.primaryAccent,
      ); // Left crossing
      if (isHighlighted)
        _drawPathLine(
          canvas,
          Offset(hw - 100, hh - 30),
          Offset(hw + 100, hh - 30),
          p,
        );
    } else if (type == ScenarioType.leftTurnConflict) {
      // Car 1 turning left
      double x = hw + 30;
      double y = hh + 100;
      if (p > 0) {
        x -= p * 50; // curve left
        y -= p * 80;
      }
      _drawCar(
        canvas,
        Offset(x, y),
        -math.pi / 2 - (p * math.pi / 4),
        Colors.white,
      );

      // Oncoming car
      _drawCar(
        canvas,
        Offset(hw - 30, hh - 100 + (p * 150)),
        math.pi / 2,
        AppColors.primaryAccent,
      );

      if (isHighlighted) {
        _drawPathLine(
          canvas,
          Offset(hw - 30, hh - 100),
          Offset(hw - 30, hh + 100),
          p,
        );
      }
    }
  }

  void _drawPedestrianCrossing(Canvas canvas, Size size, double p) {
    // Crosswalk
    final cw = Paint()..color = Colors.white;
    for (int i = 0; i < 5; i++) {
      canvas.drawRect(
        Rect.fromLTWH(size.width / 2 + 20, 30.0 + i * 30, 20, 15),
        cw,
      );
    }

    // Car yielding
    _drawCar(
      canvas,
      Offset(size.width / 2 - 50, size.height / 2 + 30),
      0,
      Colors.white,
    );

    // Pedestrian walking
    _drawPedestrian(canvas, Offset(size.width / 2 + 30, 30 + (p * 100)));

    if (isHighlighted)
      _drawPathLine(
        canvas,
        Offset(size.width / 2 + 30, 30),
        Offset(size.width / 2 + 30, 160),
        p,
      );
  }

  void _drawBicycleLaneScenario(Canvas canvas, Size size, double p) {
    _drawBike(canvas, Offset(80 + (p * 80), size.height - 25));

    // Car passing safely
    _drawCar(
      canvas,
      Offset(60 + (p * 100), size.height / 2 + 20),
      0,
      Colors.white,
    );

    if (isHighlighted) {
      _drawPathLine(
        canvas,
        Offset(60, size.height / 2 + 20),
        Offset(180, size.height / 2 + 20),
        p,
      );
    }
  }

  void _drawHighwayMergeActors(Canvas canvas, Size size, double p) {
    _drawCar(
      canvas,
      Offset(100 + (p * 100), size.height / 2 + 20),
      0,
      Colors.white,
    );

    // Merging car
    double mx = size.width - 80 - (p * 80);
    double my = size.height - 10 - (p * 30);
    _drawCar(canvas, Offset(mx, my), -0.2, AppColors.primaryAccent);

    if (isHighlighted) {
      _drawPathLine(
        canvas,
        Offset(size.width - 80, size.height - 10),
        Offset(size.width - 160, size.height / 2 + 20),
        p,
      );
    }
  }

  void _drawLaneChange(Canvas canvas, Size size, double p) {
    _drawCar(
      canvas,
      Offset(100 + (p * 60), size.height / 2 + 30 - (p * 50)),
      -p * 0.3,
      AppColors.primaryAccent,
    );

    if (isHighlighted) {
      _drawPathLine(
        canvas,
        Offset(100, size.height / 2 + 30),
        Offset(160, size.height / 2 - 20),
        p,
      );

      // highlight blind spot check
      final hp = Paint()..color = AppColors.warning.withValues(alpha: 0.5 * p);
      canvas.drawCircle(
        Offset(80 + (p * 60), size.height / 2 + 50 - (p * 50)),
        20,
        hp,
      );
    }
  }

  void _drawParallelParking(Canvas canvas, Size size, double p) {
    _drawCar(canvas, Offset(100, size.height - 35), 0, Colors.grey);
    _drawCar(canvas, Offset(260, size.height - 35), 0, Colors.grey);

    double cx = 180 + (1 - p) * 40;
    double cy = size.height - 35 - (1 - p) * 30;
    _drawCar(canvas, Offset(cx, cy), (1 - p) * 0.4, AppColors.primaryAccent);

    if (isHighlighted) {
      _drawPathLine(
        canvas,
        Offset(220, size.height - 65),
        Offset(180, size.height - 35),
        p,
      );
    }
  }

  void _drawHillParking(Canvas canvas, Size size, double p) {
    canvas.save();
    canvas.translate(0, 40);
    canvas.rotate(-0.15); // incline match

    _drawCar(
      canvas,
      Offset(size.width / 2, 70),
      isHighlighted ? p * 0.4 : 0,
      AppColors.primaryAccent,
    );

    if (isHighlighted) {
      // highlight wheels
      final hp = Paint()
        ..color = AppColors.warning
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(Offset(size.width / 2 + 15, 60), 8 + p * 4, hp);
    }

    canvas.restore();
  }

  void _drawEmergencyVehicle(Canvas canvas, Size size, double p) {
    // Player car pulling over
    _drawCar(
      canvas,
      Offset(150 + p * 50, size.height / 2 + 20 + p * 30),
      p * 0.2,
      AppColors.primaryAccent,
    );

    // Ambulance
    _drawCar(canvas, Offset(50 + p * 150, size.height / 2 + 20), 0, Colors.red);
    // flashing lights
    if (p > 0 && (p * 10).toInt() % 2 == 0) {
      canvas.drawCircle(
        Offset(60 + p * 150, size.height / 2 + 10),
        5,
        Paint()..color = Colors.blue,
      );
      canvas.drawCircle(
        Offset(60 + p * 150, size.height / 2 + 30),
        5,
        Paint()..color = Colors.redAccent,
      );
    }

    if (isHighlighted) {
      _drawPathLine(
        canvas,
        Offset(150, size.height / 2 + 20),
        Offset(200, size.height - 30),
        p,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ScenarioPainter oldDelegate) {
    return oldDelegate.animationProgress != animationProgress ||
        oldDelegate.isHighlighted != isHighlighted ||
        oldDelegate.type != type;
  }
}
