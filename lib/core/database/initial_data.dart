import 'package:drift/drift.dart';

import 'app_database.dart';

List<QuestionsCompanion> getInitialQuestions() {
  return [
    // --- ROAD RULES ---
    QuestionsCompanion.insert(
      id: 'q_rr_01',
      state: 'CA',
      licenseType: 'ClassC',
      category: 'Road Rules',
      difficulty: 1, // Easy
      questionText: 'When driving in fog, you should use your:',
      answerA: 'High-beam headlights',
      answerB: 'Low-beam headlights',
      answerC: 'Parking lights only',
      correctAnswerIndex: 1,
      explanationShort: 'Always use low-beam headlights in fog.',
      explanationDetailed: Value(''),
      sourceReference: Value(''),
    ),
    QuestionsCompanion.insert(
      id: 'q_rr_02',
      state: 'CA',
      licenseType: 'ClassC',
      category: 'Road Rules',
      difficulty: 2, // Medium
      questionText: 'If your vehicle starts to hydroplane, you should:',
      answerA: 'Brake hard to stop quickly.',
      answerB: 'Turn the steering wheel sharply.',
      answerC: 'Gradually ease off the accelerator.',
      correctAnswerIndex: 2,
      explanationShort: 'Ease off the gas and do not brake hard.',
      explanationDetailed: Value(''),
      sourceReference: Value(''),
    ),
    // --- TRAFFIC SIGNS ---
    QuestionsCompanion.insert(
      id: 'q_ts_01',
      state: 'CA',
      licenseType: 'ClassC',
      category: 'Traffic Signs',
      difficulty: 1, // Easy
      questionText:
          'A solid yellow line on your side of the center line means:',
      answerA: 'You may pass if the way is clear.',
      answerB: 'Do not pass.',
      answerC: 'You are in a one-way street.',
      correctAnswerIndex: 1,
      explanationShort: 'A solid yellow line means no passing.',
      explanationDetailed: Value(''),
      sourceReference: Value(''),
    ),
    QuestionsCompanion.insert(
      id: 'q_ts_02',
      state: 'CA',
      licenseType: 'ClassC',
      category: 'Traffic Signs',
      difficulty: 2, // Medium
      questionText: 'What does a flashing yellow traffic signal at an intersection indicate?',
      answerA: 'Stop and wait for a green light.',
      answerB: 'Slow down and be alert before proceeding.',
      answerC: 'The traffic signal is broken, treat it as a four-way stop.',
      correctAnswerIndex: 1,
      explanationShort: 'Proceed with caution.',
      explanationDetailed: Value(''),
      sourceReference: Value(''),
    ),
    // --- RIGHT OF WAY ---
    QuestionsCompanion.insert(
      id: 'q_rw_01',
      state: 'CA',
      licenseType: 'ClassC',
      category: 'Right of Way',
      difficulty: 2, // Medium
      questionText: 'Two vehicles reach an uncontrolled intersection at the same time. Who has the right-of-way?',
      answerA: 'The vehicle on the left.',
      answerB: 'The vehicle on the right.',
      answerC: 'The vehicle that is traveling faster.',
      correctAnswerIndex: 1,
      explanationShort: 'Yield to the vehicle on your right.',
      explanationDetailed: Value(''),
      sourceReference: Value(''),
    ),
    QuestionsCompanion.insert(
      id: 'q_rw_02',
      state: 'CA',
      licenseType: 'ClassC',
      category: 'Right of Way',
      difficulty: 3, // Hard
      questionText: 'When turning left at an intersection, you must yield to:',
      answerA: 'Vehicles approaching from the rear.',
      answerB: 'Cross traffic only.',
      answerC: 'Oncoming vehicles that are close enough to be a hazard.',
      correctAnswerIndex: 2,
      explanationShort: 'Yield to oncoming traffic.',
      explanationDetailed: Value(''),
      sourceReference: Value(''),
    ),
    // --- SPEED & DISTANCE ---
    QuestionsCompanion.insert(
      id: 'q_sd_01',
      state: 'CA',
      licenseType: 'ClassC',
      category: 'Speed & Distance',
      difficulty: 1, // Easy
      questionText: 'What is the speed limit in a residential area unless otherwise posted?',
      answerA: '25 mph',
      answerB: '35 mph',
      answerC: '15 mph',
      correctAnswerIndex: 0,
      explanationShort: 'The speed limit is 25 mph in residential districts.',
      explanationDetailed: Value(''),
      sourceReference: Value(''),
    ),
    QuestionsCompanion.insert(
      id: 'q_sd_02',
      state: 'CA',
      licenseType: 'ClassC',
      category: 'Speed & Distance',
      difficulty: 2, // Medium
      questionText: 'What is the recommended safe following distance under normal driving conditions?',
      answerA: 'One car length per 10 mph.',
      answerB: 'The "three-second rule".',
      answerC: '50 feet.',
      correctAnswerIndex: 1,
      explanationShort: 'Use the three-second rule.',
      explanationDetailed: Value(''),
      sourceReference: Value(''),
    ),
    // --- INTERSECTIONS ---
    QuestionsCompanion.insert(
      id: 'q_in_01',
      state: 'CA',
      licenseType: 'ClassC',
      category: 'Intersections',
      difficulty: 3, // Hard
      questionText:
          'You enter a roundabout. Which direction should you travel?',
      answerA: 'Clockwise.',
      answerB: 'Counter-clockwise.',
      answerC: 'Either direction, depending on your exit.',
      correctAnswerIndex: 1,
      explanationShort: 'Always travel counter-clockwise.',
      explanationDetailed: Value(''),
      sourceReference: Value(''),
    ),
    // --- LANE CONTROL ---
    QuestionsCompanion.insert(
      id: 'q_lc_01',
      state: 'CA',
      licenseType: 'ClassC',
      category: 'Lane Control',
      difficulty: 2, // Medium
      questionText: 'When can you drive in a bike lane?',
      answerA: 'Whenever traffic is heavy.',
      answerB: 'Only when preparing to make a right turn within 200 feet of the intersection.',
      answerC: 'You may never drive in a bike lane.',
      correctAnswerIndex: 1,
      explanationShort: 'Only when turning right, within 200 feet.',
      explanationDetailed: Value(''),
      sourceReference: Value(''),
    ),
    // --- PARKING ---
    QuestionsCompanion.insert(
      id: 'q_pk_01',
      state: 'CA',
      licenseType: 'ClassC',
      category: 'Parking',
      difficulty: 2, // Medium
      questionText: 'When parking your vehicle downhill on a street with a curb, you should:',
      answerA: 'Turn your front wheels away from the curb.',
      answerB: 'Turn your front wheels toward the curb.',
      answerC: 'Keep your wheels straight.',
      correctAnswerIndex: 1,
      explanationShort: 'Turn wheels toward the curb.',
      explanationDetailed: Value(''),
      sourceReference: Value(''),
    ),
    QuestionsCompanion.insert(
      id: 'q_pk_02',
      state: 'CA',
      licenseType: 'ClassC',
      category: 'Parking',
      difficulty: 1, // Easy
      questionText: 'A white painted curb means:',
      answerA: 'Parking for loading or unloading passengers or mail only.',
      answerB: 'Parking for commercial vehicles only.',
      answerC: 'No stopping, standing, or parking.',
      correctAnswerIndex: 0,
      explanationShort: 'White curbs are for loading passengers or mail.',
      explanationDetailed: Value(''),
      sourceReference: Value(''),
    ),
    // --- SHARING THE ROAD ---
    QuestionsCompanion.insert(
      id: 'q_sr_01',
      state: 'CA',
      licenseType: 'ClassC',
      category: 'Sharing the Road',
      difficulty: 3, // Hard
      questionText: 'Large trucks have larger blind spots than passenger vehicles. These are called:',
      answerA: 'No-Zones.',
      answerB: 'Zero-Zones.',
      answerC: 'Blind-Zones.',
      correctAnswerIndex: 0,
      explanationShort: 'They are called No-Zones.',
      explanationDetailed: Value(''),
      sourceReference: Value(''),
    ),
    QuestionsCompanion.insert(
      id: 'q_sr_02',
      state: 'CA',
      licenseType: 'ClassC',
      category: 'Sharing the Road',
      difficulty: 2, // Medium
      questionText: 'When you hear a siren from an emergency vehicle approaching, you must:',
      answerA: 'Speed up to get out of the way.',
      answerB: 'Pull over to the right edge of the road and stop.',
      answerC: 'Stop immediately in your current lane.',
      correctAnswerIndex: 1,
      explanationShort: 'Pull to the right and stop.',
      explanationDetailed: Value(''),
      sourceReference: Value(''),
    ),
    // --- SAFE DRIVING ---
    QuestionsCompanion.insert(
      id: 'q_sa_01',
      state: 'CA',
      licenseType: 'ClassC',
      category: 'Safe Driving',
      difficulty: 1, // Easy
      questionText: 'Using a handheld cell phone while driving is:',
      answerA: 'Allowed if you are over 18.',
      answerB: 'Allowed only at stop lights.',
      answerC: 'Illegal at all times.',
      correctAnswerIndex: 2,
      explanationShort: 'It is illegal in California.',
      explanationDetailed: Value(''),
      sourceReference: Value(''),
    ),
    QuestionsCompanion.insert(
      id: 'q_sa_02',
      state: 'CA',
      licenseType: 'ClassC',
      category: 'Safe Driving',
      difficulty: 2, // Medium
      questionText: 'If you are involved in a collision where someone is injured, you must report it to the DMV within:',
      answerA: '24 hours.',
      answerB: '10 days.',
      answerC: '30 days.',
      correctAnswerIndex: 1,
      explanationShort: 'Report to DMV within 10 days.',
      explanationDetailed: Value(''),
      sourceReference: Value(''),
    ),
    // --- EMERGENCIES ---
    QuestionsCompanion.insert(
      id: 'q_em_01',
      state: 'CA',
      licenseType: 'ClassC',
      category: 'Emergencies',
      difficulty: 3, // Hard
      questionText:
          'If a tire blows out while you are driving, you should first:',
      answerA: 'Brake hard to stop quickly.',
      answerB: 'Hold the steering wheel tightly and steer straight.',
      answerC: 'Quickly turn the wheel to the side of the road.',
      correctAnswerIndex: 1,
      explanationShort: 'Hold the wheel firmly and steer straight.',
      explanationDetailed: Value(''),
      sourceReference: Value(''),
    ),
    QuestionsCompanion.insert(
      id: 'q_em_02',
      state: 'CA',
      licenseType: 'ClassC',
      category: 'Emergencies',
      difficulty: 2, // Medium
      questionText: 'If your vehicle\'s accelerator sticks, you should:',
      answerA: 'Turn off the ignition immediately.',
      answerB: 'Shift into neutral and apply the brakes.',
      answerC: 'Pump the gas pedal rapidly.',
      correctAnswerIndex: 1,
      explanationShort: 'Shift to neutral and brake.',
      explanationDetailed: Value(''),
      sourceReference: Value(''),
    ),
    // --- RIGHT OF WAY (Additional) ---
    QuestionsCompanion.insert(
      id: 'q_rw_03',
      state: 'CA',
      licenseType: 'ClassC',
      category: 'Right of Way',
      difficulty: 1, // Easy
      questionText: 'Pedestrians crossing at corners have the right-of-way:',
      answerA: 'Only when a crosswalk is painted.',
      answerB: 'Whether or not a crosswalk is painted.',
      answerC: 'Only if they are in a school zone.',
      correctAnswerIndex: 1,
      explanationShort: 'Pedestrians always have the right-of-way at corners.',
      explanationDetailed: Value(''),
      sourceReference: Value(''),
    ),
    // --- TRAFFIC SIGNS (Additional) ---
    QuestionsCompanion.insert(
      id: 'q_ts_03',
      state: 'CA',
      licenseType: 'ClassC',
      category: 'Traffic Signs',
      difficulty: 2, // Medium
      questionText: 'A pennant-shaped sign indicates:',
      answerA: 'A school zone.',
      answerB: 'A railroad crossing.',
      answerC: 'A no passing zone.',
      correctAnswerIndex: 2,
      explanationShort: 'A pennant shape means no passing.',
      explanationDetailed: Value(''),
      sourceReference: Value(''),
    ),
  ];
}

