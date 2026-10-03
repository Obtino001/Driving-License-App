import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Small line drawings that reuse the route's road-marking geometry.
class ModuleMotif extends StatelessWidget {
  const ModuleMotif({super.key, required this.category, this.size = 48});
  final String category;
  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: RepaintBoundary(
      child: CustomPaint(painter: _ModuleMotifPainter(category)),
    ),
  );
}

class _ModuleMotifPainter extends CustomPainter {
  const _ModuleMotifPainter(this.category);
  final String category;

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 48;
    final sy = size.height / 48;
    canvas.save();
    canvas.scale(sx, sy);
    final ink = Paint()
      ..color = AppColors.primaryDark
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    final accent = Paint()
      ..color = const Color(0xFF849B28)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    switch (category) {
      case 'Traffic Signs':
        final diamond = Path()
          ..moveTo(24, 4)
          ..lineTo(44, 24)
          ..lineTo(24, 44)
          ..lineTo(4, 24)
          ..close();
        canvas.drawPath(diamond, ink);
        canvas.drawLine(const Offset(24, 15), const Offset(24, 29), accent);
        canvas.drawCircle(
          const Offset(24, 35),
          1.8,
          Paint()..color = accent.color,
        );
      case 'Right of Way':
      case 'Intersections':
        canvas.drawLine(const Offset(5, 24), const Offset(43, 24), ink);
        canvas.drawLine(const Offset(24, 5), const Offset(24, 43), ink);
        canvas.drawCircle(
          const Offset(24, 24),
          5,
          Paint()..color = accent.color,
        );
      case 'Parking':
        canvas.drawRect(const Rect.fromLTWH(7, 5, 34, 38), ink);
        canvas.drawLine(const Offset(17, 35), const Offset(17, 13), accent);
        canvas.drawLine(const Offset(17, 14), const Offset(29, 14), accent);
        canvas.drawArc(
          const Rect.fromLTWH(18, 12, 17, 16),
          -.8,
          2.5,
          false,
          accent,
        );
      case 'Safe Driving':
        final shield = Path()
          ..moveTo(24, 3)
          ..lineTo(41, 10)
          ..lineTo(39, 29)
          ..quadraticBezierTo(34, 40, 24, 45)
          ..quadraticBezierTo(14, 40, 9, 29)
          ..lineTo(7, 10)
          ..close();
        canvas.drawPath(shield, ink);
        canvas.drawLine(const Offset(17, 25), const Offset(22, 30), accent);
        canvas.drawLine(const Offset(22, 30), const Offset(32, 18), accent);
      case 'Speed & Distance':
        canvas.drawLine(const Offset(5, 16), const Offset(43, 16), ink);
        canvas.drawLine(const Offset(5, 32), const Offset(43, 32), ink);
        canvas.drawLine(const Offset(13, 24), const Offset(35, 24), accent);
        canvas.drawCircle(
          const Offset(13, 24),
          2.5,
          Paint()..color = accent.color,
        );
        canvas.drawCircle(
          const Offset(35, 24),
          2.5,
          Paint()..color = accent.color,
        );
      default:
        canvas.drawLine(const Offset(8, 4), const Offset(8, 44), ink);
        canvas.drawLine(const Offset(40, 4), const Offset(40, 44), ink);
        for (double y = 6; y < 44; y += 13) {
          canvas.drawLine(Offset(24, y), Offset(24, y + 6), accent);
        }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ModuleMotifPainter oldDelegate) =>
      oldDelegate.category != category;
}
