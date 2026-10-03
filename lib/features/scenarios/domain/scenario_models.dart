import 'package:flutter/material.dart';

enum ScenarioType {
  fourWayIntersection,
  stopSignPriority,
  pedestrianCrossing,
  bicycleLane,
  highwayMerge,
  laneChange,
  parallelParking,
  hillParking,
  emergencyVehicle,
  leftTurnConflict,
}

enum ScenarioState { initial, highlighted }

class VisualScenario {
  final String id;
  final ScenarioType type;
  final List<ScenarioActor> actors;
  final Map<String, dynamic> metadata;

  const VisualScenario({
    required this.id,
    required this.type,
    this.actors = const [],
    this.metadata = const {},
  });
}

class ScenarioActor {
  final String id;
  final Color color;
  final Offset position;
  final double rotation;
  final bool isHighlighted;

  const ScenarioActor({
    required this.id,
    required this.color,
    required this.position,
    this.rotation = 0.0,
    this.isHighlighted = false,
  });
}
