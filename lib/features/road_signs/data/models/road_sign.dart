library;

import 'package:flutter/material.dart';

/// Represents a single road sign in the learning section.
/// 
/// Data is separated from UI. In a real app, this could be hydrated
/// from a local database or API. Since we lack image assets, we use
/// [iconData], [shape], and [color] to procedurally generate a placeholder.
class RoadSign {
  const RoadSign({
    required this.id,
    required this.name,
    required this.category,
    required this.meaning,
    required this.actionRequired,
    required this.exampleSituation,
    required this.iconData,
    required this.color,
    this.shape = RoadSignShape.rectangle,
    this.foregroundColor = Colors.white,
  });

  final String id;
  final String name;
  final String category;
  
  /// Short description of what the sign means.
  final String meaning;
  
  /// What the driver must explicitly do.
  final String actionRequired;
  
  /// A realistic scenario where this sign appears.
  final String exampleSituation;
  
  // UI Placeholder properties (until real images are available)
  final IconData iconData;
  final Color color;
  final Color foregroundColor;
  final RoadSignShape shape;
}

/// The geometric shape of the sign for the procedural placeholder.
enum RoadSignShape {
  octagon,
  triangle, // point up or down depending on type (Yield is down, Warning is usually diamond, but we'll use diamond)
  diamond,
  rectangle, // vertical or horizontal
  circle,
  pentagon, // School zone
  crossbuck, // Railroad
}
