import 'package:flutter/material.dart';

class AppMotion {
  // Durations
  static const Duration quick = Duration(milliseconds: 160);
  static const Duration standard = Duration(milliseconds: 280);
  static const Duration expressive = Duration(milliseconds: 420);
  static const Duration hero = Duration(milliseconds: 600);

  // Curves
  static const Curve standardEasing = Curves.easeOutCubic;
  static const Curve standardAccelerate = Curves.easeInCubic;
  
  static const Curve springSubtle = Curves.easeOutBack;

  static const Curve springExpressive = Curves.elasticOut;
}
