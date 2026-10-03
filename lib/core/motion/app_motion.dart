import 'package:flutter/material.dart';

class AppMotion {
  // Durations
  static const Duration instant = Duration(milliseconds: 100);
  static const Duration quick = Duration(milliseconds: 160);
  static const Duration standard = Duration(milliseconds: 260);
  static const Duration expressive = Duration(milliseconds: 420);
  static const Duration hero = Duration(milliseconds: 720);

  // Curves
  static const Curve standardEasing = Cubic(0.2, 0.0, 0.0, 1.0);
  static const Curve decelerate = Cubic(0.0, 0.0, 0.0, 1.0);
  static const Curve emphasized = Cubic(0.2, 0.8, 0.2, 1.0);
  static const Curve standardAccelerate = Curves.easeInCubic;

  static const Curve springSubtle = Cubic(0.2, 0.8, 0.2, 1.0);
  static const Curve springExpressive = Cubic(0.2, 0.8, 0.2, 1.0);
}
