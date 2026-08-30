library;

import 'package:flutter/material.dart';
import 'models/road_sign.dart';

/// Categories for filtering.
const List<String> roadSignCategories = [
  'All',
  'Warning',
  'Regulatory',
  'Guide',
  'School Zone',
  'Railroad',
];

/// Mock data for Road Signs.
const List<RoadSign> mockRoadSigns = [
  // ─── Regulatory Signs ──────────────────────────────────────────────────
  RoadSign(
    id: 'reg-001',
    name: 'Stop Sign',
    category: 'Regulatory',
    meaning: 'Come to a complete stop before the crosswalk or intersection.',
    actionRequired: 'Stop completely. Look for traffic and pedestrians. Yield the right-of-way, then proceed when safe.',
    exampleSituation: 'Approaching an intersection with cross traffic that does not stop.',
    iconData: Icons.pan_tool_rounded,
    color: Color(0xFFD32F2F), // Red
    shape: RoadSignShape.octagon,
  ),
  RoadSign(
    id: 'reg-002',
    name: 'Yield Sign',
    category: 'Regulatory',
    meaning: 'Slow down and give the right-of-way to traffic in the intersection or roadway you are entering.',
    actionRequired: 'Slow down. Be prepared to stop if necessary. Proceed only when it is safe.',
    exampleSituation: 'Merging onto a highway or entering a roundabout.',
    iconData: Icons.change_history_rounded, // Best approx for yield (downward triangle visually handled by rotation later)
    color: Color(0xFFD32F2F), 
    shape: RoadSignShape.triangle,
  ),
  RoadSign(
    id: 'reg-003',
    name: 'Speed Limit',
    category: 'Regulatory',
    meaning: 'Indicates the maximum legal speed allowed under ideal driving conditions.',
    actionRequired: 'Do not exceed the posted speed limit. Adjust speed downward for poor weather or traffic.',
    exampleSituation: 'Driving on a residential street or highway.',
    iconData: Icons.speed_rounded,
    color: Colors.white,
    foregroundColor: Colors.black,
    shape: RoadSignShape.rectangle,
  ),
  RoadSign(
    id: 'reg-004',
    name: 'Do Not Enter',
    category: 'Regulatory',
    meaning: 'You are traveling in the wrong direction or entering a restricted road.',
    actionRequired: 'Do not proceed past this sign. Turn around or find an alternate route.',
    exampleSituation: 'Approaching a one-way street from the wrong direction or an off-ramp.',
    iconData: Icons.remove_circle_rounded,
    color: Color(0xFFD32F2F),
    shape: RoadSignShape.circle,
  ),

  // ─── Warning Signs ─────────────────────────────────────────────────────
  RoadSign(
    id: 'wrn-001',
    name: 'Curve Ahead',
    category: 'Warning',
    meaning: 'The road curves ahead. A recommended speed limit may be posted below it.',
    actionRequired: 'Slow down before entering the curve and stay in your lane.',
    exampleSituation: 'Driving on a winding country road.',
    iconData: Icons.turn_right_rounded,
    color: Color(0xFFFBC02D), // Yellow
    foregroundColor: Colors.black,
    shape: RoadSignShape.diamond,
  ),
  RoadSign(
    id: 'wrn-002',
    name: 'Slippery When Wet',
    category: 'Warning',
    meaning: 'The road surface is unusually slick when it rains or snows.',
    actionRequired: 'Reduce speed significantly when the road is wet. Avoid sudden braking or sharp turns.',
    exampleSituation: 'Approaching a bridge or a freshly paved asphalt section during a rainstorm.',
    iconData: Icons.water_drop_rounded,
    color: Color(0xFFFBC02D),
    foregroundColor: Colors.black,
    shape: RoadSignShape.diamond,
  ),
  RoadSign(
    id: 'wrn-003',
    name: 'Pedestrian Crossing',
    category: 'Warning',
    meaning: 'Pedestrians may be crossing the road ahead.',
    actionRequired: 'Slow down, scan the sides of the road, and be prepared to stop for pedestrians.',
    exampleSituation: 'Approaching a crosswalk in a busy downtown area.',
    iconData: Icons.directions_walk_rounded,
    color: Color(0xFFFBC02D),
    foregroundColor: Colors.black,
    shape: RoadSignShape.diamond,
  ),
  RoadSign(
    id: 'wrn-004',
    name: 'Traffic Signal Ahead',
    category: 'Warning',
    meaning: 'A traffic light is located at the upcoming intersection.',
    actionRequired: 'Be prepared to stop if the light is red or yellow. Do not speed up.',
    exampleSituation: 'Approaching a concealed intersection over a hill.',
    iconData: Icons.traffic_rounded,
    color: Color(0xFFFBC02D),
    foregroundColor: Colors.black,
    shape: RoadSignShape.diamond,
  ),

  // ─── School Zone & Railroad ────────────────────────────────────────────
  RoadSign(
    id: 'sch-001',
    name: 'School Zone',
    category: 'School Zone',
    meaning: 'You are entering a school zone. Children may be present.',
    actionRequired: 'Slow down to the school zone speed limit (usually 15-20 mph). Watch for children and crossing guards.',
    exampleSituation: 'Driving past an elementary school during morning drop-off.',
    iconData: Icons.school_rounded,
    color: Color(0xFFC6FF00), // Fluorescent yellow-green
    foregroundColor: Colors.black,
    shape: RoadSignShape.pentagon,
  ),
  RoadSign(
    id: 'rr-001',
    name: 'Railroad Crossing',
    category: 'Railroad',
    meaning: 'A railroad crossing is ahead. Trains have the right-of-way.',
    actionRequired: 'Look, listen, and slow down. Be prepared to stop at least 15 feet from the tracks if a train is approaching.',
    exampleSituation: 'Approaching train tracks intersecting the highway.',
    iconData: Icons.train_rounded,
    color: Color(0xFFFBC02D),
    foregroundColor: Colors.black,
    shape: RoadSignShape.circle,
  ),

  // ─── Guide Signs ───────────────────────────────────────────────────────
  RoadSign(
    id: 'gui-001',
    name: 'Hospital',
    category: 'Guide',
    meaning: 'Indicates the direction and location of a hospital.',
    actionRequired: 'Follow the arrows if you need medical assistance. Be aware of ambulances entering/exiting.',
    exampleSituation: 'Looking for the nearest emergency room on a highway.',
    iconData: Icons.local_hospital_rounded,
    color: Color(0xFF1976D2), // Blue
    shape: RoadSignShape.rectangle,
  ),
  RoadSign(
    id: 'gui-002',
    name: 'Highway Exit',
    category: 'Guide',
    meaning: 'Provides advance notice of an upcoming highway exit.',
    actionRequired: 'Move into the appropriate lane early and signal your intention to exit.',
    exampleSituation: 'Approaching your destination on an interstate.',
    iconData: Icons.exit_to_app_rounded,
    color: Color(0xFF388E3C), // Green
    shape: RoadSignShape.rectangle,
  ),
];
