/// Realistic mock driving test questions.
///
/// Separated from UI so question data can later come from
/// an API, local DB, or asset bundle without changing the UI layer.
library;

import 'models/question.dart';

/// 20 realistic driving test questions covering common categories.
const List<Question> mockQuestions = [
  // ─── Road Signs & Signals ────────────────────────────────────────────

  Question(
    id: 'rs-001',
    category: 'Road Signs & Signals',
    text: 'What does a flashing red traffic light mean?',
    options: [
      'Stop, then proceed when safe',
      'Slow down and proceed with caution',
      'Continue at normal speed',
      'Yield to oncoming traffic only',
    ],
    correctIndex: 0,
    explanation:
        'A flashing red light is treated like a stop sign. You must come to a '
        'complete stop, check for traffic and pedestrians, and then proceed '
        'when it is safe to do so.',
  ),

  Question(
    id: 'rs-002',
    category: 'Road Signs & Signals',
    text: 'A solid yellow traffic light means:',
    options: [
      'Speed up to clear the intersection',
      'Stop if you can do so safely',
      'The light is about to turn green',
      'Proceed with caution',
    ],
    correctIndex: 1,
    explanation:
        'A solid yellow light warns that the signal is about to turn red. '
        'You should stop if you can do so safely. If you are already in the '
        'intersection or cannot stop safely, proceed with caution.',
  ),

  Question(
    id: 'rs-003',
    category: 'Road Signs & Signals',
    text: 'An octagonal (eight-sided) sign always means:',
    options: [
      'Yield',
      'No entry',
      'Stop',
      'Railroad crossing',
    ],
    correctIndex: 2,
    explanation:
        'The octagonal shape is exclusively used for stop signs worldwide. '
        'When you see this shape, you must always come to a complete stop, '
        'regardless of whether you can read the text on the sign.',
  ),

  Question(
    id: 'rs-004',
    category: 'Road Signs & Signals',
    text: 'What does a diamond-shaped sign indicate?',
    options: [
      'Regulatory information',
      'A warning about road conditions',
      'Guide or directional information',
      'Construction zone ahead',
    ],
    correctIndex: 1,
    explanation:
        'Diamond-shaped signs are warning signs. They alert drivers to '
        'upcoming road conditions, hazards, or changes in the road layout '
        'that require caution.',
  ),

  // ─── Right of Way ────────────────────────────────────────────────────

  Question(
    id: 'rw-001',
    category: 'Right of Way',
    text: 'At an intersection with no traffic signs or signals, you must yield to:',
    options: [
      'The vehicle on your left',
      'The vehicle on your right',
      'The fastest vehicle',
      'The largest vehicle',
    ],
    correctIndex: 1,
    explanation:
        'At an uncontrolled intersection (no signs, signals, or pavement '
        'markings), you must yield to the vehicle on your right. This is '
        'known as the "right-of-way" rule.',
  ),

  Question(
    id: 'rw-002',
    category: 'Right of Way',
    text: 'When approaching a roundabout, you must:',
    options: [
      'Speed up to merge quickly',
      'Yield to traffic already in the roundabout',
      'Stop completely before entering',
      'Honk to alert other drivers',
    ],
    correctIndex: 1,
    explanation:
        'Vehicles already inside the roundabout have the right of way. '
        'You must yield and wait for a safe gap before entering. Always '
        'travel counterclockwise in the roundabout.',
  ),

  Question(
    id: 'rw-003',
    category: 'Right of Way',
    text: 'You must always yield the right of way to:',
    options: [
      'Vehicles turning left',
      'Pedestrians in a marked crosswalk',
      'Vehicles on a smaller road',
      'Parked cars pulling out',
    ],
    correctIndex: 1,
    explanation:
        'Pedestrians in marked crosswalks always have the right of way. '
        'Drivers must stop and allow them to cross safely, regardless of '
        'traffic signals.',
  ),

  // ─── Traffic Rules ───────────────────────────────────────────────────

  Question(
    id: 'tr-001',
    category: 'Traffic Rules',
    text: 'What is the legal blood alcohol concentration (BAC) limit for most adult drivers?',
    options: [
      '0.05%',
      '0.08%',
      '0.10%',
      '0.02%',
    ],
    correctIndex: 1,
    explanation:
        'In most US states, the legal BAC limit is 0.08% for drivers aged 21 '
        'and over. However, impairment can begin at much lower levels. '
        'The safest choice is to never drink and drive.',
  ),

  Question(
    id: 'tr-002',
    category: 'Traffic Rules',
    text: 'When is it legal to pass another vehicle on the right?',
    options: [
      'Never — passing on the right is always illegal',
      'When the vehicle ahead is making a left turn',
      'Whenever there is enough room on the shoulder',
      'Only on one-way streets',
    ],
    correctIndex: 1,
    explanation:
        'You may pass on the right when the vehicle ahead is making or '
        'about to make a left turn, and there is sufficient roadway for '
        'you to pass safely without leaving the paved surface.',
  ),

  Question(
    id: 'tr-003',
    category: 'Traffic Rules',
    text: 'You are required to use your turn signal:',
    options: [
      'Only when other vehicles are nearby',
      'At least 100 feet before turning',
      'Only at intersections',
      'Only when changing lanes on a highway',
    ],
    correctIndex: 1,
    explanation:
        'You must signal at least 100 feet (about 5 car lengths) before '
        'turning or changing lanes. This gives other drivers and pedestrians '
        'time to react to your intended maneuver.',
  ),

  // ─── Safety & Emergencies ────────────────────────────────────────────

  Question(
    id: 'se-001',
    category: 'Safety & Emergencies',
    text: 'What should you do if your brakes fail while driving?',
    options: [
      'Turn off the engine immediately',
      'Pump the brakes and downshift to a lower gear',
      'Open the door and drag your foot on the ground',
      'Turn the steering wheel sharply to slow down',
    ],
    correctIndex: 1,
    explanation:
        'If your brakes fail, pump the brake pedal rapidly to build up '
        'pressure. Downshift to a lower gear to use engine braking. '
        'Use the parking brake gently, and look for a safe area to stop.',
  ),

  Question(
    id: 'se-002',
    category: 'Safety & Emergencies',
    text: 'The minimum safe following distance in normal conditions is:',
    options: [
      '1 second',
      '2 seconds',
      '3 seconds',
      '5 seconds',
    ],
    correctIndex: 2,
    explanation:
        'The "3-second rule" provides a safe following distance in normal '
        'conditions. Pick a fixed point ahead. When the car in front passes '
        'it, count "one-thousand-one, one-thousand-two, one-thousand-three." '
        'Increase distance in poor weather.',
  ),

  Question(
    id: 'se-003',
    category: 'Safety & Emergencies',
    text: 'If your vehicle starts to skid, you should:',
    options: [
      'Slam on the brakes',
      'Turn the wheel in the opposite direction of the skid',
      'Steer in the direction the rear of the vehicle is sliding',
      'Accelerate to regain traction',
    ],
    correctIndex: 2,
    explanation:
        'When your vehicle skids, take your foot off the gas and steer '
        'in the direction the rear of the vehicle is sliding (this is '
        'called "steering into the skid"). Do not brake suddenly, as this '
        'can make the skid worse.',
  ),

  Question(
    id: 'se-004',
    category: 'Safety & Emergencies',
    text: 'When driving in heavy fog, you should use:',
    options: [
      'High-beam headlights',
      'Low-beam headlights',
      'Parking lights only',
      'Hazard flashers',
    ],
    correctIndex: 1,
    explanation:
        'In fog, always use low-beam headlights. High beams reflect off the '
        'fog and create glare, reducing your visibility further. Some vehicles '
        'also have fog lights specifically designed for these conditions.',
  ),

  // ─── Parking ─────────────────────────────────────────────────────────

  Question(
    id: 'pk-001',
    category: 'Parking',
    text: 'When parking uphill on a street with a curb, you should turn your front wheels:',
    options: [
      'Toward the curb',
      'Away from the curb',
      'Straight ahead',
      'It doesn\'t matter',
    ],
    correctIndex: 1,
    explanation:
        'When parking uphill with a curb, turn your front wheels away from '
        'the curb (to the left). If your vehicle rolls backward, the back of '
        'the front tire will catch the curb and prevent the car from rolling '
        'into traffic.',
  ),

  Question(
    id: 'pk-002',
    category: 'Parking',
    text: 'How far must you park from a fire hydrant?',
    options: [
      '5 feet',
      '10 feet',
      '15 feet',
      '20 feet',
    ],
    correctIndex: 2,
    explanation:
        'You must park at least 15 feet away from a fire hydrant. This '
        'ensures that firefighters can quickly access the hydrant in an '
        'emergency. Parking too close may result in a ticket or your vehicle '
        'being towed.',
  ),

  // ─── Highway Driving ─────────────────────────────────────────────────

  Question(
    id: 'hw-001',
    category: 'Highway Driving',
    text: 'When merging onto a highway, you should:',
    options: [
      'Stop at the end of the acceleration lane and wait',
      'Match the speed of highway traffic before merging',
      'Always drive slower than the highway traffic',
      'Merge immediately regardless of traffic',
    ],
    correctIndex: 1,
    explanation:
        'Use the acceleration lane to match the speed of highway traffic '
        'before merging. Check your mirrors and blind spots, signal, and '
        'merge smoothly into a gap in traffic. Stopping on the ramp can '
        'be very dangerous.',
  ),

  Question(
    id: 'hw-002',
    category: 'Highway Driving',
    text: 'What does a white dashed line between lanes mean?',
    options: [
      'No passing allowed',
      'Lane changes are permitted',
      'Reserved for emergency vehicles',
      'One-way traffic only',
    ],
    correctIndex: 1,
    explanation:
        'White dashed lines separate lanes of traffic moving in the same '
        'direction. They indicate that lane changes are permitted when safe. '
        'Solid white lines discourage lane changes, and double solid lines '
        'prohibit them.',
  ),

  // ─── Vehicle Control ─────────────────────────────────────────────────

  Question(
    id: 'vc-001',
    category: 'Vehicle Control',
    text: 'Hydroplaning is most likely to occur when:',
    options: [
      'Driving on dry pavement in summer',
      'The first few minutes of rainfall on an oily road',
      'Driving on snow-packed roads',
      'Driving on gravel roads',
    ],
    correctIndex: 1,
    explanation:
        'Hydroplaning is most likely during the first few minutes of rain '
        'when water mixes with oil on the road surface, creating a slippery '
        'film. Reduce speed and avoid sudden braking or steering when roads '
        'are wet.',
  ),
];

/// Get a subset of questions for a quick practice session.
List<Question> getQuickPracticeQuestions({int count = 10}) {
  final shuffled = List<Question>.from(mockQuestions)..shuffle();
  return shuffled.take(count).toList();
}

/// Get questions by category.
List<Question> getQuestionsByCategory(String category) {
  return mockQuestions.where((q) => q.category == category).toList();
}
